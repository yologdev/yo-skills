#!/bin/bash
# Yolog Session Start Hook
# Captures Claude Code session_id and makes it available to subsequent commands
# Also initializes session context in Yolog database

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

# Reminder for resumed/compacted sessions
if [ "$SOURCE" = "compact" ] || [ "$SOURCE" = "resume" ]; then
    echo "[yolog] Session resumed from $SOURCE. Use /yo context to get session state." >&2
fi

exit 0
