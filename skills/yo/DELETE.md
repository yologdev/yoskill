# /yo delete

Remove a memory (soft delete).

## Usage

```
/yo delete <id>
```

## Examples

```
/yo delete 42
/yo delete 108
```

## Instructions

1. Parse memory ID from arguments

2. Call the Yocore HTTP API:
```bash
curl -s -X DELETE "${YOCORE_URL:-http://127.0.0.1:19420}/api/memories/<ID>" \
  ${YOCORE_API_KEY:+-H "Authorization: Bearer ${YOCORE_API_KEY}"}
```

3. On success (204 No Content), confirm:
```
Memory #<ID> deleted.
```

4. On error (404), inform:
```
Memory #<ID> not found.
```

## Notes

- This is a **soft delete** — the memory is marked as `state=removed`, not permanently destroyed
- Use `/yo memories` or `/yo memory-search` first to find the memory ID
- Write operations are NEVER proactive — only use when the user explicitly asks
