param(
    [Parameter(Mandatory = $true)]
    [string]$TopicPath,

    [string]$Summary = "",
    [string]$Blocker = "",
    [string]$Concept = "",
    [string]$CurrentStage = "",
    [string]$NextTask = ""
)

$ErrorActionPreference = "Stop"
$TopicPath = [System.IO.Path]::GetFullPath($TopicPath)
$now = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

function Add-LineIfValue {
    param([string]$Path, [string]$Prefix, [string]$Value)
    if (-not [string]::IsNullOrWhiteSpace($Value)) {
        Add-Content -LiteralPath $Path -Value "- $now $Prefix$Value" -Encoding utf8
    }
}

Add-LineIfValue -Path (Join-Path $TopicPath "_meta\progress.md") -Prefix "" -Value $Summary
Add-LineIfValue -Path (Join-Path $TopicPath "logs\dev-log.md") -Prefix "" -Value $Summary
Add-LineIfValue -Path (Join-Path $TopicPath "logs\blockers.md") -Prefix "" -Value $Blocker
Add-LineIfValue -Path (Join-Path $TopicPath "knowledge\concepts.md") -Prefix "" -Value $Concept

$statePath = Join-Path $TopicPath "_meta\state.json"
if (Test-Path -LiteralPath $statePath) {
    $state = Get-Content -LiteralPath $statePath -Raw -Encoding utf8 | ConvertFrom-Json
    if (-not [string]::IsNullOrWhiteSpace($CurrentStage)) { $state.current_stage = $CurrentStage }
    if (-not [string]::IsNullOrWhiteSpace($NextTask)) { $state.next_task = $NextTask }
    $state.last_session = $now
    $state | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $statePath -Encoding utf8
}

Write-Host "[project-bloom] Session records updated: $TopicPath"
