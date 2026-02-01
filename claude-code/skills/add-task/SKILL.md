---
name: add-task
description: タスクを分解・承認してQueueに追加する
disable-model-invocation: true
allowed-tools: Read, Write, Edit
---

# /add-task

タスクを .tasks.md の Queue に追加する。

## 引数

$ARGUMENTS: タスク内容 (自然言語)

## 動作パターン

### A. リポジトリ指定なし (ざっくり指示)

入力例: "認証統合やりたい"

1. カレントディレクトリのリポジトリ一覧を確認
2. タスク内容を分析し、PR単位に分解
3. 分解結果を提案:
   ```
   以下のタスクに分解しました:
   - [認証統合] repo-a: 認証API実装
   - [認証統合] repo-b: 認証UI実装

   Queueに追加しますか? (y/n/修正指示)
   ```
4. ユーザー承認後、Queueに追加

### B. リポジトリ指定あり

入力例: "repo-aに認証API追加して"

1. 指定されたリポジトリを確認
2. 確認を表示:
   ```
   以下をQueueに追加します:
   - repo-a: 認証API追加

   よろしいですか? (y/n/修正指示)
   ```
3. ユーザー承認後、Queueに追加

## タスク記法

```markdown
- [親タスク] repo名: タスク内容
- repo名: タスク内容
```

## Queue追加後

空きworkerがあれば、coordinatorが自動でタスクを開始する。

## リポジトリ一覧の取得

```bash
# カレントディレクトリ内のgitリポジトリを列挙
for dir in */; do
  if [ -d "$dir/.git" ]; then
    echo "${dir%/}"
  fi
done
```
