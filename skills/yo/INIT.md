# /yo init

Set up Yolog hooks and configuration for the current project.

## Usage

```
/yo init
```

## What This Does

1. Creates `.claude/hooks/` directory if it doesn't exist
2. Copies `session-start.sh` and `pre-compact.sh` hooks
3. Configures hooks in `.claude/settings.local.json`
4. Verifies Yocore HTTP API is accessible

## Instructions

### Step 1: Create hooks directory

```bash
mkdir -p .claude/hooks
```

### Step 2: Copy hook scripts

Copy the hook scripts from this skill's `hooks/` directory to the project:

```bash
# Get the skill directory path (where this INIT.md is located)
SKILL_DIR="<SKILL_DIRECTORY>"

cp "$SKILL_DIR/hooks/session-start.sh" .claude/hooks/
cp "$SKILL_DIR/hooks/pre-compact.sh" .claude/hooks/
chmod +x .claude/hooks/*.sh
```

### Step 3: Configure hooks in settings

Read `.claude/settings.local.json` if it exists, then merge the hooks configuration:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/session-start.sh"
          }
        ]
      }
    ],
    "PreCompact": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/pre-compact.sh"
          }
        ]
      }
    ]
  }
}
```

If the file already has a `hooks` key, merge carefully to preserve existing hooks.

### Step 4: Verify Yocore is running

Check if the Yocore HTTP API is accessible:

```bash
curl -s --max-time 2 http://127.0.0.1:19420/health
```

If this fails, the user needs to start the Yolog desktop app (which launches Yocore).

### Step 5: Add memory protocol to CLAUDE.md

Append the following to the project's `CLAUDE.md` (create if doesn't exist):

```markdown
### Yolog Memory Protocol (PROACTIVE USE REQUIRED)

This project uses Yolog for persistent memory across coding sessions. Hooks in `.claude/hooks/` handle session lifecycle automatically.

**Commands (use proactively — do NOT wait for the user to ask):**

| Command | When to use |
|---------|-------------|
| `/yo context` | At session start. When summarizing work or asked "what did we do?" |
| `/yo memory-search <query>` | BEFORE implementing features. BEFORE answering "what did we decide about X?" |
| `/yo memory-search tag:<name>` | Filter by tag: `tag:bug`, `tag:security`, `tag:architecture`, etc. |
| `/yo project-search <query>` | Find past conversations: "when did we discuss X?", "how did we do X before?" |
| `/yo project` | Before working in an unfamiliar area of the codebase |
| `/yo memories` | When user asks about extracted memories from this session |

**Rules — you MUST follow these:**
- **ALWAYS** `/yo memory-search` BEFORE answering questions about past decisions, patterns, or conventions — do NOT rely on your own memory
- **ALWAYS** `/yo memory-search` BEFORE implementing a feature — check if it was discussed or attempted before
- **ALWAYS** `/yo memory-search` when debugging — past sessions may have solved the same issue
- After compaction, context is auto-injected by hooks — no manual `/yo context` needed
- Quote relevant memory IDs (e.g., `[#42]`) when referencing past decisions
- `/yo update` and `/yo delete` are NEVER proactive — only when user explicitly asks
```

### Step 6: Display success message

```
Yolog hooks configured successfully!

Hooks installed:
  - .claude/hooks/session-start.sh (captures session ID, auto-restores context after compaction)
  - .claude/hooks/pre-compact.sh (saves lifeboat before compaction)

Settings updated:
  - .claude/settings.local.json

CLAUDE.md updated:
  - Added Yolog Memory Protocol section

Next steps:
  1. Restart Claude Code to activate hooks
  2. Use /yo context to verify session ID is captured

Yocore API: [http://127.0.0.1:19420 or "Not reachable - start Yolog desktop app"]
```

## Error Handling

- If `.claude/settings.local.json` has invalid JSON, back it up and create fresh
- If hooks already exist, ask user before overwriting
- If Yocore is not reachable, warn but continue (hooks will work once Yocore starts)

## Notes

- `<SKILL_DIRECTORY>` is the directory containing this skill (where SKILL.md is located)
- The hooks require `jq` and `curl` to be installed
- After init, user must restart Claude Code for hooks to take effect
