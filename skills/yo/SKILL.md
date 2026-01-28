---
name: yo
description: Search and recall project memories from Yolog. Use "/yo recall <query>" to search for memories about a topic, or "/yo context" to get project overview with decisions, patterns, and architecture.
---

# Yolog Memory Recall

Search project memories stored by the Yolog desktop app.

## Configuration

Set your MCP CLI path below (copy from Yolog Settings > Memory & Skills):

```
MCP_CLI_PATH=/path/to/yolog-mcp-server
```

## Commands

- `/yo recall <query>` - Search memories by keyword or topic
- `/yo context` - Get project overview

## Instructions

Parse `$ARGUMENTS` to determine the command:

**If arguments start with `recall`:**
1. Extract the search query (everything after "recall ")
2. Call yolog_search_memories via CLI:
```bash
printf '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"yolog_search_memories","arguments":{"query":"<QUERY>","project_path":"<CWD>","limit":10}}}' | <MCP_CLI_PATH>
```
3. Parse the JSON response
4. Display memories grouped by type (decision, pattern, bug, architecture)
5. Summarize key findings

**If arguments equal `context`:**
1. Call yolog_get_project_context via CLI:
```bash
printf '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"yolog_get_project_context","arguments":{"project_path":"<CWD>"}}}' | <MCP_CLI_PATH>
```
2. Parse the JSON response
3. Display the project overview
4. Summarize what to keep in mind while working

**If arguments empty or invalid:**
Show usage: `/yo recall <query>` or `/yo context`

## Notes

- Replace `<CWD>` with the current working directory
- Replace `<QUERY>` with the user's search query
- Replace `<MCP_CLI_PATH>` with the path from Configuration section above
