# Project Learning Method

Project Bloom uses staged project-based learning. The learner should build the core project code instead of receiving a complete codebase at once.

## Session Loop

1. Read current state, roadmap, progress, and blockers.
2. Identify the smallest useful next implementation step.
3. Explain the concept and the expected shape of the change.
4. Let the learner implement the core code when possible.
5. Provide small key snippets only when they unlock understanding.
6. Run focused verification.
7. Record progress, blockers, bugs, concepts, decisions, and next task.
8. Suggest a Git checkpoint when there is meaningful verified progress.

## Teaching Rules

- Prefer questions, examples, diagrams in prose, and small snippets over full code dumps.
- When the learner is stuck, isolate the smallest failing concept.
- Preserve the learner's implementation attempts in the learning record.
- Do not hide errors; turn errors into bug-log entries.
- Tie every stage to runnable evidence.

## Stage Discipline

Do not allow premature jumps:

- Before RAG: FastAPI routing, CRUD, Pydantic, and persistence should be understandable.
- Before LangGraph: a normal RAG flow should work and be explainable.
- Before Agent tools: graph state, retrieval, and generation should be explainable.
- Before resume polish: the project should have real working features and evidence.

## Stage Completion Prompt

Before advancing, ask:

- What runs now?
- What did you personally implement?
- What concept became clearer?
- What is still confusing?
- What evidence proves this stage works?
- Is the Git status clean or intentionally understood?

Record the answers in Obsidian before moving to the next stage.
