local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'nord'

config.enable_tab_bar = false

config.window_padding = {
  left = 16,
  right = 16,
  top = 8,
  bottom = 8,
}

config.font = wezterm.font 'Hack Nerd Font Mono'

return config
