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

**Option A: Yolog Desktop** (easiest)
- [Yolog Desktop](https://yolog.dev) installed - Yocore is bundled automatically
- Memory extraction enabled (Settings > AI Features)

**Option B: Yocore standalone** (for CLI-only users)
```bash
npm install -g @yologdev/core
yocore  # Start the service
```

### Option 1: Install via Claude Code (Recommended)

In Claude Code, simply say:
```
install skill https://github.com/yologdev/yo-skills
```

Then run `/yo init` to set up hooks for automatic session tracking.

### Option 2: Manual Installation

1. **Clone this repo**
   ```bash
   git clone https://github.com/yologdev/yo-skills.git
   ```

2. **Copy to your project**
   ```bash
   cp -r yo-skills/skills/yo /path/to/your/project/.claude/skills/
   ```

3. **Set up hooks** (optional but recommended)
   ```bash
   cp -r yo-skills/skills/yo/hooks /path/to/your/project/.claude/
   ```

### Configure Yocore URL (Optional)

By default, the skills connect to `http://localhost:19420`. To use a remote Yocore:

```bash
# Set environment variable
export YOCORE_URL="http://your-nas:19420"
```

Or configure in your shell profile (`~/.zshrc` or `~/.bashrc`).

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

The skills invoke Yocore (the Yolog backend service) to search your local memory database. All data stays on your machine - nothing is sent to external servers.

```
Claude Code → Skill → Yocore API → Local SQLite DB → Memories
```

## Requirements

- **Yocore** running (bundled in Yolog Desktop, or install standalone)
- Claude Code
- Sessions with memory extraction completed

**Note:** If Yocore is not running, you'll see a warning at session start:
```
⚠️  Yocore not running. Session archiving, indexing, and memory tools unavailable.
   Start with: yocore
```

## License

MIT
