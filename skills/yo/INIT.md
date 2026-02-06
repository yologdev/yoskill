# /yo init

Set up Yolog configuration for the current project.

## Usage

```
/yo init
```

## What This Does

1. Verifies Yocore HTTP API is accessible
2. Adds Yolog Memory Protocol to CLAUDE.md
3. Adds auto-approve permissions to settings

> **Note:** If installed via `claude plugin install`, hooks are registered automatically. This command only needs to set up project-specific configuration.

## Instructions

### Step 1: Verify Yocore is running

Check if the Yocore HTTP API is accessible:

```bash
curl -s --max-time 2 http://127.0.0.1:19420/health
```

If this fails, the user needs to start the Yolog desktop app (which launches Yocore).

### Step 2: Add memory protocol to CLAUDE.md

Append the following to the project's `CLAUDE.md` (create if doesn't exist):

```markdown
### Yolog Memory Protocol (PROACTIVE USE REQUIRED)

This project uses Yolog for persistent memory across coding sessions. Hooks handle session lifecycle automatically.

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

### Step 3: Add auto-approve permissions

Merge the following into `.claude/settings.local.json` permissions allow list (create if needed):

```json
"Skill(yo)",
"Bash(curl:*)"
```

This allows `/yo` commands to run without manual approval each time.

### Step 4: Display success message

```
Yolog configured successfully!

CLAUDE.md updated:
  - Added Yolog Memory Protocol section

Settings updated:
  - .claude/settings.local.json (auto-approve permissions)

Next steps:
  1. Restart Claude Code to activate hooks
  2. Use /yo context to verify session ID is captured

Yocore API: [http://127.0.0.1:19420 or "Not reachable - start Yolog desktop app"]
```

## Error Handling

- If `.claude/settings.local.json` has invalid JSON, back it up and create fresh
- If Yocore is not reachable, warn but continue (hooks will work once Yocore starts)

## Notes

- The hooks require `jq` and `curl` to be installed
- After init, user must restart Claude Code for hooks to take effect
