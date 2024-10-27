local config = require('wezterm').config_builder()

-- Title Bar
config.enable_tab_bar = false
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = "RESIZE"

-- Transparency
config.window_background_opacity = 0.97

-- Blur
config.macos_window_background_blur = 25

-- Padding
config.window_padding = {
  left   = 25,
  right  = 25,
  top    = 20,
  bottom = 20
}

return config
