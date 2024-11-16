# Install
## Install by brew
let brew_packages = [
  # Formulae
  zellij
  fzf
  ripgrep
  zoxide
  git-delta
  gitui
  bat
  starship
  zola
  neovim
  # Casks
  arc
  wezterm
  font-hack-nerd-font
  visual-studio-code
  alfred
]
let brew_exists = brew list | lines | split row (char esep)

$brew_packages
| where { |package| $package not-in $brew_exists }
| each { |package| brew install $package }
