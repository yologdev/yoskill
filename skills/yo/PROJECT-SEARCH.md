# /yo project-search

Search raw session messages (actual conversations) within the project. Uses BM25 full-text search.

## Usage

```
/yo project-search <query>
```

## Examples

```
/yo project-search config migration
/yo project-search authentication flow
/yo project-search database schema
/yo project-search "error handling"
```

## Instructions

> **URL/Auth:** `<YOCORE_URL>` = `YOCORE_URL` env var or `http://127.0.0.1:19420`. `<AUTH_HEADER>` = `-H "Authorization: Bearer <key>"` if `YOCORE_API_KEY` is set, otherwise omit. Never use shell variable expansion — substitute literal values.

1. Extract the search query (everything after "project-search ")

2. Resolve the project ID:
```bash
curl -s <YOCORE_URL>/api/projects/resolve?path=<CWD> <AUTH_HEADER>
```
Extract the `id` field as `<PROJECT_ID>`.

3. Call the Yocore HTTP API:
```bash
curl -s -X POST <YOCORE_URL>/api/search \
  -H "Content-Type: application/json" \
  <AUTH_HEADER> \
  -d '{"query":"<QUERY>","project_id":"<PROJECT_ID>","limit":20}'
```

4. Parse the JSON response. Results include: session_id, session title, content_preview (snippet), role, timestamp, score.

5. Display results grouped by session:
```
## Project Search: "<query>"

### Session: "<title>" (<date>)
1. [<role>] ...matched snippet...
2. [<role>] ...another matching message...

### Session: "<title>" (<date>)
3. [<role>] ...snippet...

(N results across M sessions)
```

6. Summarize key findings

## Notes

- Replace `<CWD>` with the current working directory
- This searches **raw session messages** (actual conversation content)
- For searching extracted memories (decisions, facts, etc.), use `/yo memory-search`
- Results are ranked by BM25 relevance score
- Optional filters: add `"role":"user"` or `"role":"assistant"` or `"has_code":true` to the request body
