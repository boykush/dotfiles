---
name: start-workspace-multi
description: 複数リポジトリを管理するマルチエージェント作業環境を構築する
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash(echo *), Bash(tmux *), Bash(git worktree *)
---

# /start-workspace-multi

複数リポジトリを含む親ディレクトリでマルチエージェント作業環境を構築する。

## 引数

$ARGUMENTS: WIP制限 (デフォルト: 4) - 同時実行可能なタスク数

## 前提

- tmuxセッション内で実行されていること
- カレントディレクトリが複数リポジトリを含む親ディレクトリであること

## レイアウト

### coordinatorウィンドウ
```
+-------------------+-------------------+
| coordinator       | .tasks.md監視     |
| (pane 0)          | (pane 1)          |
+-------------------+-------------------+
```

### workersウィンドウ
```
+-------------------+-------------------+
| worker-0          | worker-1          |
+-------------------+-------------------+
| worker-2          | worker-3          |
+-------------------+-------------------+
```

## 環境構築手順

1. 引数からWIP制限を取得:
   ```bash
   WIP_LIMIT="${ARGUMENTS:-4}"
   ```

2. tmuxセッション内か確認:
   ```bash
   if [ -z "$TMUX" ]; then
     echo "ERROR: tmux内で実行してください"
     exit 1
   fi
   ```

3. .tasks.md を初期化 (存在しなければ):
   ```markdown
   # Tasks

   WIP: {WIP_LIMIT}

   ## Queue

   ## In Progress

   ## In Review

   ## Done
   ```

4. 現在のウィンドウ名を coordinator に変更:
   ```bash
   tmux rename-window coordinator
   ```

5. ウィンドウを分割してtasks監視ペイン追加:
   ```bash
   tmux split-window -d -h -p 50
   tmux send-keys -t '{right}' "watchexec -w .tasks.md -c -- cat .tasks.md" Enter
   ```

6. workersウィンドウを作成 (2x2グリッド):
   ```bash
   tmux new-window -d -n workers -c "$(pwd)"
   tmux split-window -t workers -h -c "$(pwd)"
   tmux split-window -t workers.0 -v -c "$(pwd)"
   tmux split-window -t workers.2 -v -c "$(pwd)"
   ```

7. 完了メッセージを表示

## タスク開始トリガー (イベント駆動)

- `/add-task` 実行時: WIP制限未満なら即座に開始
- worker完了通知受信時: 次のQueueを自動処理
- ユーザー明示指示: 「次のタスクやって」で処理

## タスク開始処理

1. WIP制限チェック:
   - .tasks.mdからWIP制限値を取得
   - In Progressの件数 < WIP制限 であること
2. Queueから先頭タスクを取得
3. タスクからリポジトリ名を抽出
4. 空きworkerペインを特定 (workers.0〜3)
5. worktree作成:
   ```bash
   cd {repo}
   git worktree add wt/{task-id} -b {task-id}
   ```
6. workerにタスク送信:
   ```bash
   # 既存のclaudeセッションを終了 (Ctrl+C)
   tmux send-keys -t workers.{N} C-c
   # 新しいタスクを開始
   tmux send-keys -t workers.{N} "cd $(pwd)/{repo}/wt/{task-id}" Enter
   tmux send-keys -t workers.{N} "claude --dangerously-skip-permissions /start-worker-task '{タスク内容}'" Enter
   ```
7. .tasks.md更新: Queue → In Progress (worker-N, wt/{task-id})

## タスク完了通知の処理

workerから「タスク完了: {repo} {wt} PR: {url}」の通知を受けたら:

1. workerがsend-keysで通知を送信 (2ステップ: メッセージ → Enter)
2. coordinatorのペイン (coordinator.0) に通知メッセージが表示される
3. coordinatorは.tasks.mdを確認:
   - workerが既にIn Progress → In Reviewへ更新済み
   - PRリンクも追記済み
4. Queueに次のタスクがあれば自動開始

**Note**: workerが/finish-task実行時に.tasks.mdを更新するため、coordinatorは確認のみ
