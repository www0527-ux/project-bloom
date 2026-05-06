param(
    [Parameter(Mandatory = $true)]
    [string]$TopicPath
)

$ErrorActionPreference = "Stop"
$TopicPath = [System.IO.Path]::GetFullPath($TopicPath)
$statePath = Join-Path $TopicPath "_meta\state.json"

if (-not (Test-Path -LiteralPath $statePath)) {
    throw "state.json not found: $statePath"
}

$state = Get-Content -LiteralPath $statePath -Raw -Encoding utf8 | ConvertFrom-Json

Write-Host "[project-bloom] Current stage: $($state.current_stage)"
Write-Host "[project-bloom] Current goal: $($state.current_goal)"
Write-Host "[project-bloom] Next task: $($state.next_task)"
Write-Host ""
Write-Host "Read first:"
Write-Host "- $TopicPath\_meta\roadmap.md"
Write-Host "- $TopicPath\_meta\progress.md"
Write-Host "- $TopicPath\logs\blockers.md"
Write-Host ""
Write-Host "Do not jump ahead. Verify the current stage runs before starting later stages."
