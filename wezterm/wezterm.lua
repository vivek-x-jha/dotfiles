-- https://wezfurlong.org/wezterm/

local wezterm = require 'wezterm'

-- Configuration
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Cross-platform settings
config.color_scheme = 'Sourdiesel'
config.font = wezterm.font_with_fallback {
  { family = 'JetBrainsMono Nerd Font', weight = 'ExtraLight' }, -- Primary font
  'Menlo', -- macOS fallback
  'DejaVu Sans Mono', -- Linux fallback
  'Consolas', -- Windows fallback
}
config.font_size = 15
config.cursor_blink_rate = 300
config.cursor_thickness = 0.25
config.default_cursor_style = 'BlinkingBlock'
config.window_background_opacity = 0.9
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'RESIZE'
config.window_padding = {
  left = 25,
  right = 25,
  top = 20,
  bottom = 20,
}
config.enable_tab_bar = false

-- Command Palette: activate with <Ctrl + Shift + p>
config.command_palette_fg_color = '#cdd6f4'
config.command_palette_bg_color = '#212030'
config.command_palette_font_size = 16
config.command_palette_rows = 20

-- Blur only available on MacOS
if wezterm.target_triple == 'x86_64-apple-darwin' or wezterm.target_triple == 'aarch64-apple-darwin' then
  config.macos_window_background_blur = 50
end

-- Style Tweaks
config.bold_brightens_ansi_colors = 'BrightOnly'

return config
