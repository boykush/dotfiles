#!/bin/bash
# Notify the management window when a task is completed
# Trigger: TaskCompleted hook

set -euo pipefail

# Skip if not in tmux or TMUX_PANE is unavailable
if [ -z "${TMUX:-}" ] || [ -z "${TMUX_PANE:-}" ]; then
    exit 0
fi

SESSION_NAME="claude-tasks"
MANAGER_WINDOW="tasks"

# Skip if the claude-tasks session doesn't exist
if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    exit 0
fi

WORKER_NAME=$(tmux display-message -t "$TMUX_PANE" -p '#{pane_title}' 2>/dev/null) || exit 0

tmux display-message -t "$SESSION_NAME:$MANAGER_WINDOW" \
    "Task completed in [$WORKER_NAME]"
