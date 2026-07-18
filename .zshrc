# mise - aqua 管理のバイナリを PATH に通し、対話シェルの環境を揃える。
# Codex.app の non-login interactive shell など login 用初期化を読まない環境からも
# starship/zoxide を解決できるよう、login ではなくここ（.zshrc）に置く。
# bare `mise` は bin/mise（bootstrap ラッパー）に解決される（PATH は .zshenv で通す）。
eval "$(mise activate zsh)"

# zoxide - smarter cd command
eval "$(zoxide init zsh)"

# starship - cross-shell prompt
eval "$(starship init zsh)"
