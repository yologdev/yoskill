# /yo search

Search memories by keyword, topic, or tag.

## Usage

```
/yo search <query>                    # Keyword/semantic search
/yo search tag:<tagname>              # Filter by tag only
/yo search tag:<tagname> <query>      # Combined: tag filter + keyword search
```

## Examples

```
/yo search error handling
/yo search authentication flow
/yo search tag:bug
/yo search tag:bug timezone           # Bugs related to timezone
/yo search tag:security api           # Security issues about API
```

## Instructions

1. Extract the search query (everything after "search ")

2. Parse for tag and keyword:
   - If starts with `tag:<name>` → extract tag name, rest is keyword query
   - Otherwise → keyword-only search

   Examples:
   - `tag:bug` → tags=["bug"], query=none
   - `tag:frontend api` → tags=["frontend"], query="api"
   - `error handling` → tags=none, query="error handling"

3. Call the Yocore HTTP API with the appropriate parameters:
```bash
# Keyword-only search
curl -s -X POST "${YOCORE_URL:-http://127.0.0.1:19420}/api/context/search" \
  -H "Content-Type: application/json" \
  -d '{"query":"<QUERY>","project_path":"<CWD>","limit":10}'

# Tag-only filter
curl -s -X POST "${YOCORE_URL:-http://127.0.0.1:19420}/api/context/search" \
  -H "Content-Type: application/json" \
  -d '{"tags":["<TAG>"],"project_path":"<CWD>","limit":10}'

# Tag + keyword combined
curl -s -X POST "${YOCORE_URL:-http://127.0.0.1:19420}/api/context/search" \
  -H "Content-Type: application/json" \
  -d '{"query":"<QUERY>","tags":["<TAG>"],"project_path":"<CWD>","limit":10}'
```

4. Parse the JSON response

5. Display memories:
```
## Search Results for "<query>"

1. [Type] **Title** (confidence%)
   Content summary
   Tags: tag1, tag2

2. ...
```

6. Summarize key findings at the end

## Notes

- Replace `<CWD>` with the current working directory
- Replace `<QUERY>` or `<TAG>` with the extracted value
- Keyword search uses hybrid (keyword + semantic) for best relevance
- Tag search filters by exact tag match (AND logic when multiple tags)
