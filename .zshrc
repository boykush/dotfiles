# alias
alias vi='nvim'

# brew
eval $(/opt/homebrew/bin/brew shellenv)

# mise
eval "$(mise activate zsh)"

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

# zoxide
eval "$(zoxide init zsh)"

# starship
eval "$(starship init zsh)"

# fbr - checkout git branch (using mise task)
alias fbr='mise run fbr'
