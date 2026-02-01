#!/bin/bash
# Preview files in helix and show git status based on Claude Code tool events
# Layout: pane 0 = Claude, pane 1 = Helix (upper right), pane 2 = shell (lower right)

set -euo pipefail

INPUT=$(cat)

# Skip if not in tmux
if [ -z "${TMUX:-}" ]; then
  exit 0
fi

# Extract info from hook input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty' 2>/dev/null)
HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // empty' 2>/dev/null)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

# Determine command based on event and tool
case "$HOOK_EVENT:$TOOL_NAME" in
  PreToolUse:Edit|PreToolUse:NotebookEdit)
    # Open file in Helix (pane 1)
    if [ -n "$FILE_PATH" ]; then
      tmux send-keys -t :.1 ":open $FILE_PATH" Enter
    fi
    ;;
  PostToolUse:Edit|PostToolUse:NotebookEdit)
    # Reload in Helix (pane 1)
    tmux send-keys -t :.1 ":reload" Enter
    # Show git status in shell (pane 2)
    tmux send-keys -t :.2 C-c
    tmux send-keys -t :.2 "gst" Enter
    ;;
  PostToolUse:Write)
    # Open newly created file in Helix (pane 1)
    if [ -n "$FILE_PATH" ]; then
      tmux send-keys -t :.1 ":open $FILE_PATH" Enter
    fi
    # Show git status in shell (pane 2)
    tmux send-keys -t :.2 C-c
    tmux send-keys -t :.2 "gst" Enter
    ;;
  PostToolUse:Bash)
    # Show git status after git commands
    if [[ "$CMD" == git\ * ]]; then
      tmux send-keys -t :.2 C-c
      tmux send-keys -t :.2 "gst" Enter
    fi
    ;;
esac
