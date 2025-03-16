local toggle = require('utils').toggle_app

return {
  {
    key = 'a',
    desc = 'Toggle Arc Browser',
    mods = HYPER,
    command = function() toggle 'Arc' end,
  },

  {
    key = 'c',
    desc = 'Toggle ChatGPT',
    mods = HYPER,
    command = function() toggle 'ChatGPT' end,
  },

  {
    key = 'g',
    desc = 'Toggle Gmail Client',
    mods = HYPER,
    command = function() toggle 'Mimestream' end,
  },

  {
    key = 'k',
    desc = 'Toggle Karabiner-Elements',
    mods = HYPER,
    command = function() toggle 'Karabiner-Elements' end,
  },

  {
    key = 'm',
    desc = 'Toggle Messages',
    mods = HYPER,
    command = function() toggle 'Messages' end,
  },

  {
    key = 'n',
    desc = 'Toggle Notion Calendar',
    mods = HYPER,
    command = function() toggle 'Notion Calendar' end,
  },

  {
    key = 'p',
    desc = 'Toggle Photos',
    mods = HYPER,
    command = function() toggle 'Photos' end,
  },

  {
    key = 's',
    desc = 'Toggle Spotify',
    mods = HYPER,
    command = function() toggle 'Spotify' end,
  },

  {
    key = 't',
    desc = 'Toggle WhatsApp',
    mods = HYPER,
    command = function() toggle 'WhatsApp' end,
  },

  {
    key = 'w',
    desc = 'Toggle WezTerm',
    mods = HYPER,
    command = function() toggle 'WezTerm' end,
  },
}
