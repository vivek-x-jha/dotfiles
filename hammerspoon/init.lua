-- https://www.hammerspoon.org/docs/
package.path = table.concat { hs.configdir, '/lua/?.lua;', package.path }

local keymaps = require 'configs.mappings'
local options = require 'configs.options'

-- Set console theme
for setting, opts in pairs(options) do
  if setting == 'toolbar' and not opts then
    hs.console.toolbar(nil)
  else
    hs.console[setting](opts)
  end
end

-- Set hotkeys
for _, spec in ipairs(keymaps) do
  hs.hotkey.bind(spec.mods, spec.key, spec.desc, spec.command)
end
