local utl = require 'utils'

return {
  {
    key = 'a',
    desc = 'Toggle Arc Browser',
    mods = HYPER,
    command = function() utl.toggleApp 'Arc' end,
  },

  {
    key = 'c',
    desc = 'Toggle ChatGPT',
    mods = HYPER,
    command = function() utl.toggleApp 'ChatGPT' end,
  },

  {
    key = 'd',
    desc = 'Toggle Docker Desktop',
    mods = HYPER,
    command = function() utl.toggleApp 'Docker Desktop' end,
  },

  {
    key = 'g',
    desc = 'Toggle Gmail Client',
    mods = HYPER,
    command = function() utl.toggleApp 'Mimestream' end,
  },

  {
    key = 'k',
    desc = 'Toggle Karabiner-Elements',
    mods = HYPER,
    command = function() utl.toggleApp 'Karabiner-Elements' end,
  },

  {
    key = 'm',
    desc = 'Toggle Messages',
    mods = HYPER,
    command = function() utl.toggleApp 'Messages' end,
  },

  {
    key = 'n',
    desc = 'Toggle Notion Calendar',
    mods = HYPER,
    command = function() utl.toggleApp 'Notion Calendar' end,
  },

  {
    key = 'p',
    desc = 'Toggle Photos',
    mods = HYPER,
    command = function() utl.toggleApp 'Photos' end,
  },

  {
    key = 's',
    desc = 'Toggle Spotify',
    mods = HYPER,
    command = function() utl.toggleApp 'Spotify' end,
  },

  {
    key = 't',
    desc = 'Toggle WhatsApp',
    mods = HYPER,
    command = function() utl.toggleApp 'WhatsApp' end,
  },

  {
    key = 'v',
    desc = 'Toggle VLC',
    mods = HYPER,
    command = function() utl.toggleApp 'VLC' end,
  },

  {
    key = 'w',
    desc = 'Toggle WezTerm',
    mods = HYPER,
    command = function() utl.toggleApp 'WezTerm' end,
  },
}
