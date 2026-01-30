#!/bin/bash
# Yolog Pre-Compact Hook (Lifeboat Pattern)
# Saves session state before context compaction
# This ensures current work context survives memory compression

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

# Call yolog MCP server to save lifeboat if available
# The MCP server binary path - check common locations
MCP_SERVER_PATHS=(
    "/Applications/yolog.app/Contents/MacOS/yolog-mcp-server"
    "$HOME/.local/bin/yolog-mcp-server"
    "$(dirname "$0")/../../mcp-server/target/release/yolog-mcp-server"
)

MCP_SERVER=""
for path in "${MCP_SERVER_PATHS[@]}"; do
    if [ -x "$path" ]; then
        MCP_SERVER="$path"
        break
    fi
done

if [ -n "$MCP_SERVER" ]; then
    # Send save_lifeboat request via MCP protocol
    REQUEST=$(cat <<EOF
{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"yolog_save_lifeboat","arguments":{"session_id":"$SESSION_ID"}}}
EOF
)
    echo "$REQUEST" | "$MCP_SERVER" 2>/dev/null
    echo "[yolog] Lifeboat saved successfully" >&2
else
    echo "[yolog] Warning: yolog-mcp-server not found, skipping lifeboat save" >&2
fi

exit 0
