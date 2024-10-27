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

config.colors = require 'colors.sourdiesel'

config.cursor_blink_rate = 300
config.cursor_thickness = 0.25
config.default_cursor_style = "BlinkingBlock"

config.enable_tab_bar = false

config.font = wezterm.font('ComicShannsMono Nerd Font', { weight = 'Regular', italic = false })
config.font_size = 16

config.macos_window_background_blur = 15
config.window_background_opacity = 0.8

config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = "RESIZE"
config.window_padding = {
  left   = 25,
  right  = 25,
  top    = 20,
  bottom = 20
}

return config
