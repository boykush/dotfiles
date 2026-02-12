#!/bin/bash
# Open file in Helix editor (tmux top-right pane of the current window)
# Assumes Helix is in normal mode
# Triggers: PreToolUse:Edit|NotebookEdit|Read, PostToolUse:Write

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

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty' 2>/dev/null)

if [ -n "$FILE_PATH" ]; then
  # Find the top-right pane of the window where this Claude process is running
  WINDOW_ID=$(tmux display-message -t "$TMUX_PANE" -p '#{window_id}')
  TARGET_PANE=$(tmux list-panes -t "$WINDOW_ID" -F '#{pane_id} #{pane_top} #{pane_left}' | sort -k2,2n -k3,3rn | head -1 | awk '{print $1}')

  # Escape spaces for Helix :open command
  ESCAPED_PATH="${FILE_PATH// /\\ }"
  tmux send-keys -t "$TARGET_PANE" ":open $ESCAPED_PATH" Enter ":reload" Enter

  # Read tool: jump to offset line if specified
  OFFSET=$(echo "$INPUT" | jq -r '.tool_input.offset // empty' 2>/dev/null)
  if [ -n "$OFFSET" ]; then
    tmux send-keys -t "$TARGET_PANE" ":goto $OFFSET" Enter "zc"
  fi
fi
