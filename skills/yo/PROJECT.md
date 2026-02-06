# /yo project

Get project-level context shared across all sessions. Includes key decisions, patterns, architecture insights, and bugs from all past sessions.

## Usage

```
/yo project
```

## Instructions

1. Call the Yocore HTTP API with current working directory:
```bash
curl -s "${YOCORE_URL:-http://127.0.0.1:19420}/api/context/project?project_path=<CWD>"
```

2. Parse the JSON response. The response contains structured data and a `formatted_text` field.

3. Display the project context using the response data:
```
## Project Context: [project_name]

### Key Decisions
- [from decisions array - architectural choices, technology selections]

### Facts & Discoveries
- [from facts array - learned information, how things work]

### Preferences
- [from preferences array - code style, conventions]

### Context
- [from context array - background info, domain knowledge]

### Tasks
- [from tasks array - action items, work items]

**Total memories:** [total_memories]
```

4. Summarize key conventions and decisions to follow

## Notes

- Replace `<CWD>` with the current working directory
- This returns project-wide knowledge, not session-specific state
- Use `/yo context` for session-specific state (active task, recent decisions)
