# common
export XDG_CONFIG_HOME=~/.config
export LANG=ja_JP.UTF-8
export EDITOR=nvim

# alias
alias vi='nvim'

# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# for nushell
if [[ $- == *i* ]]; then
  # インタラクティブシェルの場合のみnushellを起動
  exec nu
fi

