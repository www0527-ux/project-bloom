# project-bloom

`project-bloom` is a Codex skill for project-based programming learning. It helps initialize a real code project, create Obsidian learning records, keep staged roadmaps, track blockers and technical decisions, guide Git checkpoints, and eventually turn the project into resume and interview material.

## Who It Is For

- Learners building FastAPI, RAG, LangGraph, Agent, or course-design projects.
- Developers who want Codex to guide learning through real implementation instead of generating a full project at once.
- Windows + VS Code + Codex users who prefer PowerShell, conda, and GitHub SSH.

## Relationship To bloom-learning

`bloom-learning` focuses more on learning a knowledge topic. `project-bloom` focuses on learning through a real programming project, with code structure, Git workflow, staged development, blockers, technical decisions, and resume-oriented summaries.

## Installation

Place this folder at:

```text
$HOME\.agents\skills\project-bloom
```

For example:

```text
%USERPROFILE%\.agents\skills\project-bloom
```

Restart or reload Codex if the skill list does not refresh immediately.

## Using In Codex

Ask Codex with:

```text
Use $project-bloom to initialize a FastAPI RAG learning project.
```

or:

```text
Use $project-bloom to continue my current project-learning session.
```

## Initialize A Project

From the skill folder:

```powershell
.\scripts\init-project.ps1 `
  -ProjectName "Obsidian Learn" `
  -CodePath "D:\code\your-project" `
  -VaultPath "D:\ObsidianVault" `
  -TopicName "Obsidian Study Assistant" `
  -Level "beginner" `
  -EnvName "obsidian-learn" `
  -RepoUrl "git@github.com:your-username/your-project.git" `
  -Roadmap "fastapi-rag-langgraph" `
  -InitGit
```

The script does not push by default. If `-Push` is passed, it still asks for `PUSH` confirmation.

## Directory Structure

```text
project-bloom/
  SKILL.md
  scripts/
    init-project.ps1
    update-session.ps1
    git-checkpoint.ps1
    next-task.ps1
  assets/
    AGENTS.template.md
    README.template.md
    gitignore-python.template
    state.template.json
  references/
    project-learning-method.md
    obsidian-record-schema.md
    fastapi-rag-langgraph-roadmap.md
    git-workflow.md
```

## Scripts

- `init-project.ps1`: create code folders, templates, Obsidian records, optional Git init, and optional confirmed push.
- `update-session.ps1`: append simple session records and update state.
- `git-checkpoint.ps1`: inspect status, optionally commit, and optionally confirmed push.
- `next-task.ps1`: read state and print the current stage and next task.

## Future Plans

- Richer roadmap selection.
- Safer state transitions with checkpoint questions.
- Better session update prompts.
- Commit message suggestions based on changed files.
- Resume summary generation from stage evidence.

## Acknowledgements

This project is inspired by bloom-learning-repo. It is independently designed for project-based programming learning and does not copy the original project's code or templates.
