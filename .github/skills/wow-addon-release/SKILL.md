---
name: wow-addon-release
description: Prepare and publish a RandomDialogRP release by updating the version and changelog, committing and pushing an annotated version tag, and verifying Wago and CurseForge uploads. Use only when the user explicitly asks to release or publish this addon.
---

# RandomDialogRP release

When the user explicitly invokes this skill or asks to release/publish RandomDialogRP, complete the full release process. The invocation authorizes the normal commit, push, and publication steps; do not ask for redundant confirmation. Stop and ask only if the release contents, version, target branch, or changelog meaning is ambiguous.

## Release sources

- Addon version and project IDs are in `RandomDialogRP/RandomDialogRP.toc`.
- The package layout and manual changelog configuration are in `.pkgmeta`.
- `.github/workflows/release.yml` runs BigWigsMods/packager on numeric version tags.
- That workflow publishes to Wago and CurseForge, creates a GitHub release, and uses `WAGO_API_TOKEN`, `CF_API_KEY`, and `GITHUB_TOKEN` secrets.
- The addon source is under `RandomDialogRP/`. Do not include generated `releases/` archives in the commit.

## Procedure

1. Inspect `git status`, the complete staged/unstaged/untracked diff, the current branch and upstream, the TOC version, and the latest version tag. Do not discard, overwrite, or stage unrelated user work. If the worktree contains unrelated or unclear changes, ask which changes belong in this release.
2. Verify `.toc` has the Wago and CurseForge project IDs and `.pkgmeta` points to `CHANGELOG.md`. Check that the version is valid and newer than the latest release tag. Use the next patch version by default; use another version increment only when the user asks or the change clearly warrants it.
3. Run the repository's relevant checks. At minimum run `git diff --check`, inspect the final diff, and verify the TOC version and changelog heading agree. Do not proceed to publish if checks fail.
4. Create or update root `CHANGELOG.md` before committing. Put the new release first as `## <version> - <YYYY-MM-DD>`, followed by concise Markdown bullets grouped under `Added`, `Changed`, and/or `Fixed` as appropriate. Base the notes on the actual release diff, preserve prior entries, and do not claim unverified behavior.
5. Update `## Version:` in `RandomDialogRP/RandomDialogRP.toc` to the release version. Stage only the reviewed release files; never use a blanket stage command when it could include unrelated or generated files.
6. Commit with a concise `Release <version>` subject and include this trailer:

   `Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>`

7. Create an annotated tag whose name exactly matches the TOC version, then push the current branch and that tag to its configured remote. Never force-push, amend, or overwrite an existing tag. If the target branch is behind or diverged, stop and resolve that before pushing.
8. The tag push triggers `.github/workflows/release.yml`. Wait for that workflow to finish and verify that the packager reports successful uploads to both Wago and CurseForge, as well as a successful GitHub release. Use the GitHub Actions tools when available; otherwise use `gh` if authenticated. Do not report a platform as published based only on the tag push.
9. If the workflow reports a missing/invalid token, do not request or print secret values. Explain which repository secret needs to be configured (`WAGO_API_TOKEN` or `CF_API_KEY`) and report any destinations that did succeed. Do not create a replacement tag or retry publication unless the user asks.

## Safety and scope

- Never print, copy into files, commit, or expose publishing tokens.
- Do not commit local credentials/configuration, `.vscode/mcp.json`, or files under `releases/`.
- Do not create a release during planning or setup; only execute this procedure when the user asks to release.
- If publication partially succeeds, report the exact workflow result and leave recovery to an explicit follow-up request.
