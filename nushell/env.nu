$env.PATH = ($env.PATH
  | split row (char esep)
  | prepend '/opt/homebrew/bin'
)
$env.EDITOR = 'nvim'
$env.LANG = 'ja_JP.UTF-8'
$env.BAT_THEME = 'Nord'

starship init nu | save -f ~/.cache/starship.nu
zoxide init nushell | save -f ~/.cache/zoxide.nu

