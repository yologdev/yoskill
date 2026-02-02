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

### Configure MCP CLI Path

After installation, configure the MCP CLI path:

1. Open Yolog Desktop > Settings > Memory & Skills
2. Copy the "MCP CLI Path"
3. Open `.claude/skills/yo/SKILL.md`
4. Replace the path in the Configuration section

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

The skills invoke the Yolog MCP server CLI to search your local memory database. All data stays on your machine - nothing is sent to external servers.

```
Claude Code → Skill → MCP CLI → Local SQLite DB → Memories
```

## Requirements

- Yolog Desktop (release build with MCP server)
- Claude Code
- Sessions with memory extraction completed

## License

MIT
