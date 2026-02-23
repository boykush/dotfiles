---
name: create-task
description: 共有タスクリストにタスクを作成する。計画・登録を依頼された時に使う。
disable-model-invocation: true
allowed-tools: Bash(mise run claude:projects)
---

共有タスクリストに新しいタスクを作成する。

## 手順

1. どのプロジェクトか聞く。`mise run claude:projects` で候補を表示する。
2. どんなタスクか聞く。タスクの種類やカテゴリについては聞かない。
3. TaskCreate でタスクを登録する。description にプロジェクトパスを含める。
