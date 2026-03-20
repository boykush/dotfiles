#!/bin/bash
# SessionStart hook: set up tmux panes for worktree session

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd')
SOURCE=$(echo "$INPUT" | jq -r '.source')

# Only on initial startup, in a worktree directory, inside tmux
if [ "$SOURCE" != "startup" ] || [ -z "$TMUX" ]; then
    exit 0
fi

case "$CWD" in
    */.claude/worktrees/*) ;;
    *) exit 0 ;;
esac

# Trust mise config in worktree
mise trust "$CWD" >&2 2>/dev/null

# Set up tmux panes pointing to worktree directory
SESSION=$(tmux display-message -p '#{session_name}')
WINDOW=$(tmux display-message -p '#{window_name}')
TARGET="${SESSION}:${WINDOW}"

tmux split-window -h -t "$TARGET" -c "$CWD" "hx"
tmux split-window -v -t "$TARGET.1" -c "$CWD" "gitui"
tmux select-pane -t "$TARGET.0"
