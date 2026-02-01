#!/bin/bash
# Focus on edited file in gitui by restarting with -f option

set -euo pipefail

INPUT=$(cat)

# Skip if not in tmux
if [ -z "${TMUX:-}" ]; then
  exit 0
fi

# Extract file path from hook input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty' 2>/dev/null)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Get relative path from repo root
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
if [ -n "$REPO_ROOT" ]; then
  REL_PATH="${FILE_PATH#$REPO_ROOT/}"
else
  REL_PATH=$(basename "$FILE_PATH")
fi

# Restart gitui with -f option to select the file
# Send Ctrl-C to quit current gitui, then start new one
tmux send-keys -t :.+ C-c
sleep 0.1
tmux send-keys -t :.+ "gitui -f '$REL_PATH'" Enter
sleep 0.3
# Switch to Status tab
tmux send-keys -t :.+ '1'
