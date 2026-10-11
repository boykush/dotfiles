#!/bin/bash

# Claude Code の WorktreeCreate hook。標準の worktree 作成を置き換え、origin の既定ブランチの最新から切る
# 失敗するとセッションを開けなくなるので、fetch できなくても手元の参照から切ってパスを返す

input=$(cat)
name=$(jq -r '.name // empty' <<<"$input")
[ -n "$name" ] || exit 1
cd "$(jq -r '.cwd // "."' <<<"$input")" || exit 1

# stdout は worktree のパスだけを返すので、git の出力は stderr へ流す
exec 3>&1 >&2

root=$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)") || exit 1
git fetch --quiet origin
base=$(git symbolic-ref -q --short refs/remotes/origin/HEAD || echo origin/main)

if [ "$(git rev-parse --show-toplevel)" != "$root" ] || ! git rev-parse -q --verify "${base}^{commit}" >/dev/null; then
  # worktree の中から切るとき（サブエージェントなど）は、作業中のコミットを起点にする
  base=HEAD
else
  # デスクトップアプリは worktree のセッションにも .mcp.json と .claude をこの checkout から読ませる
  # 作業は worktree でしかしないので、未コミットの変更や独自のコミットは捨てて揃える
  git checkout --quiet --force -B "${base#origin/}" "$base"
fi

path="$root/.claude/worktrees/$name"
# hook で作った worktree にはアプリがブランチを切らないので、ここで切っておく
[ -d "$path" ] || git worktree add --quiet --no-track -b "claude/$name" "$path" "$base" || exit 1
echo "$path" >&3
