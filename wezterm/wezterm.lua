-- https://wezfurlong.org/wezterm/

local wezterm = require 'wezterm'

-- Configuration
local cnf = {}
if wezterm.config_builder then
  cnf = wezterm.config_builder()
end

-- Cross-platform settings
cnf.color_scheme = 'Sourdiesel'
cnf.font = wezterm.font_with_fallback {
  { family = 'JetBrainsMono Nerd Font', weight = 'ExtraLight' }, -- Primary font
  'Menlo', -- macOS fallback
  'DejaVu Sans Mono', -- Linux fallback
  'Consolas', -- Windows fallback
}
cnf.font_size = 15
cnf.cursor_blink_rate = 300
cnf.cursor_thickness = 0.25
cnf.default_cursor_style = 'BlinkingBlock'
cnf.window_background_opacity = 0.9
cnf.window_decorations = 'RESIZE'
cnf.window_padding = {
  left = 25,
  right = 25,
  top = 20,
  bottom = 20,
}
cnf.enable_tab_bar = false

-- Command Palette: activate with <Ctrl + Shift + p>
cnf.command_palette_fg_color = '#cdd6f4'
cnf.command_palette_bg_color = '#212030'
cnf.command_palette_font_size = 16
cnf.command_palette_rows = 20

-- Blur only available on MacOS
if wezterm.target_triple == 'x86_64-apple-darwin' or wezterm.target_triple == 'aarch64-apple-darwin' then
  cnf.macos_window_background_blur = 50
end

-- Style Tweaks
cnf.bold_brightens_ansi_colors = 'BrightOnly'

return cnf
