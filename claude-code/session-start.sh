#!/bin/bash

# Claude Code の SessionStart hook。設定の読み元の checkout を既定ブランチの最新に強制で揃える
# 作業は worktree でしかしないので、元の checkout の未コミットの変更や独自のコミットは捨ててよい

cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0

# worktree 自体が読み元のときは作業中のブランチなので触らない
[ "$(git rev-parse --git-dir 2>/dev/null)" = "$(git rev-parse --git-common-dir 2>/dev/null)" ] || exit 0

# stdout はセッションの文脈に入るので、何も出さない
exec >/dev/null 2>&1
git fetch --quiet origin || exit 0
base=$(git symbolic-ref -q --short refs/remotes/origin/HEAD || echo origin/main)
git checkout --quiet --force -B "${base#origin/}" "$base"
exit 0
