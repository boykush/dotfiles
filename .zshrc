# mise - 全シェル種別で aqua 管理のバイナリを PATH に通す。
# Codex.app の non-login interactive shell など .zprofile が読まれない
# 環境からも starship/zoxide を解決できるようここに置く。
# mise 本体は brew をやめ bin/mise（bootstrap ラッパー）へ移行。bare `mise` が
# ~/dotfiles/bin/mise に解決されるよう .zshenv で PATH を通してある。
eval "$(mise activate zsh)"

# zoxide - smarter cd command
eval "$(zoxide init zsh)"

# starship - cross-shell prompt
eval "$(starship init zsh)"
