local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Window UI

-- Disable traffic light buttons
config.window_decorations = "RESIZE"

-- Disable tab bar
config.enable_tab_bar = false

-- Transparency (0.0 is fully transparent, 1.0 is fully opaque)
config.window_background_opacity = 0.97

if wezterm.target_triple == 'x86_64-apple-darwin' or wezterm.target_triple == 'aarch64-apple-darwin' then
  config.macos_window_background_blur = 25
end

-- Set Padding
config.window_padding = {
  left   = 25,
  right  = 25,
  top    = 20,
  bottom = 20
}

-- Colorscheme

config.colors = {
  foreground = "#f4f3f2",
  background = "#212030",

  cursor_bg = "#f4f3f2",
  cursor_border = "#f4f3f2",
  cursor_fg = "#313244",
  selection_bg = "#5c617d",
  selection_fg = "#f4f3f2",

  ansi = {
    "#cccccc", -- black
    "#ffc7c7", -- red
    "#ceffc9", -- green
    "#fdf7cd", -- yellow
    "#c4effa", -- blue
    "#eccef0", -- magenta
    "#8ae7c5", -- cyan
    "#f4f3f2", -- white
  },

  brights = {
    "#5c617d", -- bright black
    "#f096b7", -- bright red
    "#d2fd9d", -- bright green
    "#f3b175", -- bright yellow
    "#80d7fe", -- bright blue
    "#c9ccfb", -- bright magenta
    "#47e7b1", -- bright cyan
    "#ffffff", -- bright white
  },
}

-- Set Font
config.font = wezterm.font(
  'ComicShannsMono Nerd Font',
  {
    weight = 'Regular',
    italic = false
  }
)
config.font_size = 16

return config
