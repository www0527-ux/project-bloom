# Obsidian Record Schema

Use this structure for each project-based learning topic.

```text
<Project Topic>/
  _meta/
    state.json
    roadmap.md
    progress.md
    review-plan.md
    repo.md
  logs/
    dev-log.md
    blockers.md
    bug-log.md
    decisions.md
  knowledge/
    concepts.md
    terms.md
    code-patterns.md
  exercises/
    practice.md
    checkpoints.md
  summaries/
    weekly-summary.md
    stage-summary.md
  resume/
    project-description.md
    interview-talking-points.md
```

## File Responsibilities

`_meta/state.json` records machine-readable state: project name, code path, repository URL, conda environment, current stage, current goal, next task, and last session time.

`_meta/roadmap.md` records stage goals, completion criteria, and work that must not be started early.

`_meta/progress.md` records what each session completed, what remains unfinished, and where to continue.

`_meta/review-plan.md` records concepts that need review and when to revisit them.

`_meta/repo.md` records code path, remote repository, environment name, and Git workflow notes.

`logs/dev-log.md` records what was actually built or changed.

`logs/blockers.md` records confusing points, stuck causes, and resolution outcomes.

`logs/bug-log.md` records errors, causes, fix commands, and code changes.

`logs/decisions.md` records technical decisions and alternatives.

`knowledge/concepts.md` records core concepts such as FastAPI, RAG, LangGraph, SQLAlchemy, routes, schemas, sessions, and retrieval.

`knowledge/terms.md` breaks down English terms, abbreviations, and long function names.

`knowledge/code-patterns.md` records recurring patterns such as FastAPI routes, Pydantic schemas, and SQLAlchemy selects.

`exercises/practice.md` stores practice tasks the learner should implement.

`exercises/checkpoints.md` stores stage questions that verify understanding.

`summaries/weekly-summary.md` stores weekly progress summaries.

`summaries/stage-summary.md` stores stage completion summaries.

`resume/project-description.md` stores resume-ready project descriptions after real progress exists.

`resume/interview-talking-points.md` stores architecture, tradeoffs, bugs, decisions, and personal contributions.
