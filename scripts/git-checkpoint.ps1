param(
    [string]$CodePath = ".",
    [string]$Message = "",
    [switch]$Commit,
    [switch]$Push
)

$ErrorActionPreference = "Stop"
$CodePath = [System.IO.Path]::GetFullPath($CodePath)

Push-Location $CodePath
try {
    Write-Host "[project-bloom] Git status for $CodePath"
    git status

    if ([string]::IsNullOrWhiteSpace($Message)) {
        $Message = "Checkpoint project learning progress"
    }

    Write-Host ""
    Write-Host "Suggested commit message: $Message"

    if ($Commit) {
        git add .
        git commit -m $Message
    } else {
        Write-Host "Run again with -Commit to create the commit."
    }

    if ($Push) {
        $confirm = Read-Host "Type PUSH to confirm git push"
        if ($confirm -eq "PUSH") {
            git push
        } else {
            Write-Host "[project-bloom] Push cancelled."
        }
    }
} finally {
    Pop-Location
}
