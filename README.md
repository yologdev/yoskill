# Yolog Skills for Claude Code

Recall project memories during coding sessions. Give Claude Code access to decisions, facts, preferences, and context extracted from your past coding sessions.

## What is this?

[Yolog](https://yolog.dev) archives and analyzes your AI coding sessions, extracting valuable memories like:
- **Decisions** - Why you chose a particular approach
- **Facts** - Important information about your codebase
- **Preferences** - Your coding style and conventions
- **Context** - Background information for tasks
- **Tasks** - Work in progress and completed items

These skills let you quickly recall this knowledge in Claude Code using simple commands.

## Available Skills

### `/yo` - Memory Recall & Management

| Command | Description |
|---------|-------------|
| `/yo context` | Get session context + memories (use at session start) |
| `/yo project` | Get project-wide context (shared across all sessions) |
| `/yo memory-search <query>` | Search extracted memories (hybrid FTS + vector) |
| `/yo memory-search tag:<name>` | Filter memories by tag (e.g., `tag:bug`, `tag:security`) |
| `/yo project-search <query>` | Search raw session messages (BM25 FTS) |
| `/yo memories` | List memories from current session (with IDs) |
| `/yo update <id> state=<value>` | Update a memory's state or confidence |
| `/yo delete <id>` | Remove a memory (soft delete) |
| `/yo tags` | List available memory tags |
| `/yo status` | Check Yocore connection status |
| `/yo init` | Set up hooks and configuration |

**Examples:**
```
/yo context
/yo memory-search error handling
/yo memory-search tag:bug authentication
/yo project-search "config migration"
/yo memories
/yo project
```

**Note:** After context compaction, session context is **automatically restored** - no manual `/yo context` needed.

## Installation

### Prerequisites

1. [Yolog Desktop](https://yolog.dev) installed with sessions imported
2. Memory extraction enabled (Settings > AI Features)

### Option 1: Install via Claude Code (Recommended)

In Claude Code, simply say:
```
install skill https://github.com/yologdev/yoskill
```

Then run `/yo init` to set up hooks for automatic session tracking.

### Option 2: Manual Installation

1. **Clone this repo**
   ```bash
   git clone https://github.com/yologdev/yoskill.git
   ```

2. **Copy to your project**
   ```bash
   cp -r yoskill/skills/yo /path/to/your/project/.claude/skills/
   ```

3. **Set up hooks** (optional but recommended)
   ```bash
   cp -r yoskill/skills/yo/hooks /path/to/your/project/.claude/
   ```

### Verify Yocore is Running

After installation, ensure the Yocore HTTP API is accessible:

```bash
curl -s http://127.0.0.1:19420/health
```

If this fails, start the Yolog desktop app (which launches Yocore automatically).

### Start Using

```
/yo context
/yo memory-search database migrations
/yo memory-search tag:bug
/yo project-search "how we implemented auth"
```

## Features

### Automatic Context Restoration

When context compaction happens, the SessionStart hook automatically injects your session context back into Claude's context. No manual action needed - just continue where you left off.

### Lifeboat Pattern

Before context compaction, the PreCompact hook saves your current work state (active task, decisions, questions). This "lifeboat" ensures nothing is lost during compaction.

### Tag-Based Search

Search memories by tags for targeted results:
- `tag:bug` - Find bug-related memories
- `tag:security` - Security concerns
- `tag:frontend` - Frontend-specific patterns
- `tag:performance` - Performance optimizations

## How it Works

The skills call the Yocore HTTP API (`localhost:19420`) to search your local memory database. All data stays on your machine - nothing is sent to external servers.

```
Claude Code → Skill → curl → Yocore HTTP API → Local SQLite DB → Memories
```

## Requirements

- Yolog Desktop (which runs Yocore as a local HTTP server)
- Claude Code
- Sessions with memory extraction completed
- `curl` and `jq` installed (typically available by default)

## License

MIT
