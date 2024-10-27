-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- https://wezfurlong.org/wezterm/

local wezterm = require 'wezterm'
local helpers = require 'helpers'
local config = wezterm.config_builder()

-- Window UI
helpers.apply_to_config(config)

-- Colorscheme
config.colors = require 'utils.colorscheme'

-- Cursor
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 300
config.cursor_thickness = 0.25

-- Font
config.font = wezterm.font('ComicShannsMono Nerd Font', { weight = 'Regular', italic = false })
config.font_size = 16

return config
