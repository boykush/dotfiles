#!/bin/bash

# Claude Code ステータスライン
# 表示内容: モデル名 / 5h枠の使用率(バーンレート色分け) / リセットまでの残り時間 / コンテキスト使用率
# settings.json の statusLine.command から呼ばれ、標準入力でセッション情報(JSON)を受け取る

input=$(cat)
now=$(date +%s)

# セッションJSONから必要な値をTSVで一括取得
IFS=$'\t' read -r model ctx has5h used resets < <(
  echo "$input" | jq -r '[
    .model.display_name,
    (.context_window.used_percentage // 0 | floor),
    (if .rate_limits.five_hour then 1 else 0 end),
    (.rate_limits.five_hour.used_percentage // 0 | floor),
    (.rate_limits.five_hour.resets_at // 0)
  ] | @tsv'
)

CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; DIM='\033[2m'; R='\033[0m'

# 使用率のしきい値で色を返す (90%以上=赤 / 70%以上=黄 / それ未満=緑)
threshold_color() {
  if [ "$1" -ge 90 ]; then printf '%s' "$RED"
  elif [ "$1" -ge 70 ]; then printf '%s' "$YELLOW"
  else printf '%s' "$GREEN"; fi
}

out="${CYAN}[${model}]${R} "

# Max/Proプラン (rate_limits.five_hour あり) のときだけ 5h 枠を表示
if [ "$has5h" = "1" ]; then
  rem=$(( resets - now )); [ "$rem" -lt 0 ] && rem=0
  # 5h枠(18000秒)のうち経過した割合。使用率と比較してバーンレート(消費ペース)を判定する
  elapsed=$(( (18000 - rem) * 100 / 18000 ))
  [ "$elapsed" -lt 0 ] && elapsed=0; [ "$elapsed" -gt 100 ] && elapsed=100

  h=$(( rem / 3600 )); m=$(( (rem % 3600) / 60 ))
  if [ "$h" -gt 0 ]; then left="${h}h${m}m"; else left="${m}m"; fi

  # 使用ペースで色分け: 経過%以内=緑 / 少し超過=黄 / 大幅超過(1.5倍)か90%以上=赤
  burn=$GREEN
  [ "$used" -gt "$elapsed" ] && burn=$YELLOW
  { [ "$used" -gt $(( elapsed * 3 / 2 )) ] || [ "$used" -ge 90 ]; } && burn=$RED

  out="${out}${burn}5h ${used}%${R} ${DIM}${left} left${R} ${DIM}|${R} "
fi

out="${out}$(threshold_color "$ctx")ctx ${ctx}%${R}"

printf '%b\n' "$out"
