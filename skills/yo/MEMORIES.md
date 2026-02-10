# /yo memories

List memories extracted from the current session, with IDs for management.

## Usage

```
/yo memories
```

## Instructions

> **URL/Auth:** `<YOCORE_URL>` = `YOCORE_URL` env var or `http://127.0.0.1:19420`. `<AUTH_HEADER>` = `-H "Authorization: Bearer <key>"` if `YOCORE_API_KEY` is set, otherwise omit. Never use shell variable expansion — substitute literal values.

1. Get `YOLOG_SESSION_ID` from environment

2. If not set, inform the user:
```
Session ID not available. Ensure the SessionStart hook is configured.
Run `/yo init` to set up hooks.
```

3. Call the Yocore HTTP API:
```bash
curl -s <YOCORE_URL>/api/memories?session_id=<SESSION_ID>&limit=50&sort_by=extracted_at&sort_order=desc <AUTH_HEADER>
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

- This lists memories from the CURRENT session only
- For searching across all sessions, use `/yo memory-search`
- States: `new` (unranked), `low` (demoted), `high` (promoted/persistent)
