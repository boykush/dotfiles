#!/bin/bash

# Claude Code の SessionStart hook
# settings.json の hooks.SessionStart から呼ばれ、標準入力でセッション情報(JSON)を受け取る

input=$(cat)

# --project-config-root 付きで起動されたセッションでは、CLAUDE_PROJECT_DIR が設定の読み元の checkout を指す
cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0
root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
config=(.mcp.json .claude)

# stdout は JSON の返り値として読まれるので、pull の出力は捨てる
before=$(git rev-parse -q --verify HEAD)
if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
  git pull --ff-only --quiet >/dev/null 2>&1
fi
after=$(git rev-parse -q --verify HEAD)

msgs=()

# CLI は設定を hook より先に読むので、pull で変わった設定は Claude がファイルを直接読んで補う
if [ -n "$before" ] && [ "$before" != "$after" ] && ! git diff --quiet "$before" "$after" -- "${config[@]}"; then
  changed=$(git diff --name-only "$before" "$after" -- "${config[@]}" | paste -sd ' ' -)
  msgs+=("${root} の .mcp.json / .claude を pull で更新しました（${changed}）。起動時の設定には入っていないので、更新された skill などは必要になったらファイルを直接読んで使ってください。")
fi

# デスクトップアプリは worktree のセッションに、.mcp.json と .claude を元の checkout の作業ツリーから
# 読ませる（--project-config-root）。元の checkout が別ブランチや古いままだと MCP サーバーや skill が
# 黙って欠けるので、既定ブランチとのずれを知らせる
session_root=$(git -C "$(jq -r '.cwd // empty' <<<"$input")" rev-parse --show-toplevel 2>/dev/null)
if [ -n "$session_root" ] && [ "$session_root" != "$root" ]; then
  base=$(git symbolic-ref -q --short refs/remotes/origin/HEAD || echo origin/main)
  if git rev-parse -q --verify "${base}^{commit}" >/dev/null && ! git diff --quiet "$base" -- "${config[@]}"; then
    drift=""
    git diff --quiet "$base" -- .mcp.json || drift=".mcp.json"
    n=$(git diff --name-only "$base" -- .claude | wc -l | tr -d ' ')
    [ "$n" -gt 0 ] && drift="${drift:+$drift, }.claude 配下 ${n} 件"
    branch=$(git branch --show-current)
    dirty=$(git status --porcelain | wc -l | tr -d ' ')
    if [ "$branch" = "${base#origin/}" ]; then
      fix="${root} の未コミットの変更や ${base} から分岐したコミットの扱いをユーザーに確認し、${base} に揃えてください。"
    else
      fix="${root} を ${base#origin/} に切り替えて pull してください（未コミットの変更があれば先にユーザーに確認）。"
    fi
    fix="${fix} 揃えた後、ずれていた skill などはファイルを直接読んで使い、セッションの開き直しは求めないでください。"
    msgs+=("$(printf '%s\n' \
      "このセッションは .mcp.json と .claude（skills など）を ${root} から読んでいますが、その作業ツリーが ${base} とずれています。" \
      "  ブランチ: ${branch:-detached HEAD} / 未コミット: ${dirty} 件 / ずれ: ${drift}" \
      "$fix")")
  fi
fi

[ ${#msgs[@]} -eq 0 ] && exit 0

# systemMessage はデスクトップアプリで表示されることを確認できていないので、Claude からも伝えさせる
msg=$(printf '%s\n' "${msgs[@]}")
jq -n --arg msg "$msg" '{
  systemMessage: $msg,
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: ("SessionStart hook からの警告です。最初の返答で、ユーザーの依頼に入る前にその場で直し、何をしたかを短く伝えてください。\n" + $msg)
  }
}'
