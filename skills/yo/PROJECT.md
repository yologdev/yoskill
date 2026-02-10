# /yo project

Get project-level context shared across all sessions. Includes key decisions, patterns, architecture insights, and bugs from all past sessions.

## Usage

```
/yo project
```

## Instructions

> **URL/Auth:** `<YOCORE_URL>` = `YOCORE_URL` env var or `http://127.0.0.1:19420`. `<AUTH_HEADER>` = `-H "Authorization: Bearer <key>"` if `YOCORE_API_KEY` is set, otherwise omit. Never use shell variable expansion — substitute literal values.

1. Call the Yocore HTTP API with current working directory:
```bash
curl -s <YOCORE_URL>/api/context/project?project_path=<CWD> <AUTH_HEADER>
```

2. Parse the JSON response and display using **structured fields** (not `formatted_text`):

```
## Project Context: [project_name]

### Key Decisions
- [#id] **Title**: Content
  (from decisions array — include memory ID)

### Facts & Discoveries
- [#id] **Title**: Content
  (from facts array)

### Preferences
- [#id] **Title**: Content
  (from preferences array)

### Context
- [#id] **Title**: Content
  (from context array)

### Tasks
- [#id] **Title**: Content
  (from tasks array)

**Total memories:** [total_memories]
```

3. Summarize key conventions and decisions to follow

## Notes

- Replace `<CWD>` with the current working directory
- This returns project-wide knowledge, not session-specific state
- Use `/yo context` for session-specific state (active task, recent decisions)
