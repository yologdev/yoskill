#!/bin/bash
# Yolog Session Start Hook
# Captures Claude Code session_id and makes it available to subsequent commands
# For compacted sessions: proactively injects session context into Claude's context

# Check if Yocore is running (needed for memory, archiving, indexing)
YOCORE_URL="${YOCORE_URL:-http://localhost:19420}"
if ! curl -s --connect-timeout 1 "$YOCORE_URL/health" > /dev/null 2>&1; then
    echo "⚠️  Yocore not running. Session archiving, indexing, and memory tools unavailable." >&2
    echo "   Start with: yocore" >&2
    echo "   Or install: npm install -g @yologdev/core" >&2
    echo "" >&2
fi

# Read hook input (JSON from stdin)
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // ""')
SOURCE=$(echo "$INPUT" | jq -r '.source // "startup"')  # startup, resume, clear, compact
CWD=$(echo "$INPUT" | jq -r '.cwd // ""')

# Validate session_id
if [ -z "$SESSION_ID" ] || [ "$SESSION_ID" = "null" ]; then
    echo "[yolog] Warning: No session_id in hook input" >&2
    exit 0
fi

# Make session_id available to subsequent commands via CLAUDE_ENV_FILE
# This is isolated per Claude Code session - no race conditions
if [ -n "$CLAUDE_ENV_FILE" ]; then
    echo "export YOLOG_SESSION_ID='$SESSION_ID'" >> "$CLAUDE_ENV_FILE"
    echo "export YOLOG_SESSION_SOURCE='$SOURCE'" >> "$CLAUDE_ENV_FILE"
fi

# For compacted sessions: proactively inject session context
# stdout from SessionStart hooks is automatically added to Claude's context
if [ "$SOURCE" = "compact" ]; then
    # Find MCP server binary
    MCP_SERVER_PATHS=(
        "/Applications/yolog.app/Contents/MacOS/yolog-mcp-server"
        "$HOME/.local/bin/yolog-mcp-server"
    )

    MCP_SERVER=""
    for path in "${MCP_SERVER_PATHS[@]}"; do
        if [ -x "$path" ]; then
            MCP_SERVER="$path"
            break
        fi
    done

    if [ -n "$MCP_SERVER" ] && [ -n "$CWD" ]; then
        # Get session context and output to stdout (injected into Claude's context)
        REQUEST=$(cat <<EOF
{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"yolog_get_session_context","arguments":{"session_id":"$SESSION_ID","project_path":"$CWD"}}}
EOF
)
        RESPONSE=$(echo "$REQUEST" | "$MCP_SERVER" 2>/dev/null)
        CONTEXT=$(echo "$RESPONSE" | jq -r '.result.content[0].text // empty' 2>/dev/null)

        if [ -n "$CONTEXT" ]; then
            echo "## Yolog: Session Restored After Compaction"
            echo ""
            echo "$CONTEXT"
            echo ""
            echo "---"
            echo "_Context automatically restored by Yolog. Continue where you left off._"
        fi
    fi
fi

exit 0
