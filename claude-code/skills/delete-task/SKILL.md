---
name: delete-task
description: 共有タスクリストからタスクを削除する。削除を依頼された時に使う。
disable-model-invocation: true
allowed-tools: Bash(tmux list-panes *), Bash(tmux kill-pane *)
---

共有タスクリストからタスクを削除し、関連するワーカーペインがあれば閉じる。

## 手順

1. TaskList で全タスクを表示し、どのタスクを削除するか聞く。
2. `tmux list-panes -t claude-tasks:tasks -F '#{pane_index} #{pane_title}'` でワーカーペイン一覧を取得する。
3. タスクの subject に対応するペインがあれば、`tmux kill-pane -t claude-tasks:tasks.{pane_index}` で閉じる。
4. TaskUpdate で status を deleted に設定する。
