---
name: finish-task
description: タスク完了処理 - コミット、PR作成、coordinator通知 (worker用)
disable-model-invocation: true
allowed-tools: Read, Edit, Bash(git add *), Bash(git commit *), Bash(git push *), Bash(git rev-parse *), Bash(gh pr create *), Bash(gh pr view *), Bash(tmux send-keys *)
---

# /finish-task

workerがタスク完了時に実行する。コミット、PR作成、coordinator通知を行う。

## 前提

- worktreeディレクトリ内で実行される
- コード変更が完了している

## 動作

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
   # shogun方式: より安全な通知
   tmux send-keys -t coordinator.0 "タスク完了: $REPO $WT PR: $PR_URL"
   tmux send-keys -t coordinator.0 Enter
   ```

8. 完了メッセージを表示

## エラー時

- コミットやPR作成でエラーが発生した場合も、coordinatorに状況を通知する
- 通知内容: `タスクエラー: {repo} {wt} {エラー内容}`
