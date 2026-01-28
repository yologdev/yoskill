# /yo context

Get project overview at session start.

## Usage

```
/yo context
```

## Instructions

1. Call `yolog_get_project_context` via CLI:
```bash
printf '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"yolog_get_project_context","arguments":{"project_path":"<CWD>"}}}' | <MCP_CLI_PATH>
```

2. Parse the JSON response

3. Display the project overview:
```
## Project Context

### Key Decisions
- [decision summaries]

### Established Patterns
- [pattern summaries]

### Architecture Notes
- [architecture insights]

### Known Bugs
- [bug summaries]
```

4. Summarize what to keep in mind while working on this project

## Notes

- Replace `<CWD>` with the current working directory
- Replace `<MCP_CLI_PATH>` with the path from SKILL.md Configuration section
- Use this command at the start of a coding session to understand project conventions
