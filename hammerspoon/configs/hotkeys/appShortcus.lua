local utl = require 'utils'

return {
  {
    key = 'a',
    desc = 'Toggle Anki',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() utl.toggleApp 'Arc' end,
  },

  {
    key = 'b',
    desc = 'Toggle Arc Browser',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() utl.toggleApp 'Arc' end,
  },

  {
    key = 'c',
    desc = 'Toggle ChatGPT',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() utl.toggleApp 'ChatGPT' end,
  },

  {
    key = 'd',
    desc = 'Toggle Docker Desktop',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() utl.toggleApp 'Docker Desktop' end,
  },

  {
    key = 'e',
    desc = 'Toggle Notion Calendar',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() utl.toggleApp 'Notion Calendar' end,
  },

  {
    key = 'f',
    desc = 'Toggle Messenger',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() utl.toggleApp 'Messenger' end,
  },

  {
    key = 'g',
    desc = 'Toggle Google Chrome',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() utl.toggleApp 'Google Chrome' end,
  },

  {
    key = 'k',
    desc = 'Toggle Karabiner-Elements',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() utl.toggleApp 'Karabiner-Elements' end,
  },

  {
    key = 'm',
    desc = 'Toggle Messages',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() utl.toggleApp 'Messages' end,
  },

  {
    key = 'n',
    desc = 'Toggle Notes',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() utl.toggleApp 'Notes' end,
  },

  {
    key = 'p',
    desc = 'Toggle Photos',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() utl.toggleApp 'Photos' end,
  },

  {
    key = 'r',
    desc = 'Toggle Reminders',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() utl.toggleApp 'Reminders' end,
  },

  {
    key = 's',
    desc = 'Toggle Spotify',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() utl.toggleApp 'Spotify' end,
  },

  {
    key = 't',
    desc = 'Toggle WhatsApp',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() utl.toggleApp 'WhatsApp' end,
  },

  {
    key = 'v',
    desc = 'Toggle VLC',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() utl.toggleApp 'VLC' end,
  },

  {
    key = 'w',
    desc = 'Toggle WezTerm',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function() utl.toggleApp 'WezTerm' end,
  },
}
