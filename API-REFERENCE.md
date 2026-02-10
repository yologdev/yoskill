# Yocore HTTP API Reference

API reference for Yocore, the local HTTP server that stores and retrieves coding session memories. Default base URL: `http://127.0.0.1:19420` (override with `YOCORE_URL` env var). If `YOCORE_API_KEY` is set, add `-H "Authorization: Bearer <key>"` to all requests.

## Health Check

```
GET /health
```

Returns server status and version.

## Project Resolution

```
GET /api/projects/resolve?path=<working_directory>
```

Returns `{ "id": "uuid", "name": "project-name", "folder_path": "..." }` or 404.
Use the `id` field as `project_id` in subsequent calls.

## Session Context

Get current session state including active task, decisions, and relevant memories.

```
POST /api/context/session
Content-Type: application/json

{"session_id": "<session_id>", "project_path": "<working_directory>"}
```

Response fields: `session` (active_task, resume_context, recent_decisions, open_questions), `persistent_memories`, `session_memories`, `recent_memories`, `formatted_text`.

## Project Context

Get project-level knowledge shared across all sessions.

```
GET /api/context/project?project_path=<working_directory>
```

Response fields: `project_name`, `decisions`, `facts`, `preferences`, `context`, `tasks`, `total_memories`.

## Memory Search (Hybrid FTS + Vector)

Search extracted memories by keyword, semantic similarity, or tag.

```
POST /api/memories/search
Content-Type: application/json

{"query": "<search_query>", "project_id": "<project_id>", "limit": 10}
```

Optional fields: `"tags": ["<tag>"]` to filter by tag.

Each result includes: `id`, `type`, `title`, `content`, `confidence`, `tags`, `state`.

## Memory Browse (Tag Filter)

List memories filtered by tag without a search query.

```
GET /api/memories?project_id=<project_id>&tags=<tag>&limit=10
```

## Project Search (BM25 FTS)

Search raw session messages (actual conversation content).

```
POST /api/search
Content-Type: application/json

{"query": "<search_query>", "project_id": "<project_id>", "limit": 20}
```

Optional filters: `"role": "user"`, `"role": "assistant"`, `"has_code": true`.

Results include: `session_id`, session title, `content_preview`, `role`, `timestamp`, `score`.

## List Session Memories

List memories extracted from a specific session.

```
GET /api/memories?session_id=<session_id>&limit=50&sort_by=extracted_at&sort_order=desc
```

## Memory Tags

List available tags for a project.

```
GET /api/projects/<project_id>/memory-tags
```

## Update Memory

Change a memory's state or confidence.

```
PATCH /api/memories/<id>
Content-Type: application/json

{"state": "high"}
```

Supported fields: `state` (`new`, `low`, `high`, `removed`), `confidence` (float 0-1).

## Delete Memory (Soft)

```
DELETE /api/memories/<id>
```

Returns 204 on success. Memory is marked `state=removed`, not permanently destroyed.

## Lifeboat (Pre-Compaction Save)

Save session state before context compaction.

```
POST /api/context/lifeboat
Content-Type: application/json

{"session_id": "<session_id>"}
```
