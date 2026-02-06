# /yo context

Get session context including current task state, decisions, and relevant memories.

## Usage

```
/yo context
```

## Instructions

1. Get `YOLOG_SESSION_ID` from environment (set by SessionStart hook)

2. If `YOLOG_SESSION_ID` is not set, inform the user:
```
Session ID not available. Use `/yo project` for project-wide context,
or ensure the SessionStart hook is configured.
```

3. If `YOLOG_SESSION_ID` is set, call the Yocore HTTP API:
```bash
curl -s -X POST "${YOCORE_URL:-http://127.0.0.1:19420}/api/context/session" \
  -H "Content-Type: application/json" \
  -d '{"session_id":"<SESSION_ID>","project_path":"<CWD>"}'
```

4. Parse the JSON response. The response contains structured data and a `formatted_text` field.

5. Display the session context using the response data:
```
## Session Context

### Current State
- **Active Task:** [from session.active_task]
- **Resume Context:** [from session.resume_context, if available]
- **Recent Decisions:** [from session.recent_decisions]
- **Open Questions:** [from session.open_questions]

### Persistent Knowledge (High Importance)
- [from persistent_memories array]

### This Session's Memories
- [from session_memories array]

### Recent Memories (Last 3 Sessions)
- [from recent_memories array]
```

6. Summarize key points to keep in mind while working

## Notes

- Replace `<CWD>` with the current working directory
- Replace `<SESSION_ID>` with YOLOG_SESSION_ID from environment
- Use this at session start to get context
- **After compaction:** Context is automatically injected by SessionStart hook (no manual call needed)
