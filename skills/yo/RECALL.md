# /yo recall

Search memories by keyword or topic.

## Usage

```
/yo recall <query>
```

## Examples

```
/yo recall error handling
/yo recall authentication flow
/yo recall database migrations
```

## Instructions

1. Extract the search query (everything after "recall ")

2. Call `yolog_search_memories` via CLI:
```bash
printf '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"yolog_search_memories","arguments":{"query":"<QUERY>","project_path":"<CWD>","limit":10}}}' | <MCP_CLI_PATH>
```

3. Parse the JSON response

4. Display memories grouped by type:
```
## Decisions
- [title]: [summary]

## Patterns
- [title]: [summary]

## Bugs
- [title]: [summary]

## Architecture
- [title]: [summary]
```

5. Summarize key findings at the end

## Notes

- Replace `<CWD>` with the current working directory
- Replace `<QUERY>` with the user's search query
- Replace `<MCP_CLI_PATH>` with the path from SKILL.md Configuration section
