# Yocore Memory Integration — LLM Prompt Snippet

Drop this into your LLM tool's system prompt (`.cursorrules`, Windsurf rules, Copilot instructions, etc.) to give it access to your coding session memories via Yocore.

---

```
## Yocore Memory System (PROACTIVE USE REQUIRED)

This project uses Yocore for persistent memory across coding sessions. Base URL: http://127.0.0.1:19420 (override with YOCORE_URL env var). If YOCORE_API_KEY is set, add -H "Authorization: Bearer <key>" to all curl calls.

### When to search memories (do NOT wait for user to ask)
- User asks "what did we decide/do?", "why did we...", "I don't remember" → search memories
- Before implementing a feature → search for prior decisions
- User is debugging → search for past solutions
- User asks "how did we do X before?" → search conversations

### Core commands

# 1. Get session context (current state + memories)
curl -s -X POST http://127.0.0.1:19420/api/context/session \
  -H "Content-Type: application/json" \
  -d '{"session_id":"<SESSION_ID>","project_path":"<CWD>"}'

# 2. Search extracted memories (decisions, facts, patterns)
# First resolve project ID:
PROJECT_ID=$(curl -s http://127.0.0.1:19420/api/projects/resolve?path=<CWD> | jq -r '.id')
# Then search:
curl -s -X POST http://127.0.0.1:19420/api/memories/search \
  -H "Content-Type: application/json" \
  -d '{"query":"<SEARCH_QUERY>","project_id":"'$PROJECT_ID'","limit":10}'

# 3. Search raw session conversations
curl -s -X POST http://127.0.0.1:19420/api/search \
  -H "Content-Type: application/json" \
  -d '{"query":"<SEARCH_QUERY>","project_id":"'$PROJECT_ID'","limit":20}'

# 4. Get project-wide context
curl -s http://127.0.0.1:19420/api/context/project?project_path=<CWD>

### Rules
- ALWAYS search memories BEFORE answering questions about past decisions
- ALWAYS search memories BEFORE implementing features — check if discussed before
- Display memory IDs (e.g., [#42]) when referencing results
- If the answer might exist in past sessions, search first, answer second
```
