---
name: assign-task
description: Assign a worker pane to a task. Use when asked to start, assign, resume, or begin work on a task.
disable-model-invocation: true
allowed-tools: Bash(mise run claude:tmux-tasks:assign *)
---

Assign a worker pane to a task in the claude-tasks tmux session. Requires a task created by create-task.

## Steps

1. Use TaskList to show pending and in_progress tasks. Ask the user which task to assign.
2. Use TaskGet to read the task description and get the project path.
3. Derive a kebab-case worktree name from the task subject (e.g., "add dark mode" → `add-dark-mode`).
4. Run `mise run claude:tmux-tasks:assign <project-path> <worktree-name> <task-id>`
5. If the task was pending, use TaskUpdate to set status to in_progress.
