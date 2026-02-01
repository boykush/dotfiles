---
name: clear-done
description: Doneセクションをクリアする
disable-model-invocation: true
allowed-tools: Read, Write, Edit
---

# /clear-done

.tasks.md の Done セクションをクリアする。

## 動作

1. .tasks.md の Done セクションを読み取り
2. Done セクション内のタスク一覧を削除
3. クリアした件数を表示:
   ```
   Done セクションをクリアしました (3件)
   ```

## 注意事項

- Done以外のセクション (Queue, In Progress, In Review) は変更しない
- クリア前に確認は行わない（必要であればユーザーが事前確認）
