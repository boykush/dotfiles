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

# exa
if [[ $(command -v eza) ]]; then
  alias e='eza --icons'
  alias ls=e
  alias ea='eza -a --icons'
  alias la=ea
  alias ee='eza -aal --icons -hl --git'
  alias ll=ee
  alias et='eza -T -L 3 -a -I "node_modules|.git|.cache" --icons'
  alias lt=et
  alias eta='eza -T -a -I "node_modules|.git|.cache" --color=always --icons | less -r'
  alias lta=eta
fi

# bat
export BAT_THEME="Nord"

# zoxide
eval "$(zoxide init zsh)"

# starship
eval "$(starship init zsh)"

# nodenv
eval "$(nodenv init -)"

# java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-22.jdk/Contents/Home

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fbr - checkout git branch (including remote branches)
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
