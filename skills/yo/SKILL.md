---
name: yo
description: "Yolog Memory System - USE THIS PROACTIVELY: (1) at session start, (2) when summarizing work or asked 'what did we do?', (3) before answering questions about past decisions/patterns, (4) when searching for how something was done before. Commands: /yo context, /yo search <query>"
---

# Yolog Memory System

Access project memories and session context from the Yolog desktop app.

## When to Use (PROACTIVE)

| Trigger | Command |
|---------|---------|
| Session start (fresh) | `/yo context` |
| User asks "what did we do?" or "summarize" | `/yo context` |
| User asks about past decisions or patterns | `/yo search <keywords>` |
| Before implementing a feature | `/yo search <feature topic>` |
| User asks "how did we do X before?" | `/yo search <X>` |
| Wrapping up or ending session | `/yo context` to verify captured |

**Note:** After compaction, context is **automatically injected** by the SessionStart hook - no manual `/yo context` needed.

## Configuration

Yocore HTTP API URL (Yocore runs as a local HTTP server):

```
YOCORE_URL=http://127.0.0.1:19420
```

If the environment variable `YOCORE_URL` is set, use that value.
Otherwise, default to `http://127.0.0.1:19420`.

## Commands

| Command | Description |
|---------|-------------|
| `/yo context` | Get session context (current state + memories). See [CONTEXT.md](CONTEXT.md) |
| `/yo project` | Get project context (shared across all sessions). See [PROJECT.md](PROJECT.md) |
| `/yo search <query>` | Search memories by keyword, topic, or tag. See [SEARCH.md](SEARCH.md) |

**Search supports tags:** `/yo search tag:bug` or `/yo search tag:bug timezone`

## Instructions

Parse `$ARGUMENTS` to determine the command:

- **If arguments equal `context` or empty**: Follow [CONTEXT.md](CONTEXT.md)
- **If arguments equal `project`**: Follow [PROJECT.md](PROJECT.md)
- **If arguments start with `search`**: Follow [SEARCH.md](SEARCH.md)
- **If arguments invalid**: Show usage help below

## Note on Session Context

Session context (active task, decisions, questions) is **automatically populated** by Yolog during memory extraction. No manual updates needed.

## Environment Variables

The following environment variables are set by SessionStart hook:

- `YOLOG_SESSION_ID`: Current Claude Code session ID (required for context)
- `YOLOG_SESSION_SOURCE`: How session started (startup, resume, compact)

## Usage Help

```
Yolog Memory Commands:
  /yo context                  - Get session context (current state + memories)
  /yo project                  - Get project context (shared across all sessions)
  /yo search <query>           - Search memories by keyword or topic
  /yo search tag:<name>        - Filter memories by tag (e.g., tag:bug)
  /yo search tag:<name> <query> - Combined tag + keyword (e.g., tag:bug timezone)
```
