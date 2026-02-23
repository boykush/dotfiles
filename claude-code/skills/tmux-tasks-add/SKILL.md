---
name: tmux-tasks-add
description: Add a worker window to the claude-tasks tmux session. Use when asked to add a new worker or start work on a project.
disable-model-invocation: true
allowed-tools: Bash(mise run claude:tmux-tasks:add *), Bash(ls *)
---

Add a worker window to the current claude-tasks tmux session.

## Steps

1. **Project selection**: List directories under `$CLAUDE_TASKS_WORKSPACE` and ask the user which project to use.

2. **Task description**: Ask the user what task the worker will work on.

3. **Worktree name**: Derive a short, kebab-case worktree name from the task description (e.g., "fix login bug" → `fix-login-bug`). Confirm with the user.

4. **Create task**: Use TaskCreate to register the task in the shared task list with the description. Note the returned task ID number.

5. **Execute**: Run `mise run claude:tmux-tasks:add <project-path> <worktree-name> <task-id>`
   - The task ID is passed as the third argument. The worker will receive it via `--append-system-prompt` and automatically begin work on the assigned task.
   - Example: `mise run claude:tmux-tasks:add /path/to/repo fix-login-bug 3`

6. Report the result to the user.
