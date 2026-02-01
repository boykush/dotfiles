#!/bin/bash
# Reload file in Helix editor (tmux pane 1)
# Triggers: PostToolUse:Edit|NotebookEdit

set -euo pipefail

# Skip if not in tmux
if [ -z "${TMUX:-}" ]; then
  exit 0
fi

tmux send-keys -t :.1 ":reload" Enter
