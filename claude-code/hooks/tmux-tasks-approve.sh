#!/bin/bash
# Redirect worker tool approval to the management window
# Trigger: PreToolUse (worker sessions only)

set -euo pipefail

# Skip if not in tmux or if this IS the management window
if [ -z "${TMUX:-}" ]; then
    exit 0
fi

SESSION_NAME="claude-tasks"
MANAGER_WINDOW="tasks"
CURRENT_WINDOW=$(tmux display-message -t "$TMUX_PANE" -p '#{window_name}')

# Skip approval for the management window itself
if [ "$CURRENT_WINDOW" = "$MANAGER_WINDOW" ]; then
    exit 0
fi

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input | tostring' | head -c 500)

RESPONSE_FILE=$(mktemp /tmp/tmux-tasks-approve.XXXXXX)

# Show approval popup in the management window
tmux display-popup -t "$SESSION_NAME:$MANAGER_WINDOW" -w 80 -h 20 -E \
    "echo '=== Worker: $CURRENT_WINDOW ===' && \
     echo 'Tool: $TOOL_NAME' && \
     echo '---' && \
     echo '$TOOL_INPUT' | head -15 && \
     echo '---' && \
     read -p 'Approve? (y/n): ' answer && \
     echo \"\$answer\" > $RESPONSE_FILE"

# Wait for response (timeout 60s)
for i in $(seq 1 120); do
    if [ -s "$RESPONSE_FILE" ]; then
        ANSWER=$(cat "$RESPONSE_FILE")
        rm -f "$RESPONSE_FILE"
        if [ "$ANSWER" = "y" ]; then
            exit 0
        else
            echo "Manager rejected this action"
            exit 2
        fi
    fi
    sleep 0.5
done

rm -f "$RESPONSE_FILE"
echo "Approval timed out"
exit 2
