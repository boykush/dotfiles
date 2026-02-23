---
name: tmux-tasks-remove
description: Remove a worker window from the claude-tasks tmux session. Use when asked to remove or close a worker.
argument-hint: "[window-name]"
disable-model-invocation: true
allowed-tools: Bash(mise run claude:tmux-tasks:remove *), Bash(tmux list-windows -t claude-tasks *)
---

Remove a worker window from the current claude-tasks tmux session.

1. Run `tmux list-windows -t claude-tasks -F '#{window_name}'` to show available windows
2. If `$ARGUMENTS` is provided, use it as the window name
3. Otherwise, show the list (excluding "tasks") and ask the user which window to remove
4. Run: `mise run claude:tmux-tasks:remove <window-name>`
5. Report the result to the user
