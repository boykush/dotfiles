---
name: sync-reviews
description: In ReviewのPRマージ状態を確認してDoneへ移動
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash(gh pr view *), Bash(git worktree remove *), Bash(git worktree list), Bash(git branch -d *)
---

# /sync-reviews

In ReviewセクションのPRマージ状態を確認し、完了済みならDoneへ移動する。

## 動作

1. .tasks.md の In Review セクションを読み取り

2. 各タスクのPR URLを抽出

3. 各PRの状態を確認:
   ```bash
   gh pr view {PR_URL} --json state -q .state
   ```

4. PR状態に応じた処理:

   | PR状態 | 動作 | Done表記 |
   |--------|------|----------|
   | MERGED | Done移動 | `[PR #N](url)` |
   | CLOSED | Done移動 | `[PR #N](url) (Closed)` |
   | OPEN | In Review維持 | - |

5. Done移動時、対応するworktreeをクリーンアップ:
   ```bash
   cd {repo}
   git worktree remove wt/{task-id}
   git branch -d {task-id}
   ```

6. 更新結果を表示:
   ```
   同期完了:
   - [認証統合] repo-a: 認証API → Done (Merged)
   - [ログ改善] repo-b: JSON形式化 → Done (Closed)
   - [CI改善] repo-c: ビルド高速化 → まだOpen
   ```

## 注意事項

- worktree削除に失敗した場合は警告を表示して続行
- ブランチ削除に失敗した場合も警告を表示して続行
