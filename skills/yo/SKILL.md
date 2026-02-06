---
name: yo
description: "Yolog Memory System - USE PROACTIVELY. MUST search before: answering 'what did we decide/do?', implementing features, debugging familiar issues, answering 'why did we...'. Commands: /yo context (session start), /yo memory-search <query> (decisions/patterns), /yo project-search <query> (past conversations)"
---

# Yolog Memory System

Access project memories, session context, and raw conversation search from the Yolog desktop app via Yocore HTTP API.

## When to Use (PROACTIVE — do NOT wait for user to ask)

| Trigger | Command |
|---------|---------|
| Session start (fresh) | `/yo context` |
| User asks "what did we do?" or "summarize" | `/yo context` |
| User asks about past decisions or patterns | `/yo memory-search <keywords>` |
| User asks "why did we..." / "what was the reason for..." | `/yo memory-search <topic>` |
| User says "I don't remember" / "what was..." | `/yo memory-search <topic>` |
| Before implementing a feature | `/yo memory-search <feature topic>` |
| User is debugging something | `/yo memory-search <error or topic>` |
| User asks "how did we do X before?" | `/yo project-search <X>` |
| User asks "when did we discuss X?" / "find the conversation about X" | `/yo project-search <X>` |
| Before working in unfamiliar area of codebase | `/yo project` |
| Wrapping up or ending session | `/yo context` to verify captured |

**Key:** If the answer might exist in past sessions, **search first, answer second.**

**Note:** After compaction, context is **automatically injected** by the SessionStart hook - no manual `/yo context` needed.

## Configuration

Yocore HTTP API URL (defaults to local):

```
YOCORE_URL=http://127.0.0.1:19420
```

For remote Yocore, also set the API key:

```
YOCORE_API_KEY=your-api-key
```

## Authentication

If `YOCORE_API_KEY` is set, include it as a header in ALL API requests:

```
-H "Authorization: Bearer ${YOCORE_API_KEY}"
```

If not set, omit the header (local Yocore does not require auth).

## Project ID Resolution

Some commands need the project UUID. Resolve it from the current working directory:

```bash
curl -s "${YOCORE_URL:-http://127.0.0.1:19420}/api/projects/resolve?path=<CWD>" \
  ${YOCORE_API_KEY:+-H "Authorization: Bearer ${YOCORE_API_KEY}"}
```

Returns `{ "id": "uuid", "name": "project-name", "folder_path": "..." }` or 404.

Use the `id` field as `<PROJECT_ID>` in subsequent API calls.

## Commands

| Command | Description |
|---------|-------------|
| `/yo context` | Get session context (current state + memories). See [CONTEXT.md](CONTEXT.md) |
| `/yo project` | Get project context (shared across all sessions). See [PROJECT.md](PROJECT.md) |
| `/yo memory-search <query>` | Search extracted memories (hybrid FTS+vector). See [SEARCH.md](SEARCH.md) |
| `/yo project-search <query>` | Search raw session messages (BM25 FTS). See [PROJECT-SEARCH.md](PROJECT-SEARCH.md) |
| `/yo memories` | List memories from current session with IDs. See [MEMORIES.md](MEMORIES.md) |
| `/yo update <id> <field=value>` | Update a memory's state or confidence. See [UPDATE.md](UPDATE.md) |
| `/yo delete <id>` | Remove a memory (soft delete). See [DELETE.md](DELETE.md) |
| `/yo tags` | List available memory tags. See [TAGS.md](TAGS.md) |
| `/yo status` | Check if Yocore is running. See [STATUS.md](STATUS.md) |
| `/yo init` | Set up hooks and configuration. See [INIT.md](INIT.md) |

## Instructions

Parse `$ARGUMENTS` to determine the command:

- **If arguments equal `context` or empty**: Follow [CONTEXT.md](CONTEXT.md)
- **If arguments equal `project`**: Follow [PROJECT.md](PROJECT.md)
- **If arguments start with `memory-search`**: Follow [SEARCH.md](SEARCH.md)
- **If arguments start with `project-search`**: Follow [PROJECT-SEARCH.md](PROJECT-SEARCH.md)
- **If arguments equal `memories`**: Follow [MEMORIES.md](MEMORIES.md)
- **If arguments start with `update`**: Follow [UPDATE.md](UPDATE.md)
- **If arguments start with `delete`**: Follow [DELETE.md](DELETE.md)
- **If arguments equal `tags`**: Follow [TAGS.md](TAGS.md)
- **If arguments equal `status`**: Follow [STATUS.md](STATUS.md)
- **If arguments equal `init`**: Follow [INIT.md](INIT.md)
- **If arguments invalid**: Show usage help below

## Environment Variables

Set by SessionStart hook:

- `YOLOG_SESSION_ID`: Current Claude Code session ID (required for context/memories)
- `YOLOG_SESSION_SOURCE`: How session started (startup, resume, compact)

## Usage Help

```
Yolog Memory Commands:
  /yo context                       - Get session context (current state + memories)
  /yo project                       - Get project context (shared across all sessions)
  /yo memory-search <query>         - Search extracted memories by keyword or topic
  /yo memory-search tag:<name>      - Filter memories by tag (e.g., tag:bug)
  /yo project-search <query>        - Search raw session messages (conversations)
  /yo memories                      - List memories from current session (with IDs)
  /yo update <id> state=<value>     - Update memory state (new/low/high)
  /yo delete <id>                   - Remove a memory (soft delete)
  /yo tags                          - List available memory tags
  /yo status                        - Check Yocore connection status
  /yo init                          - Set up hooks and configuration
```
