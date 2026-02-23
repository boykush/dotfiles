#!/bin/bash
# Notify the management window when a task is completed
# Trigger: TaskCompleted hook

set -euo pipefail

# Skip if not in tmux
if [ -z "${TMUX:-}" ]; then
    exit 0
fi

SESSION_NAME="claude-tasks"
MANAGER_WINDOW="tasks"

# Get current window name for the notification
CURRENT_WINDOW=$(tmux display-message -t "$TMUX_PANE" -p '#{window_name}')

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux display-message -t "$SESSION_NAME:$MANAGER_WINDOW" \
        "Task completed in [$CURRENT_WINDOW]"
fi
