-- https://www.hammerspoon.org/docs/
package.path = table.concat { hs.configdir, '/configs/?.lua;', package.path }

-- set hammerspoon theme
require('utils').set_console 'configs.options'

-- load hotkeys
HYPER = { 'ctrl', 'alt', 'cmd' }
CTRL_ALT = { 'ctrl', 'alt' }

require('utils').bind_hotkeys 'configs.hotkeys'
