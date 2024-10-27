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

config.bold_brightens_ansi_colors = 'BrightOnly'
config.color_scheme = 'Sourdiesel'

config.command_palette_fg_color = '#cdd6f4'
config.command_palette_bg_color = '#212030'
config.command_palette_font_size = 16
config.command_palette_rows = 20

config.cursor_blink_rate = 300
config.cursor_thickness = 0.25
config.default_cursor_style = 'BlinkingBlock'

config.enable_tab_bar = false

config.font = wezterm.font('ComicShannsMono Nerd Font', { weight = 'Regular', italic = false })
config.font_size = 16

config.macos_window_background_blur = 50
config.window_background_opacity = 0.9

config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'RESIZE'
config.window_padding = {
  left   = 25,
  right  = 25,
  top    = 20,
  bottom = 20
}

return config
