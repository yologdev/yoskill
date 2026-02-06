#!/bin/bash
# Yolog Session Start Hook
# Captures Claude Code session_id and makes it available to subsequent commands
# For compacted sessions: proactively injects session context into Claude's context

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
if [ "$SOURCE" = "compact" ] && [ -n "$CWD" ]; then
    YOCORE_URL="${YOCORE_URL:-http://127.0.0.1:19420}"

    # Check if Yocore is reachable
    if ! curl -s --max-time 2 "${YOCORE_URL}/health" >/dev/null 2>&1; then
        exit 0
    fi

    # Get session context via HTTP API
    RESPONSE=$(curl -s --max-time 5 -X POST "${YOCORE_URL}/api/context/session" \
      -H "Content-Type: application/json" \
      -d "{\"session_id\":\"$SESSION_ID\",\"project_path\":\"$CWD\"}" 2>/dev/null)
    CONTEXT=$(echo "$RESPONSE" | jq -r '.formatted_text // empty' 2>/dev/null)

    if [ -n "$CONTEXT" ]; then
        echo "## Yolog: Session Restored After Compaction"
        echo ""
        echo "$CONTEXT"
        echo ""
        echo "---"
        echo "_Context automatically restored by Yolog. Continue where you left off._"
    fi
fi

exit 0
