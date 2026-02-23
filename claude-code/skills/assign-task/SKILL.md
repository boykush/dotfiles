---
name: assign-task
description: Assign a worker pane to a task. Use when asked to start, assign, resume, or begin work on a task.
disable-model-invocation: true
allowed-tools: Bash(mise run claude:tmux-tasks:assign *)
---

Assign a worker pane to a task in the claude-tasks tmux session. The worker uses `--allowedTools` for strict permission control.

## Steps

1. Use TaskList to show pending and in_progress tasks. Ask the user which task to assign.
2. Use TaskGet to read the task description and get the project path.
3. Derive a kebab-case worktree name from the task subject (e.g., "add dark mode" → `add-dark-mode`).
4. Run `mise run claude:tmux-tasks:assign <project-path> <worktree-name> <task-id>`
5. If the task was pending, use TaskUpdate to set status to in_progress.

## Notes

- `--allowedTools` はプロジェクトの技術スタックに応じて調整する（npm/cargo/mix等）
- `--dangerously-skip-permissions` は使用しない
- 環境変数 `CLAUDE_CODE_TASK_LIST_ID` は管理セッションから自動継承される
