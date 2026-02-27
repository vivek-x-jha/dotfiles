-- Main palette
local thm = {
  -- Base16
  black = '#cccccc',
  red = '#ffc7c7',
  green = '#ceffc9',
  yellow = '#fdf7cd',
  blue = '#c4effa',
  magenta = '#eccef0',
  cyan = '#8ae7c5',
  white = '#f4f3f2',
  brightblack = '#5c617d',
  brightred = '#f096b7',
  brightgreen = '#d2fd9d',
  brightyellow = '#f3b175',
  brightblue = '#80d7fe',
  brightmagenta = '#c9ccfb',
  brightcyan = '#47e7b1',
  brightwhite = '#ffffff',

  -- Other
  dark = '#1b1c28',
  grey = '#313244',

  -- App specific
  nvim_bg = 'NONE',
  wezterm_bg = '#212030',
}

-- https://wezterm.org/config/files.html?h=config
local wezterm = require 'wezterm'
local config = wezterm.config_builder() or {}

config.default_prog = wezterm.target_triple:match 'windows' and {
  'wsl',
  '--distribution',
  'Ubuntu',
  '--cd',
  '/home/aflex',
}

-- https://wezterm.org/config/appearance.html#defining-your-own-colors
config.bold_brightens_ansi_colors = false
config.colors = {
  ansi = {
    thm.black,
    thm.red,
    thm.green,
    thm.yellow,
    thm.blue,
    thm.magenta,
    thm.cyan,
    thm.white,
  },

  brights = {
    thm.brightblack,
    thm.brightred,
    thm.brightgreen,
    thm.brightyellow,
    thm.brightblue,
    thm.brightmagenta,
    thm.brightcyan,
    thm.brightwhite,
  },

  background = thm.wezterm_bg,
  compose_cursor = thm.brightred,
  cursor_bg = thm.brightmagenta,
  cursor_border = thm.white,
  cursor_fg = thm.grey,
  foreground = thm.white,
  selection_bg = thm.brightblack,
  selection_fg = thm.white,
  split = thm.brightblack,
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
config.window_frame = {
  border_left_width = 1,
  border_right_width = 1,
  border_bottom_height = 1,
  border_top_height = 1,

  border_left_color = config.colors.brights[1],
  border_right_color = config.colors.brights[1],
  border_bottom_color = config.colors.brights[1],
  border_top_color = config.colors.brights[1],
}

-- https://wezterm.org/config/lua/config/window_padding.html?h=window_padd
config.window_padding = {
  left = 20,
  right = 15,
  top = 15,
  bottom = 12,
}

return config
