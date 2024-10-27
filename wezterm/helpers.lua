-- I am helpers.lua and I should live in ~/.config/wezterm/helpers.lua

local wezterm = require 'wezterm'

-- This is the module table that we will export
local module = {}

-- This function is private to this module and is not visible
-- outside.
local function private_helper()
  wezterm.log_error 'hello!'
end

-- define a function in the module table.
-- Only functions defined in `module` will be exported to
-- code that imports this module.
-- The suggested convention for making modules that update
-- the config is for them to export an `apply_to_config`
-- function that accepts the config object, like this:
function module.apply_to_config(config)
  -- private_helper()

  -- Title Bar
  config.enable_tab_bar = false
  config.window_close_confirmation = 'NeverPrompt'
  config.window_decorations = "RESIZE"

  -- Transparency
  config.window_background_opacity = 0.97

  -- Blur
  config.macos_window_background_blur = 25

  -- Padding
  config.window_padding = {
    left   = 25,
    right  = 25,
    top    = 20,
    bottom = 20
  }
end

-- return our module table
return module
