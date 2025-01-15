-- https://www.hammerspoon.org/docs/
package.path = table.concat { hs.configdir, '/configs/?.lua;', package.path }

local options = require 'options'
local utl = require 'utils'

-- Set console theme
for setting, opts in pairs(options) do
  if setting == 'toolbar' and not opts then
    hs.console.toolbar(nil)
  else
    hs.console[setting](opts)
  end
end

-- Set hotkeys
utl.bind_hotkeys '/configs/hotkeys'
