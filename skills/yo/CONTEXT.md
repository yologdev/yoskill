# /yo context

Get session context including current task state, decisions, and relevant memories.

## Usage

```
/yo context
```

## Instructions

> **URL/Auth:** `<YOCORE_URL>` = `YOCORE_URL` env var or `http://127.0.0.1:19420`. `<AUTH_HEADER>` = `-H "Authorization: Bearer <key>"` if `YOCORE_API_KEY` is set, otherwise omit. Never use shell variable expansion — substitute literal values.

1. Get `YOLOG_SESSION_ID` from environment (set by SessionStart hook)

2. If `YOLOG_SESSION_ID` is not set, inform the user:
```
Session ID not available. Use `/yo project` for project-wide context,
or ensure the SessionStart hook is configured.
```

3. If `YOLOG_SESSION_ID` is set, call the Yocore HTTP API:
```bash
curl -s -X POST <YOCORE_URL>/api/context/session \
  -H "Content-Type: application/json" \
  <AUTH_HEADER> \
  -d '{"session_id":"<SESSION_ID>","project_path":"<CWD>"}'
```

4. Parse the JSON response and display using **structured fields** (not `formatted_text`):

```
## Session Context

### Current State
- **Active Task:** [from session.active_task]
- **Resume Context:** [from session.resume_context, if available — this is the lifeboat data]
- **Recent Decisions:** [from session.recent_decisions]
- **Open Questions:** [from session.open_questions]

### Persistent Knowledge (High Importance)
- [#id] [Type] **Title**: Content
  (from persistent_memories array — include memory ID)

### This Session's Memories
- [#id] [Type] **Title**: Content
  (from session_memories array — include memory ID)

### Recent Memories (Last 3 Sessions)
- [#id] [Type] **Title**: Content
  (from recent_memories array — include memory ID)
```

5. Summarize key points to keep in mind while working

## Notes

- Replace `<CWD>` with the current working directory
- Replace `<SESSION_ID>` with YOLOG_SESSION_ID from environment
- **After compaction:** Context is automatically injected by SessionStart hook (no manual call needed)
