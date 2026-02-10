# /yo update

Update a memory's state or confidence.

## Usage

```
/yo update <id> <field=value> [field=value...]
```

## Examples

```
/yo update 42 state=high          # Promote memory to persistent
/yo update 42 state=low           # Demote memory
/yo update 42 confidence=0.95     # Change confidence score
/yo update 42 state=high confidence=0.95  # Multiple fields
```

## Instructions

> **URL/Auth:** `<YOCORE_URL>` = `YOCORE_URL` env var or `http://127.0.0.1:19420`. `<AUTH_HEADER>` = `-H "Authorization: Bearer <key>"` if `YOCORE_API_KEY` is set, otherwise omit. Never use shell variable expansion — substitute literal values.

1. Parse memory ID and field=value pairs from arguments

2. Build the JSON body from field=value pairs. Supported fields:
   - `state`: One of `new`, `low`, `high`, `removed`
   - `confidence`: Float between 0 and 1

3. Call the Yocore HTTP API:
```bash
curl -s -X PATCH <YOCORE_URL>/api/memories/<ID> \
  -H "Content-Type: application/json" \
  <AUTH_HEADER> \
  -d '{"state":"<VALUE>"}'
```

4. Display the result or error

## Limitations

This command can change **state** and **confidence** only.
It **cannot** edit the memory's title, content, or tags.
If the memory content is wrong, use `/yo delete <id>` to remove it.

## Notes

- Use `/yo memories` or `/yo memory-search` first to find the memory ID
