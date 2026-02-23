---
name: tmux-tasks-add
description: Add a worker pane to the claude-tasks tmux session. Use when asked to add a new worker or start work on a project.
disable-model-invocation: true
allowed-tools: Bash(mise run claude:tmux-tasks:add *), Bash(ls *)
---

Add a worker pane to the claude-tasks tmux session.

## Steps

1. Ask the user which project to use. List subdirectories of the current working directory as candidates.
2. Ask the user what task the worker should do. Do not ask about task type, category, or any other classification.
3. Derive a kebab-case worktree name from the task description (e.g., "add dark mode" → `add-dark-mode`).
3. Use TaskCreate to register the task. Note the task ID.
4. Run `mise run claude:tmux-tasks:add <project-path> <worktree-name> <task-id>`
