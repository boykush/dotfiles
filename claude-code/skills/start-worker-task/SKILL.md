---
name: start-worker-task
description: workerとしてタスクを開始する (coordinatorから呼び出される)
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Skill, Bash(git status), Bash(git diff *), Bash(git log *)
---

# /start-worker-task

workerとしてタスクを開始する。coordinatorからtmux send-keys経由で呼び出される。

## 引数

$ARGUMENTS: タスク内容

## 前提

- coordinatorによってworktreeが作成済み
- worktreeディレクトリ内で実行される
- --dangerously-skip-permissions で起動される

## workerとしてのルール

1. 与えられたタスクに集中して作業する
2. タスク内容に関連するコードのみ変更する
3. 過度な拡張や改善は行わない
4. コード変更が完了したら `/finish-task` を実行する

## 動作

1. タスク内容を確認
2. 必要なコード変更を実施
3. **コード変更完了後、必ず `/finish-task` を実行**

## 注意事項

- 不明点がある場合もタスク範囲内で最善を尽くす
- エラーが発生した場合も `/finish-task` を実行し、その旨を報告

## 完了時の必須アクション

**重要: タスク完了時は必ず以下を実行すること**

```
/finish-task
```

- これを実行しないとcoordinatorに通知されない
- PRも作成されない
- 次のタスクが開始されない
