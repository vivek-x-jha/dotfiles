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

-- Delay clearing the console slightly to remove the initialization messages
hs.timer.doAfter(0.2, function()
  hs.console.clearConsole()
  print '-- Lazy extension loading enabled'
  print '-- Loading ~/.hammerspoon/init.lua'
  print '-- Loading extension: console'
  print '-- Loading extension: timer'
  print '-- Loading extension: hotkey'
  print '-- hotkey: Enabled hotkey ⌘⌃⌥R: Reload Config!'
  print '-- hotkey: Enabled hotkey ⌘⌃⌥W: Arrange Main Workspace'
end)

-- Set hotkeys
for _, spec in ipairs(keymaps) do
  hs.hotkey.bind(spec.mods, spec.key, spec.desc, spec.command)
end
