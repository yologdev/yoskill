# /yo memories

List memories extracted from the current session, with IDs for management.

## Usage

```
/yo memories
```

## Instructions

1. Get `YOLOG_SESSION_ID` from environment

2. If not set, inform the user:
```
Session ID not available. Ensure the SessionStart hook is configured.
Run `/yo init` to set up hooks.
```

3. Call the Yocore HTTP API:
```bash
curl -s "${YOCORE_URL:-http://127.0.0.1:19420}/api/memories?session_id=<SESSION_ID>&limit=50&sort_by=extracted_at&sort_order=desc" \
  ${YOCORE_API_KEY:+-H "Authorization: Bearer ${YOCORE_API_KEY}"}
```

4. Parse the JSON response (array of memories) and display:

```
## Memories from This Session

1. [#id] [Type] **Title** (confidence%, state: <state>)
   Content
   Tags: tag1, tag2

2. [#id] [Type] **Title** (confidence%, state: <state>)
   Content

(N total memories)
```

5. If no memories found, suggest the session may be too new for extraction.

## Notes

- Memory IDs (e.g., `[#42]`) are needed for `/yo update` and `/yo delete`
- This lists memories from the CURRENT session only
- For searching across all sessions, use `/yo memory-search`
- States: `new` (unranked), `low` (demoted), `high` (promoted/persistent)
