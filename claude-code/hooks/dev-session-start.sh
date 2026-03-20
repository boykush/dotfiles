#!/bin/bash
# SessionStart hook: set up tmux panes (hx + gitui)

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd')
SOURCE=$(echo "$INPUT" | jq -r '.source')

# Only on initial startup, inside tmux
if [ "$SOURCE" != "startup" ] || [ -z "$TMUX" ]; then
    exit 0
fi

# Trust mise config in worktree
case "$CWD" in
    */.claude/worktrees/*) mise trust "$CWD" >&2 2>/dev/null ;;
esac

# Set up tmux panes
SESSION=$(tmux display-message -p '#{session_name}')
WINDOW=$(tmux display-message -p '#{window_name}')
TARGET="${SESSION}:${WINDOW}"

tmux split-window -h -t "$TARGET" -c "$CWD" "hx"
tmux split-window -v -t "$TARGET.1" -c "$CWD" "gitui"
tmux select-pane -t "$TARGET.0"
