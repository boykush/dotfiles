#!/bin/bash
# WorktreeCreate hook: create git worktree and set up tmux panes

INPUT=$(cat)
NAME=$(echo "$INPUT" | jq -r '.name')
CWD=$(echo "$INPUT" | jq -r '.cwd')

# Create git worktree
WT_DIR="${CWD}/.claude/worktrees/${NAME}"
git -C "$CWD" worktree add "$WT_DIR" >&2

# Trust mise config in worktree
mise trust "$WT_DIR" >&2 2>/dev/null

# Set up tmux panes pointing to worktree directory
if [ -n "$TMUX" ]; then
    SESSION=$(tmux display-message -p '#{session_name}')
    WINDOW=$(tmux display-message -p '#{window_name}')
    TARGET="${SESSION}:${WINDOW}"

    tmux split-window -h -t "$TARGET" -c "$WT_DIR" "hx"
    tmux split-window -v -t "$TARGET.1" -c "$WT_DIR" "gitui"
    tmux split-window -v -t "$TARGET.0" -c "$WT_DIR"
    tmux select-pane -t "$TARGET.0"
fi

echo "$WT_DIR"
