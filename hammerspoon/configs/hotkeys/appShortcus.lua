local toggle = require('utils').toggle_app

return {
  {
    key = 'w',
    desc = 'Toggle WezTerm',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() toggle 'WezTerm' end,
  },

  {
    key = 'a',
    desc = 'Toggle Arc Browser',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() toggle 'Arc' end,
  },

  {
    key = 'm',
    desc = 'Toggle Mimestream',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() toggle 'Mimestream' end,
  },

  {
    key = 'p',
    desc = 'Toggle Photos',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() toggle 'Photos' end,
  },
}
