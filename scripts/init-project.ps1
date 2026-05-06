param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName,

    [Parameter(Mandatory = $true)]
    [string]$CodePath,

    [Parameter(Mandatory = $true)]
    [string]$VaultPath,

    [Parameter(Mandatory = $true)]
    [string]$TopicName,

    [string]$Level = "beginner",
    [string]$EnvName = "",
    [string]$RepoUrl = "",
    [string]$Roadmap = "fastapi-rag-langgraph",
    [switch]$InitGit,
    [switch]$Push
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[project-bloom] $Message"
}

function Resolve-FullPath {
    param([string]$PathValue)
    return [System.IO.Path]::GetFullPath($PathValue)
}

function Convert-Template {
    param(
        [string]$Text,
        [hashtable]$Values
    )

    foreach ($key in $Values.Keys) {
        $Text = $Text.Replace("{{$key}}", [string]$Values[$key])
    }
    return $Text
}

function ConvertTo-JsonTemplateValues {
    param([hashtable]$Values)

    $escaped = @{}
    foreach ($key in $Values.Keys) {
        $jsonString = [string]$Values[$key] | ConvertTo-Json -Compress
        if ($jsonString.Length -ge 2) {
            $jsonString = $jsonString.Substring(1, $jsonString.Length - 2)
        }
        $escaped[$key] = $jsonString
    }
    return $escaped
}

function Write-TextFileIfMissing {
    param(
        [string]$Path,
        [string]$Content
    )

    if (Test-Path -LiteralPath $Path) {
        Write-Step "Skip existing file: $Path"
        return
    }

    $parent = Split-Path -Parent $Path
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }

    Set-Content -LiteralPath $Path -Value $Content -Encoding utf8
    Write-Step "Created file: $Path"
}

function Read-Template {
    param([string]$RelativePath)

    $path = Join-Path $SkillRoot $RelativePath
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Template not found: $path"
    }

    return Get-Content -LiteralPath $path -Raw -Encoding utf8
}

function New-MarkdownFile {
    param(
        [string]$Path,
        [string]$Title,
        [string]$Body
    )

    $content = "# $Title`r`n`r`n$Body"
    Write-TextFileIfMissing -Path $Path -Content $content
}

function Get-SafeTopicFolderName {
    param([string]$Name)

    $invalid = [System.IO.Path]::GetInvalidFileNameChars()
    $safe = $Name
    foreach ($char in $invalid) {
        $safe = $safe.Replace([string]$char, "-")
    }
    return $safe.Trim()
}

$SkillRoot = Split-Path -Parent $PSScriptRoot
$CodePath = Resolve-FullPath $CodePath
$VaultPath = Resolve-FullPath $VaultPath

if ([string]::IsNullOrWhiteSpace($EnvName)) {
    $EnvName = ($ProjectName.ToLowerInvariant() -replace "[^a-z0-9]+", "-").Trim("-")
}

$topicFolder = Get-SafeTopicFolderName $TopicName
$TopicPath = Join-Path $VaultPath $topicFolder
$now = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

$values = @{
    "PROJECT_NAME" = $ProjectName
    "CODE_PATH" = $CodePath
    "VAULT_PATH" = $VaultPath
    "TOPIC_NAME" = $TopicName
    "OBSIDIAN_TOPIC_PATH" = $TopicPath
    "LEVEL" = $Level
    "ENV_NAME" = $EnvName
    "REPO_URL" = $RepoUrl
    "ROADMAP" = $Roadmap
    "NOW" = $now
}

Write-Step "Creating code project at: $CodePath"
New-Item -ItemType Directory -Force -Path $CodePath | Out-Null
foreach ($dir in @("app", "tests", "scripts")) {
    New-Item -ItemType Directory -Force -Path (Join-Path $CodePath $dir) | Out-Null
}

$agents = Convert-Template -Text (Read-Template "assets\AGENTS.template.md") -Values $values
$readme = Convert-Template -Text (Read-Template "assets\README.template.md") -Values $values
$gitignore = Read-Template "assets\gitignore-python.template"

Write-TextFileIfMissing -Path (Join-Path $CodePath "AGENTS.md") -Content $agents
Write-TextFileIfMissing -Path (Join-Path $CodePath "README.md") -Content $readme
Write-TextFileIfMissing -Path (Join-Path $CodePath ".gitignore") -Content $gitignore
Write-TextFileIfMissing -Path (Join-Path $CodePath "app\.gitkeep") -Content ""
Write-TextFileIfMissing -Path (Join-Path $CodePath "tests\.gitkeep") -Content ""

Write-Step "Creating Obsidian learning records at: $TopicPath"
foreach ($dir in @("_meta", "logs", "knowledge", "exercises", "summaries", "resume")) {
    New-Item -ItemType Directory -Force -Path (Join-Path $TopicPath $dir) | Out-Null
}

$state = Convert-Template -Text (Read-Template "assets\state.template.json") -Values (ConvertTo-JsonTemplateValues $values)
Write-TextFileIfMissing -Path (Join-Path $TopicPath "_meta\state.json") -Content $state

$roadmapBody = @"
Project: $ProjectName
Topic: $TopicName
Level: $Level
Roadmap: $Roadmap

Use staged learning. Do not jump to a later stage until the current stage runs, the learner can explain the core code path, and the progress records are updated.

