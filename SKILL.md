---
name: project-bloom
description: Use this skill when the user wants to initialize or manage a project-based programming learning workflow with Codex, Obsidian learning records, staged roadmaps, Git/GitHub workflow, blockers, concepts, technical decisions, and resume-oriented project summaries. Use it for new coding learning projects, staged project learning, Obsidian project-learning logs, and Git checkpoints. Do not use it for ordinary feature development unrelated to learning workflow or project progress tracking.
---

# Project Bloom

Use `project-bloom` to guide a real programming project as a learning journey. Keep the code project, Git workflow, Obsidian records, and staged learning roadmap aligned.

## Use When

- Initialize a new programming learning project, such as FastAPI, RAG, LangGraph, Agent, or course-design projects.
- Continue a staged learning project with progress records, blockers, concepts, decisions, and next tasks.
- Create or update Obsidian project-learning notes.
- Prepare a Git checkpoint after a meaningful learning or development step.
- Turn a mature learning project into resume and interview material.

## Do Not Use When

- The task is ordinary feature work with no learning workflow, roadmap, or progress tracking.
- The user only wants a quick code fix, refactor, or code review in an existing production project.
- The user asks for topic-only tutoring without a concrete project artifact.

## Boundaries

- Guide project setup, staged planning, learning records, Git checkpoints, and resume summaries.
- Prefer guided implementation: explain, ask the learner to implement core code, provide small key snippets, then review and debug.
- Do not generate a complete project in one pass unless the user explicitly asks for full code.
- Do not skip stages. Verify the current stage runs before moving on; for example, do not start RAG, LangGraph, or Agent work before the FastAPI and CRUD foundations are stable.
- Default to Windows, VS Code, PowerShell scripts, conda Python environments, and GitHub SSH remotes.
- Never run `git push` by default. Push only when the user explicitly requests it or passes a Push parameter and confirms.

## AGENTS.md Division

Keep repository `AGENTS.md` short. It should only point Codex to this skill, state project-learning rules, and link to the Obsidian learning records. Store long roadmaps, schemas, and methods in this skill's `references/` files or in the Obsidian project records.

## Obsidian Division

Use Obsidian as the durable learning memory:

- `_meta/state.json`: machine-readable state and next task.
- `_meta/roadmap.md`: stages, goals, completion criteria, and blocked future work.
- `_meta/progress.md`: session-by-session progress.
- `logs/`: dev logs, blockers, bugs, and decisions.
- `knowledge/`: concepts, terms, and code patterns.
- `exercises/`: practice tasks and checkpoints.
- `summaries/`: weekly and stage summaries.
- `resume/`: project description and interview talking points.

Read `references/obsidian-record-schema.md` when creating or repairing record files.

## Git Division

Use Git as the code history and milestone record:

- Initialize with SSH remotes such as `git@github.com:username/repo.git`.
- Encourage checkpoints after meaningful working increments.
- Before committing, inspect `git status` and summarize what changed.
- Commit after tests or manual verification pass when possible.
- Push only after explicit user confirmation.

Read `references/git-workflow.md` before advising detailed Git commands.

## Standard Learning Session

1. Read `_meta/state.json`, `_meta/progress.md`, `_meta/roadmap.md`, and recent logs.
2. State the current stage, current goal, and next task.
3. Confirm prerequisites for the stage are met.
4. Guide the learner through a small implementation step.
5. Run or suggest focused verification.
6. Update progress, dev log, blockers, concepts, bugs, and decisions as appropriate.
7. Set the next task in state.
8. If the step is meaningful and verified, suggest a Git checkpoint.

Use `scripts/next-task.ps1` to inspect current state, `scripts/update-session.ps1` to append learning records, and `scripts/git-checkpoint.ps1` for checkpoint flow.

## Stage Transition Checks

Before moving to a new stage:

- The current stage has a running implementation.
- The learner can explain the core concepts and code path.
- Required tests or manual checks pass.
- Open blockers are resolved or explicitly deferred.
- `_meta/progress.md`, `summaries/stage-summary.md`, and `_meta/state.json` are updated.
- Git has a clean or intentionally understood status.

Read `references/project-learning-method.md` for the detailed teaching method and `references/fastapi-rag-langgraph-roadmap.md` for the default staged route.

## Initialization

For a new project, use `scripts/init-project.ps1`. It creates the code directory, short `AGENTS.md`, README, `.gitignore`, starter folders, Obsidian learning records, optional Git initialization, and optional confirmed push.

Example:

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
