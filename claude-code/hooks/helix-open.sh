#!/bin/bash
# Open file in Helix editor (tmux top-right pane)
# Assumes Helix is in normal mode
# Triggers: PreToolUse:Edit|NotebookEdit|Read, PostToolUse:Write

set -euo pipefail

# Skip if not in tmux
if [ -z "${TMUX:-}" ]; then
  exit 0
fi

# Skip if not in claude-dev session (e.g., Agent Teams)
SESSION_NAME=$(tmux display-message -p '#S')
if [[ "$SESSION_NAME" != claude-dev-* ]]; then
  exit 0
fi

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty' 2>/dev/null)

if [ -n "$FILE_PATH" ]; then
  # Escape spaces for Helix :open command
  ESCAPED_PATH="${FILE_PATH// /\\ }"
  tmux send-keys -t "{top-right}" ":open $ESCAPED_PATH" Enter
fi
