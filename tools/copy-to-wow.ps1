[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param()

$source = 'C:\code\WoW\RandomDialogRP\RandomDialogRP'
$destination = 'C:\Games\World of Warcraft\_forever_\Interface\AddOns\RandomDialogRP'

if (-not (Test-Path -LiteralPath $source -PathType Container)) {
    throw "Addon source folder does not exist: $source"
}

$destinationParent = Split-Path -Parent $destination
if (-not (Test-Path -LiteralPath $destinationParent -PathType Container)) {
    throw "WoW AddOns folder does not exist: $destinationParent"
}

if (-not (Get-Command robocopy.exe -ErrorAction SilentlyContinue)) {
    throw 'robocopy.exe is required but was not found.'
}

if ($PSCmdlet.ShouldProcess($destination, "Copy addon files from $source")) {
    if (-not (Test-Path -LiteralPath $destination -PathType Container)) {
        New-Item -ItemType Directory -Path $destination -Force | Out-Null
    }

    & robocopy.exe $source $destination /E /COPY:DAT /DCOPY:DAT /R:2 /W:1
    $robocopyExitCode = $LASTEXITCODE
    if ($robocopyExitCode -ge 8) {
        throw "robocopy failed with exit code $robocopyExitCode."
    }

    Write-Host "Addon files copied to $destination (robocopy exit code $robocopyExitCode)."
}
