# /yo tags

List available memory tags for the current project.

## Usage

```
/yo tags
```

## Instructions

1. Resolve the project ID:
```bash
PROJECT=$(curl -s "${YOCORE_URL:-http://127.0.0.1:19420}/api/projects/resolve?path=<CWD>" \
  ${YOCORE_API_KEY:+-H "Authorization: Bearer ${YOCORE_API_KEY}"})
PROJECT_ID=$(echo "$PROJECT" | jq -r '.id')
```

2. Call the Yocore HTTP API:
```bash
curl -s "${YOCORE_URL:-http://127.0.0.1:19420}/api/projects/<PROJECT_ID>/memory-tags" \
  ${YOCORE_API_KEY:+-H "Authorization: Bearer ${YOCORE_API_KEY}"}
```

3. Display the tags:
```
## Memory Tags for [project_name]

architecture, bug, database, deployment, performance, security, testing, ui, ...
(N tags total)

Use: /yo memory-search tag:<name> to filter memories by tag
```

## Notes

- Replace `<CWD>` with the current working directory
- Tags help discover what to search for with `/yo memory-search tag:<name>`
