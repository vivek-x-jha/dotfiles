-- https://wezfurlong.org/wezterm/

local wez = require 'wezterm'

return vim.tbl_deep_extend('force', wez.config_builder() or {}, {
  -- Cross-platform settings
  color_scheme = 'Sourdiesel',
  font = wez.font_with_fallback {
    { family = 'JetBrainsMono Nerd Font', weight = 'ExtraLight' }, -- Primary font
    'Menlo', -- macOS fallback
    'DejaVu Sans Mono', -- Linux fallback
    'Consolas', -- Windows fallback
  },
  font_size = 15,
  cursor_blink_rate = 300,
  cursor_thickness = 0.25,
  default_cursor_style = 'BlinkingBlock',
  window_background_opacity = 0.9,
  window_close_confirmation = 'NeverPrompt',
  window_decorations = 'RESIZE',
  window_padding = {
    left = 20,
    right = 15,
    top = 15,
    bottom = 12,
  },
  enable_tab_bar = false,

  -- Command Palette: activate with <Ctrl + Shift + p>
  command_palette_fg_color = '#cdd6f4',
  command_palette_bg_color = '#212030',
  command_palette_font_size = 16,
  command_palette_rows = 20,

  -- Blur only available on MacOS
  macos_window_background_blur = (
    wez.target_triple == 'x86_64-apple-darwin' or wez.target_triple == 'aarch64-apple-darwin'
  )
      and 50
    or nil,

  -- Style Tweaks
  bold_brightens_ansi_colors = 'BrightOnly',
})
