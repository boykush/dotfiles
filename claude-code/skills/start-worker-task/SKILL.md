---
name: start-worker-task
description: workerとしてタスクを開始し、完了時にPR作成・通知まで行う
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash(git status), Bash(git diff *), Bash(git log *), Bash(git add *), Bash(git commit *), Bash(git push *), Bash(git rev-parse *), Bash(gh pr create *), Bash(gh pr view *), Bash(tmux send-keys *)
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

## 動作

### Phase 1: タスク実行

1. タスク内容を確認
2. 必要なコード変更を実施

### Phase 2: 完了処理

コード変更が完了したら、以下を実行:

1. 変更をステージング・コミット:
   ```bash
   git add -A
   git commit -m "{タスク内容の要約}"
   ```

2. リモートにプッシュ:
   ```bash
   git push -u origin HEAD
   ```

3. PR作成:
   ```bash
   gh pr create --title "{タスク内容}" --body "{詳細}"
   ```

4. PR URLを取得:
   ```bash
   PR_URL=$(gh pr view --json url -q .url)
   ```

5. 現在のworktree情報を取得:
   ```bash
   REPO=$(basename $(git rev-parse --show-toplevel))
   WT=$(basename $(pwd))
   ```

6. .tasks.mdを更新 (In Progress → In Review):
   ```bash
   # 親ディレクトリの.tasks.mdを取得
   TASKS_FILE="$(git rev-parse --show-toplevel)/../../.tasks.md"
   ```
   - Editツールを使用して該当タスクを In Progress から In Review へ移動
   - タスクIDまたはworktree名で検索して該当行を特定
   - PRリンクを追記: `[PR](PR_URL)`

7. coordinatorに通知 (2ステップ):
   ```bash
   tmux send-keys -t coordinator.0 "タスク完了: $REPO $WT PR: $PR_URL"
   tmux send-keys -t coordinator.0 Enter
   ```

8. 完了メッセージを表示

## 注意事項

- 不明点がある場合もタスク範囲内で最善を尽くす
- エラーが発生した場合もcoordinatorに状況を通知する
- 通知内容: `タスクエラー: {repo} {wt} {エラー内容}`

## 重要

**Phase 2の完了処理は必ず実行すること**

- これを実行しないとcoordinatorに通知されない
- PRも作成されない
- 次のタスクが開始されない
