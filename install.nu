# Install
## Install by brew
let brew_packages = [
  # Formulae
  zellij
  fzf
  ripgrep
  eza
  zoxide
  git-delta
  gitui
  bat
  procs
  starship
  zola
  neovim
  nodenv
  sbt
  # Casks
  arc
  wezterm
  font-hack-nerd-font
  visual-studio-code
  intellij-idea-ce
  zulu
  alfred
]
let brew_exists = brew list | lines | split row (char esep)

$brew_packages
| where { |package| $package not-in $brew_exists }
| each { |package| brew install $package }
