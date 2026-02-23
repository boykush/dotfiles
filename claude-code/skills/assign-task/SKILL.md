---
name: assign-task
description: タスクにワーカーを割り当てる。開始・アサイン・着手を依頼された時に使う。
disable-model-invocation: true
allowed-tools: Bash(mise run claude:tmux-tasks:assign *)
---

claude-tasks tmuxセッションでタスクにワーカーペインを割り当てる。ワーカーは `--dangerously-skip-permissions` で全権限を持つ。

## 手順

1. TaskList で pending / in_progress のタスクを表示し、どのタスクに割り当てるか聞く。
2. TaskGet でタスクの説明とプロジェクトパスを取得する。
3. タスクの subject から kebab-case のworktree名を導出する（例: "add dark mode" → `add-dark-mode`）。
4. `mise run claude:tmux-tasks:assign <project-path> <worktree-name> <task-id>` を実行する。
5. タスクが pending だった場合、TaskUpdate で status を in_progress に更新する。

## 注意

- 環境変数 `CLAUDE_CODE_TASK_LIST_ID` は管理セッションから自動継承される
