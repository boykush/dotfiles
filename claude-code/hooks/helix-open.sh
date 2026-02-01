#!/bin/bash
# Open file in Helix editor (tmux pane 1)
# Triggers: PreToolUse:Edit|NotebookEdit, PostToolUse:Write

set -euo pipefail

# Skip if not in tmux
if [ -z "${TMUX:-}" ]; then
  exit 0
fi

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty' 2>/dev/null)

if [ -n "$FILE_PATH" ]; then
  tmux send-keys -t :.1 ":open $FILE_PATH" Enter
fi
