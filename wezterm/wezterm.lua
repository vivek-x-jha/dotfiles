--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- https://wezfurlong.org/wezterm/

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Title Bar
config.enable_tab_bar = false
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = "RESIZE"

-- Transparency & Blur
config.window_background_opacity = 0.97
config.macos_window_background_blur = 25

-- Padding
config.window_padding = {
  left   = 25,
  right  = 25,
  top    = 20,
  bottom = 20
}

-- Colorscheme
config.colors = require 'colors.sourdiesel'

-- Cursor
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 300
config.cursor_thickness = 0.25

-- Font
config.font = wezterm.font('ComicShannsMono Nerd Font', { weight = 'Regular', italic = false })
config.font_size = 16

return config
