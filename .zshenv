# bare `mise` を bin/mise（bootstrap ラッパー）に解決させるため、全シェル種別で
# ~/dotfiles/bin を PATH に通す。.zshenv は全 zsh 起動で読まれるので、非対話エージェント
# （下の mise env 取り込み）からも解決できる。重複防止のため既に含まれていれば追加しない。
case ":$PATH:" in
  *":$HOME/dotfiles/bin:"*) ;;
  *) export PATH="$HOME/dotfiles/bin:$PATH" ;;
esac

# 非対話シェル（Claude Code / Codex CLI 等のエージェント）は .zshrc(=mise activate)を
# 読まないため mise [env] が丸ごと未適用になる（GH_TOKEN/EDITOR/LANG 等が空）。結果
# gh(PR作成など)が未認証になる。非対話のときだけ mise の env を取り込み揃える。
# 対話シェル（通常端末 / Codex.app 等）は .zshrc で mise activate されるので素通り。
if [[ ! -o interactive ]] && command -v mise >/dev/null 2>&1; then
  eval "$(mise env -s zsh 2>/dev/null)"
fi
