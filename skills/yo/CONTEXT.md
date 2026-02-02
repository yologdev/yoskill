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

3. If `YOLOG_SESSION_ID` is set, call `yolog_get_session_context`:
```bash
printf '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"yolog_get_session_context","arguments":{"session_id":"<SESSION_ID>","project_path":"<CWD>"}}}' | <MCP_CLI_PATH>
```

4. Parse the JSON response

5. Display the session context:
```
## Session Context

### Current State
- **Active Task:** [task description]
- **Resume Context:** [if available, from last compaction]
- **Recent Decisions:** [list]
- **Open Questions:** [list]

### Persistent Knowledge (High Importance)
- [high-state memories from project]

### This Session's Memories
- [memories extracted this session]

### Recent Memories (Last 3 Sessions)
- [memories from recent other sessions]
```

6. Summarize key points to keep in mind while working

## Notes

- Replace `<CWD>` with the current working directory
- Replace `<SESSION_ID>` with YOLOG_SESSION_ID from environment
- Replace `<MCP_CLI_PATH>` with the path from SKILL.md Configuration section
- Use this at session start to get context
- **After compaction:** Context is automatically injected by SessionStart hook (no manual call needed)
