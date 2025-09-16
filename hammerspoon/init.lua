-- https://www.hammerspoon.org/docs/
package.path = table.concat { hs.configdir, '/lua/?.lua;', package.path }

-- set hammerspoon theme
require('utils').setConsole 'lua.options'

-- load hotkeys
require('utils').bindHotkeys 'lua.hotkeys'
