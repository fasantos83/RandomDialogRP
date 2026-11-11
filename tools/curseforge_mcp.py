import json
import os
import re
import tempfile
import zipfile
from pathlib import Path
from urllib import error, request

from mcp.server.fastmcp import FastMCP


mcp = FastMCP("CurseForge Publisher")
CURSEFORGE_API = "https://api.curseforge.com/v1"
EXCLUDED_NAMES = {".git", ".vscode", "__pycache__", "SavedVariables"}
EXCLUDED_SUFFIXES = {".zip", ".pyc"}


def _token() -> str:
    token = os.environ.get("CURSEFORGE_API_TOKEN")
    if not token:
        raise RuntimeError("CURSEFORGE_API_TOKEN is not set.")
    return token


def _resolve_addon_path(addon_path: str) -> tuple[Path, Path]:
    path = Path(addon_path).expanduser().resolve()
    if not path.is_dir():
        raise ValueError(f"Addon directory does not exist: {path}")
    toc_files = list(path.glob("*.toc"))
    if len(toc_files) != 1:
        raise ValueError(f"Expected exactly one .toc file in addon directory: {path}")
    return path, toc_files[0]


def _project_id_from_toc(toc_path: Path) -> int:
    for line in toc_path.read_text(encoding="utf-8-sig").splitlines():
        key, separator, value = line.partition(":")
        if separator and key.strip().removeprefix("##").strip() == "X-Curse-Project-ID":
            project_id = value.strip()
            if re.fullmatch(r"[1-9]\d*", project_id):
                return int(project_id)
            raise ValueError(f"Invalid X-Curse-Project-ID in {toc_path}: {project_id!r}")
    raise ValueError(f"Missing X-Curse-Project-ID in {toc_path}")


def _make_zip(addon_path: Path, toc_path: Path, destination: Path) -> None:
    package_name = toc_path.stem
    with zipfile.ZipFile(destination, "w", zipfile.ZIP_DEFLATED) as archive:
        for source in addon_path.rglob("*"):
            if not source.is_file():
                continue
            relative = source.relative_to(addon_path)
            if any(part in EXCLUDED_NAMES for part in relative.parts):
                continue
            if source.suffix.lower() in EXCLUDED_SUFFIXES:
                continue
            archive.write(source, Path(package_name) / relative)


def _multipart(fields: dict, file_field: str, file_name: str, file_data: bytes):
    boundary = "----RandomDialogRPCurseForgeBoundary"
    body = bytearray()
    for name, value in fields.items():
        body.extend(f"--{boundary}\r\n".encode())
        if isinstance(value, (list, dict)):
            body.extend(f'Content-Disposition: form-data; name="{name}"\r\n'.encode())
            body.extend(b"Content-Type: application/json\r\n\r\n")
            field_value = json.dumps(value)
        else:
            body.extend(f'Content-Disposition: form-data; name="{name}"\r\n\r\n'.encode())
            field_value = str(value)
        body.extend(field_value.encode())
        body.extend(b"\r\n")
    body.extend(f"--{boundary}\r\n".encode())
    body.extend(
        f'Content-Disposition: form-data; name="{file_field}"; filename="{file_name}"\r\n'.encode()
    )
    body.extend(b"Content-Type: application/zip\r\n\r\n")
    body.extend(file_data)
    body.extend(f"\r\n--{boundary}--\r\n".encode())
    return bytes(body), f"multipart/form-data; boundary={boundary}"


@mcp.tool()
def publish_curseforge_release(
    addon_path: str,
    version: str,
    changelog: str,
    project_id: int | None = None,
    release_type: str = "release",
    game_versions: list[str] | None = None,
) -> str:
    """Package and publish a World of Warcraft addon release to CurseForge."""
    if release_type not in {"release", "beta", "alpha"}:
        raise ValueError("release_type must be release, beta, or alpha.")
    if not version.strip():
        raise ValueError("version must not be empty.")
    if not changelog.strip():
        raise ValueError("changelog must not be empty.")

    addon, toc_path = _resolve_addon_path(addon_path)
    if project_id is None:
        project_id = _project_id_from_toc(toc_path)
    elif project_id < 1:
        raise ValueError("project_id must be a positive integer.")
    versions = game_versions or []
    with tempfile.TemporaryDirectory(prefix="randomdialogrp-") as temporary:
        archive_path = Path(temporary) / f"{toc_path.stem}-{version}.zip"
        _make_zip(addon, toc_path, archive_path)
        file_data = archive_path.read_bytes()

    metadata = {
        "displayName": f"{toc_path.stem} {version}",
        "changelog": changelog,
        "changelogType": "markdown",
        "releaseType": release_type,
        "gameVersions": versions,
    }
    body, content_type = _multipart({"metadata": metadata}, "file", archive_path.name, file_data)
    url = f"{CURSEFORGE_API}/mods/{project_id}/files"
    http_request = request.Request(
        url,
        data=body,
        method="POST",
        headers={
            "x-api-key": _token(),
            "Content-Type": content_type,
            "User-Agent": "RandomDialogRP CurseForge MCP",
        },
    )
    try:
        with request.urlopen(http_request, timeout=60) as response:
            result = json.loads(response.read().decode("utf-8"))
    except error.HTTPError as exc:
        details = exc.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"CurseForge upload failed ({exc.code}): {details}") from exc
    except error.URLError as exc:
        raise RuntimeError(f"CurseForge upload connection failed: {exc.reason}") from exc

    uploaded = result.get("data", {})
    return json.dumps(
        {
            "success": True,
            "file_id": uploaded.get("id"),
            "file_name": uploaded.get("fileName"),
            "download_url": uploaded.get("downloadUrl"),
        },
        indent=2,
    )


if __name__ == "__main__":
    mcp.run(transport="stdio")