See the `project-bloom` skill reference `fastapi-rag-langgraph-roadmap.md` for the default route.

## Current Stage

- Stage: v0
- Goal: Project initialization and the smallest runnable application.
- Completion criteria:
  - Conda environment plan is clear.
  - Repository structure exists.
  - First minimal app target is defined.
  - Git status is understood.

## Do Not Start Yet

- RAG, embeddings, vector stores, LangGraph, or Agent tools before FastAPI and CRUD basics are stable.
"@

New-MarkdownFile -Path (Join-Path $TopicPath "_meta\roadmap.md") -Title "Roadmap" -Body $roadmapBody
New-MarkdownFile -Path (Join-Path $TopicPath "_meta\progress.md") -Title "Progress" -Body "- $now Initialized project-learning records.`r`n"
New-MarkdownFile -Path (Join-Path $TopicPath "_meta\review-plan.md") -Title "Review Plan" -Body "Track concepts that need spaced review.`r`n"
New-MarkdownFile -Path (Join-Path $TopicPath "_meta\repo.md") -Title "Repository" -Body "Code path: $CodePath`r`n`r`nRemote: $RepoUrl`r`n`r`nConda environment: ``$EnvName```r`n`r`nUse GitHub SSH workflow by default. Push only after explicit confirmation.`r`n"

New-MarkdownFile -Path (Join-Path $TopicPath "logs\dev-log.md") -Title "Development Log" -Body "- $now Created project-learning workspace.`r`n"
New-MarkdownFile -Path (Join-Path $TopicPath "logs\blockers.md") -Title "Blockers" -Body "Record confusing concepts, stuck points, causes, and resolutions.`r`n"
New-MarkdownFile -Path (Join-Path $TopicPath "logs\bug-log.md") -Title "Bug Log" -Body "Record errors, root causes, fixes, commands, and code changes.`r`n"
New-MarkdownFile -Path (Join-Path $TopicPath "logs\decisions.md") -Title "Technical Decisions" -Body "Record why a technical direction was chosen and what alternatives were considered.`r`n"

New-MarkdownFile -Path (Join-Path $TopicPath "knowledge\concepts.md") -Title "Concepts" -Body "Record core concepts such as FastAPI, RAG, LangGraph, SQLAlchemy, routes, schemas, sessions, and retrieval.`r`n"
New-MarkdownFile -Path (Join-Path $TopicPath "knowledge\terms.md") -Title "Terms" -Body "Break down English terms, abbreviations, and long function names.`r`n"
New-MarkdownFile -Path (Join-Path $TopicPath "knowledge\code-patterns.md") -Title "Code Patterns" -Body "Record reusable code patterns such as FastAPI routes, Pydantic schemas, and SQLAlchemy selects.`r`n"

New-MarkdownFile -Path (Join-Path $TopicPath "exercises\practice.md") -Title "Practice" -Body "Small tasks for the learner to implement directly.`r`n"
New-MarkdownFile -Path (Join-Path $TopicPath "exercises\checkpoints.md") -Title "Checkpoints" -Body "Stage questions that verify real understanding before moving forward.`r`n"

New-MarkdownFile -Path (Join-Path $TopicPath "summaries\weekly-summary.md") -Title "Weekly Summary" -Body "Summarize progress, blockers, concepts, and next priorities each week.`r`n"
New-MarkdownFile -Path (Join-Path $TopicPath "summaries\stage-summary.md") -Title "Stage Summary" -Body "Summarize each completed stage, evidence, lessons, and remaining risks.`r`n"

New-MarkdownFile -Path (Join-Path $TopicPath "resume\project-description.md") -Title "Project Description" -Body "Draft resume-ready project descriptions only after the project has real working evidence.`r`n"
New-MarkdownFile -Path (Join-Path $TopicPath "resume\interview-talking-points.md") -Title "Interview Talking Points" -Body "Record architecture, tradeoffs, hard bugs, technical decisions, and personal contributions.`r`n"

if ($InitGit) {
    Write-Step "Initializing Git repository"
    Push-Location $CodePath
    try {
        if (-not (Test-Path -LiteralPath (Join-Path $CodePath ".git"))) {
            git init
        }
        git branch -M main

        if (-not [string]::IsNullOrWhiteSpace($RepoUrl)) {
            $remotes = @(git remote)
            if ($remotes -notcontains "origin") {
                git remote add origin $RepoUrl
                Write-Step "Added origin: $RepoUrl"
            } else {
                $origin = git remote get-url origin
                Write-Step "Origin already exists: $origin"
            }
        } else {
            Write-Step "RepoUrl was empty; skipped remote origin."
        }
    } finally {
        Pop-Location
    }
}

if ($Push) {
    Write-Host ""
    Write-Host "Push was requested. This will run git add, commit, and push for:"
    Write-Host "  $CodePath"
    $confirm = Read-Host "Type PUSH to confirm"
    if ($confirm -ne "PUSH") {
        Write-Step "Push cancelled."
    } else {
        Push-Location $CodePath
        try {
            git status
            git add .
            git commit -m "Initialize project-bloom learning project"
            git push -u origin main
        } finally {
            Pop-Location
        }
    }
}

Write-Host ""
Write-Step "Done."
Write-Host "Code project: $CodePath"
Write-Host "Learning records: $TopicPath"
Write-Host "Next: activate/create conda env '$EnvName', implement the first minimal app, then update progress."
