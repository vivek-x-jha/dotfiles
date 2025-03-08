local toggle = require('utils').toggle_app

return {
  {
    key = 'a',
    desc = 'Toggle Arc Browser',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() toggle 'Arc' end,
  },

  {
    key = 'c',
    desc = 'Toggle ChatGPT',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() toggle 'ChatGPT' end,
  },

  {
    key = 'm',
    desc = 'Toggle Mimestream',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() toggle 'Mimestream' end,
  },

  {
    key = 'n',
    desc = 'Toggle Notion Calendar',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() toggle 'Notion Calendar' end,
  },

  {
    key = 'p',
    desc = 'Toggle Photos',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() toggle 'Photos' end,
  },

  {
    key = 's',
    desc = 'Toggle Spotify',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() toggle 'Spotify' end,
  },

  {
    key = 't',
    desc = 'Toggle Messages',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() toggle 'Messages' end,
  },

  {
    key = 'w',
    desc = 'Toggle WezTerm',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() toggle 'WezTerm' end,
  },
}
