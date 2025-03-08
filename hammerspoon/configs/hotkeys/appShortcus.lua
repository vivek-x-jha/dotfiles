local ctrl_alt_cmd = { 'ctrl', 'alt', 'cmd' }
local toggle = require('utils').toggle_app

local appShortcuts = {
  {
    key = 'w',
    name = 'WezTerm',
    desc = 'Toggle WezTerm',
    mods = ctrl_alt_cmd,
    command = function() toggle 'WezTerm' end,
  },
  {
    key = 'a',
    name = 'Arc',
    desc = 'Toggle Arc Browser',
    mods = ctrl_alt_cmd,
    command = function() toggle 'Arc' end,
  },
  {
    key = 'm',
    name = 'Mimestream',
    desc = 'Toggle Mimestream',
    mods = ctrl_alt_cmd,
    command = function() toggle 'Mimestream' end,
  },
  {
    key = 'p',
    name = 'Photos',
    desc = 'Toggle Photos',
    mods = ctrl_alt_cmd,
    command = function() toggle 'Photos' end,
  },
}

return appShortcuts
