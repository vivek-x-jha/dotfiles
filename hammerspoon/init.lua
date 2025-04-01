-- https://www.hammerspoon.org/docs/
package.path = table.concat { hs.configdir, '/configs/?.lua;', package.path }

-- set hammerspoon theme
require('utils').setConsole 'configs.options'

-- load hotkeys
require('utils').bindHotkeys 'configs.hotkeys'
