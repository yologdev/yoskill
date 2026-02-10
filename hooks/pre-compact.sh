#!/bin/bash
# Yolog Pre-Compact Hook (Lifeboat Pattern)
# Saves session state before context compaction
# This ensures current work context survives memory compression

# Check dependencies
command -v jq >/dev/null 2>&1 || { echo "[yolog] Error: jq is required but not found" >&2; exit 0; }
command -v curl >/dev/null 2>&1 || { echo "[yolog] Error: curl is required but not found" >&2; exit 0; }

# Read hook input (JSON from stdin)
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // ""')

# Also try from environment (set by session-start hook)
if [ -z "$SESSION_ID" ] || [ "$SESSION_ID" = "null" ]; then
    SESSION_ID="${YOLOG_SESSION_ID:-}"
fi

# Validate session_id
if [ -z "$SESSION_ID" ]; then
    echo "[yolog] Warning: No session_id for pre-compact hook" >&2
    exit 0
fi

echo "[yolog] Saving lifeboat for session $SESSION_ID before compaction..." >&2

YOCORE_URL="${YOCORE_URL:-http://127.0.0.1:19420}"

# Check if Yocore is reachable
if ! curl -s --max-time 2 "${YOCORE_URL}/health" >/dev/null 2>&1; then
    echo "[yolog] Warning: Yocore not reachable at ${YOCORE_URL}, skipping lifeboat save" >&2
    exit 0
fi

# Build curl args (avoid eval for safety)
CURL_ARGS=(-s --max-time 5 -X POST "${YOCORE_URL}/api/context/lifeboat"
  -H "Content-Type: application/json")
if [ -n "${YOCORE_API_KEY:-}" ]; then
    CURL_ARGS+=(-H "Authorization: Bearer ${YOCORE_API_KEY}")
fi
CURL_ARGS+=(-d "{\"session_id\":\"$SESSION_ID\"}")

# Save lifeboat via HTTP API and verify response
HTTP_STATUS=$(curl -o /dev/null -w "%{http_code}" "${CURL_ARGS[@]}" 2>/dev/null)
if [ "${HTTP_STATUS:0:1}" = "2" ]; then
    echo "[yolog] Lifeboat saved successfully" >&2
else
    echo "[yolog] Warning: Lifeboat save failed (HTTP $HTTP_STATUS)" >&2
fi

exit 0
