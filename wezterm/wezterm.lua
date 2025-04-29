-- https://wezterm.org/config/files.html?h=config
local wezterm = require 'wezterm'
local config = wezterm.config_builder() or {}

-- https://wezterm.org/config/appearance.html#defining-your-own-colors
config.bold_brightens_ansi_colors = false
config.colors = {
  ansi = { '#cccccc', '#ffc7c7', '#ceffc9', '#fdf7cd', '#c4effa', '#eccef0', '#8ae7c5', '#f4f3f2' },
  background = '#212030',
  brights = { '#5c617d', '#f096b7', '#d2fd9d', '#f3b175', '#80d7fe', '#c9ccfb', '#47e7b1', '#ffffff' },
  compose_cursor = '#f2cdcd',
  cursor_bg = '#cdd6f4',
  cursor_border = '#f4f3f2',
  cursor_fg = '#313244',
  foreground = '#f4f3f2',
  selection_bg = '#5c617d',
  selection_fg = '#f4f3f2',
  split = '#5c617d',
}

-- Command Palette: activate with <Ctrl + Shift + p>
config.command_palette_fg_color = config.colors.cursor_bg
config.command_palette_bg_color = config.colors.background
config.command_palette_font_size = 16
config.command_palette_rows = 20

-- https://wezterm.org/config/fonts.html?h=fonts
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
config.enable_tab_bar = false

config.macos_window_background_blur = wezterm.target_triple:match 'apple%-darwin' and 60

config.window_background_opacity = 0.9

config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'RESIZE'

-- https://wezterm.org/config/lua/config/window_frame.html?h=window_frame
local border_thickness = 1
local brightblack = config.colors.brights[1]

config.window_frame = {
  border_left_width = border_thickness,
  border_right_width = border_thickness,
  border_bottom_height = border_thickness,
  border_top_height = border_thickness,

  border_left_color = brightblack,
  border_right_color = brightblack,
  border_bottom_color = brightblack,
  border_top_color = brightblack,
}

-- https://wezterm.org/config/lua/config/window_padding.html?h=window_padd
config.window_padding = {
  left = 20,
  right = 15,
  top = 15,
  bottom = 12,
}

return config
