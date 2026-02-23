---
name: delete-task
description: 共有タスクリストからタスクを削除する。削除を依頼された時に使う。
disable-model-invocation: true
---

共有タスクリストからタスクを削除する。

## 手順

1. TaskList で全タスクを表示し、どのタスクを削除するか聞く。
2. TaskUpdate で status を deleted に設定する。
