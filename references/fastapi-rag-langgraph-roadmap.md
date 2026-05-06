# FastAPI + RAG + LangGraph Roadmap

Use this roadmap for project-based programming learning. Do not skip ahead; each stage should leave runnable evidence, learning records, and a Git checkpoint when appropriate.

## v0: Project Initialization And Minimal FastAPI App

- Create or activate a conda environment.
- Install FastAPI and Uvicorn.
- Implement `GET /health`.
- Understand `main.py`, `app`, route, request, and response.

Completion criteria:

- The app runs locally.
- `/health` returns a simple successful response.
- The learner can explain where the route is registered and how Uvicorn starts the app.

## v1: Notes CRUD

- Build in-memory or JSON-file Notes CRUD.
- Use `APIRouter`.
- Use Pydantic request and response models.
- Practice path parameters, query parameters, and request bodies.

Completion criteria:

- Create, list, read, update, and delete notes work.
- The learner can explain Pydantic validation and route parameters.

## v2: Database And SQLAlchemy

- Use SQLAlchemy Async.
- Create a `notes` table.
- Define ORM models.
- Define Pydantic schemas.
- Use `AsyncSession`.
- Understand `commit`, `refresh`, and `select`.

Completion criteria:

- Notes persist in a database.
- CRUD still works.
- The learner can explain the model/schema/session split.

## v3: Obsidian Markdown Reading

- Scan `.md` files.
- Read title, body, and path.
- Import notes into the database.
- Do not handle complex backlinks, images, or frontmatter yet.

Completion criteria:

- A folder of Markdown files can be imported.
- Imported records can be listed or searched.

## v4: Keyword Search

- Implement `GET /notes/search?keyword=xxx`.
- Understand the relationship between ordinary search and RAG.

Completion criteria:

- Keyword search returns matching notes.
- The learner can explain why keyword search is not yet RAG.

## v5: Minimal RAG Loop

- Chunk text.
- Create embeddings.
- Store vectors.
- Retrieve relevant chunks.
- Compose a prompt.
- Implement `POST /qa`.
- Return `answer` and `sources`.
- Do not build GraphRAG, reranking, or multi-retrieval yet.

Completion criteria:

- A question can retrieve source chunks and produce an answer.
- The learner can trace chunking, embedding, retrieval, prompting, and answer generation.

## v6: LangGraph Orchestration

- Use `StateGraph`.
- Define state.
- Define nodes.
- Define edges.
- Orchestrate "analyze question -> retrieve -> generate answer".

Completion criteria:

- The RAG flow is represented as a graph.
- The learner can explain state passing and graph execution.

## v7: Learning Agent Tool Calls

- Implement `search_notes`.
- Implement `summarize_notes`.
- Implement `generate_review_plan`.
- Implement `save_markdown`.

Completion criteria:

- Agent-like tool calls operate on project notes.
- The learner can explain tool inputs, outputs, and failure cases.

## v8: Engineering And Resume Polish

- Improve README.
- Add focused tests.
- Clean the GitHub repository.
- Prepare project screenshots.
- Write resume descriptions.
- Prepare interview explanations.

Completion criteria:

- The project has runnable instructions, evidence, and a concise resume-ready story.
