# mise - 全シェル種別で aqua/cargo 管理のバイナリを PATH に通す。
# Codex.app の non-login interactive shell など .zprofile が読まれない
# 環境からも starship/zoxide を解決できるようここに置く。
eval "$(/opt/homebrew/bin/mise activate zsh)"

# zoxide - smarter cd command
eval "$(zoxide init zsh)"

# starship - cross-shell prompt
eval "$(starship init zsh)"
