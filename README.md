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

### `/yo` - Memory Recall

| Command | Description |
|---------|-------------|
| `/yo context` | Get session context + memories (use at session start) |
| `/yo project` | Get project-wide context (shared across all sessions) |
| `/yo search <query>` | Search memories by keyword or topic |
| `/yo search tag:<name>` | Filter memories by tag (e.g., `tag:bug`, `tag:security`) |
| `/yo search tag:<name> <query>` | Combined tag + keyword search |

**Examples:**
```
/yo context
/yo search error handling
/yo search tag:bug authentication
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
/yo search database migrations
/yo search tag:bug
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
