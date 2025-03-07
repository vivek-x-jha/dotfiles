-- https://wezfurlong.org/wezterm/

-- Create config table
local wezterm = require 'wezterm'
local config = wezterm.config_builder() or {}

-- Set terminal colors
config.color_scheme = 'Sourdiesel'

-- Set font opts
config.font_size = 15

config.font = wezterm.font_with_fallback {
  { family = 'JetBrainsMono Nerd Font', weight = 'ExtraLight' }, -- Primary font
  'Menlo', -- macOS fallback
  'DejaVu Sans Mono', -- Linux fallback
  'Consolas', -- Windows fallback
}

-- Set cursor opts
config.cursor_blink_rate = 300
config.cursor_thickness = 0.25
config.default_cursor_style = 'BlinkingBlock'

-- Set window opts
config.macos_window_background_blur = wezterm.target_triple:match 'apple%-darwin' and 60 -- Blur only available on macOS
config.window_background_opacity = 0.9
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'RESIZE'

config.window_frame = {
  border_left_width = 2,
  border_right_width = 2,
  border_bottom_height = 2,
  border_top_height = 2,
  border_left_color = '#5c617d',
  border_right_color = '#5c617d',
  border_bottom_color = '#5c617d',
  border_top_color = '#5c617d',
}

config.window_padding = {
  left = 20,
  right = 15,
  top = 15,
  bottom = 12,
}

-- Disable title bar
config.enable_tab_bar = false

-- Command Palette: activate with <Ctrl + Shift + p>
config.command_palette_fg_color = '#cdd6f4'
config.command_palette_bg_color = '#212030'
config.command_palette_font_size = 16
config.command_palette_rows = 20

-- Style Tweaks
config.bold_brightens_ansi_colors = false

return config
