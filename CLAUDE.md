# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Yoskill is a Claude Code plugin that gives Claude access to persistent memories from [Yocore](https://yolog.dev). It provides the `/yo` skill with subcommands for recalling decisions, facts, preferences, and session context extracted from past coding sessions. All data stays local — the skill calls the Yocore HTTP API at `localhost:19420`.

## Repository Structure

This is a pure skill/plugin repo with no build system, tests, or compiled code.

- **`skills/yo/`** — The `/yo` skill for Claude Code
  - `SKILL.md` — Skill entrypoint and router. Parses `$ARGUMENTS` and dispatches to the appropriate command file. Contains the frontmatter (`name`, `description`), tiered proactive-use triggers, and conventions.
  - One `.md` file per subcommand: `CONTEXT.md`, `SEARCH.md`, `PROJECT.md`, `PROJECT-SEARCH.md`, `MEMORIES.md`, `UPDATE.md`, `DELETE.md`, `TAGS.md`, `STATUS.md`, `INIT.md`
- **`hooks/`** — Claude Code lifecycle hooks
  - `hooks.json` — Hook registration (uses `${CLAUDE_PLUGIN_ROOT}` for path resolution)
  - `session-start.sh` — Sets `YOLOG_SESSION_ID` env var; on compaction, auto-injects session context via stdout
  - `pre-compact.sh` — Lifeboat pattern: saves session state to Yocore before context compaction

## Architecture: How the Skill Works

```
User runs /yo <command> → SKILL.md routes by $ARGUMENTS → <COMMAND>.md instructions
→ Claude executes curl commands → Yocore HTTP API (localhost:19420) → Local SQLite DB
```

Each command `.md` file is a self-contained instruction set telling Claude what curl commands to run and how to format the response — including its own URL/auth resolution block. The skill has no executable code of its own — it's entirely prompt-driven.

**Portability files** (repo root):
- `API-REFERENCE.md` — Tool-agnostic Yocore HTTP API docs for any integration
- `LLM-PROMPT-SNIPPET.md` — Copy-pasteable system prompt snippet for non-Claude-Code LLM tools (Cursor, Windsurf, Copilot, etc.)

**Hook lifecycle:**
1. `SessionStart` hook captures `session_id` into `CLAUDE_ENV_FILE` so subsequent `/yo` commands can use it
2. On compaction (`source=compact`), `SessionStart` hook fetches and prints session context (stdout is injected into Claude's context)
3. `PreCompact` hook saves a "lifeboat" to Yocore before compaction so nothing is lost

## Key Conventions

- **Never use shell variable expansion (`${VAR:-default}`) in curl commands** — Claude Code's permission system can't match them. Always resolve env vars to literal values first, then substitute into the curl command.
- **URL resolution pattern**: Check `YOCORE_URL` env var; if unset, use `http://127.0.0.1:19420`. Check `YOCORE_API_KEY`; if set, add `-H "Authorization: Bearer <key>"`. Use literal values in all curl calls.
- **Project ID resolution**: Many commands need the project UUID. Resolve via `GET /api/projects/resolve?path=<CWD>` and extract the `id` field.
- **Memory IDs**: Always display memory IDs (e.g., `[#42]`) in output — they enable `/yo update` and `/yo delete`.
- **Read vs write commands**: Search/context commands should be used proactively. Write commands (`update`, `delete`) are NEVER proactive — only when user explicitly asks.
- Hook scripts use `${CLAUDE_PLUGIN_ROOT}` in `hooks.json` for absolute path resolution when installed as a plugin.
