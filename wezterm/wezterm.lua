local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Remove traffic light buttons
config.window_decorations = "RESIZE"

-- Colorscheme
config.color_scheme = 'Catppuccin Mocha'
config.font = wezterm.font('ComicShannsMono Nerd Font', { weight = 'Regular', italic = false })
config.font_size = 16

return config
