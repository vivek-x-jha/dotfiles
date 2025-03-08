local ctrl_alt_cmd = { 'ctrl', 'alt', 'cmd' }
local toggle = require('utils').toggle_app

local appShortcuts = {
  {
    key = 'w',
    desc = 'Toggle WezTerm',
    mods = ctrl_alt_cmd,
    command = function() toggle 'WezTerm' end,
  },

  {
    key = 'a',
    desc = 'Toggle Arc Browser',
    mods = ctrl_alt_cmd,
    command = function() toggle 'Arc' end,
  },

  {
    key = 'm',
    desc = 'Toggle Mimestream',
    mods = ctrl_alt_cmd,
    command = function() toggle 'Mimestream' end,
  },

  {
    key = 'p',
    desc = 'Toggle Photos',
    mods = ctrl_alt_cmd,
    command = function() toggle 'Photos' end,
  },
}

return appShortcuts
