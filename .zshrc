# common
export XDG_CONFIG_HOME=~/.config
export LANG=ja_JP.UTF-8
export EDITOR=nvim

# alias
alias vi='nvim'

# exa
if [[ $(command -v exa) ]]; then
  alias e='exa --icons'
  alias ls=e
  alias ea='exa -a --icons'
  alias la=ea
  alias ee='exa -aal --icons -hl --git'
  alias ll=ee
  alias et='exa -T -L 3 -a -I "node_modules|.git|.cache" --icons'
  alias lt=et
  alias eta='exa -T -a -I "node_modules|.git|.cache" --color=always --icons | less -r'
  alias lta=eta
fi

# bat
export BAT_THEME="Nord"

# zoxide
eval "$(zoxide init zsh)"

# starship
eval "$(starship init zsh)"

# java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home

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
