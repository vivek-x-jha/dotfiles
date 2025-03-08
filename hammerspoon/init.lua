-- https://www.hammerspoon.org/docs/
HYPER = { 'ctrl', 'alt', 'cmd' }
CTRL_ALT = { 'ctrl', 'alt' }

package.path = table.concat { hs.configdir, '/configs/?.lua;', package.path }

-- set hammerspoon theme
require('utils').set_console 'configs.options'

-- load hotkeys
require('utils').bind_hotkeys 'configs.hotkeys'
