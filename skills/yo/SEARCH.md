# /yo search

Search memories by keyword, topic, or tag.

## Usage

```
/yo search <query>                    # Keyword/semantic search
/yo search tag:<tagname>              # Filter by tag only
/yo search #<tagname>                 # Shorthand for tag filter
/yo search tag:<tagname> <query>      # Combined: tag filter + keyword search
/yo search #<tagname> <query>         # Shorthand combined
```

## Examples

```
/yo search error handling
/yo search authentication flow
/yo search tag:bug
/yo search #frontend
/yo search tag:bug timezone           # Bugs related to timezone
/yo search #security api validation   # Security issues about API validation
```

## Instructions

1. Extract the search query (everything after "search ")

2. Parse for tag and keyword:
   - If starts with `tag:<name>` → extract tag, rest is keyword query
   - If starts with `#<name>` → extract tag (until space), rest is keyword query
   - If only tag (no additional words) → tag-only filter
   - Otherwise → keyword-only search

   Examples:
   - `tag:bug` → tag="bug", query=none
   - `#frontend api` → tag="frontend", query="api"
   - `error handling` → tag=none, query="error handling"

3. **Tag-only filter** - Call `yolog_get_memories_by_tag`:
```bash
printf '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"yolog_get_memories_by_tag","arguments":{"tag":"<TAG>","project_path":"<CWD>","limit":10}}}' | <MCP_CLI_PATH>
```

4. **Keyword-only search** - Call `yolog_search_memories`:
```bash
printf '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"yolog_search_memories","arguments":{"query":"<QUERY>","project_path":"<CWD>","limit":10}}}' | <MCP_CLI_PATH>
```

5. **Combined tag + keyword** - Call both and intersect results, OR call search with tag in query:
```bash
printf '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"yolog_search_memories","arguments":{"query":"<QUERY> <TAG>","project_path":"<CWD>","limit":15}}}' | <MCP_CLI_PATH>
```
Then filter results to only show those with matching tag.

6. Parse the JSON response

7. Display memories:
```
## Search Results for "<query>"

1. [Type] **Title** (confidence%)
   Content summary
   Tags: tag1, tag2

2. ...
```

8. Summarize key findings at the end

## Notes

- Replace `<CWD>` with the current working directory
- Replace `<QUERY>` or `<TAG>` with the extracted value
- Replace `<MCP_CLI_PATH>` with the path from SKILL.md Configuration section
- Keyword search uses hybrid (keyword + semantic) for best relevance
- Tag search is exact match on tag name
