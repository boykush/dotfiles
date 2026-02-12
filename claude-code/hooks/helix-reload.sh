#!/bin/bash
# Reload file in Helix editor (tmux top-right pane of the current window)
# Assumes Helix is in normal mode
# Triggers: PostToolUse:Edit|NotebookEdit

set -euo pipefail

# Skip if not in tmux
if [ -z "${TMUX:-}" ]; then
  exit 0
fi

# Skip if not in claude-dev session (e.g., Agent Teams)
SESSION_NAME=$(tmux display-message -t "$TMUX_PANE" -p '#S')
if [[ "$SESSION_NAME" != "claude-dev" ]]; then
  exit 0
fi

# Find the top-right pane of the window where this Claude process is running
WINDOW_ID=$(tmux display-message -t "$TMUX_PANE" -p '#{window_id}')
TARGET_PANE=$(tmux list-panes -t "$WINDOW_ID" -F '#{pane_id} #{pane_top} #{pane_left}' | sort -k2,2n -k3,3rn | head -1 | awk '{print $1}')

tmux send-keys -t "$TARGET_PANE" ":reload" Enter
