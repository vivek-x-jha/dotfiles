-- https://lazy.folke.io/configuration
local icn = require 'icons'

return {
  defaults = {
    lazy = true,
    version = '*',
  },

  spec = 'plugins',

  ui = {
    border = 'single',
    icons = {
      ft = icn.file,
      lazy = icn.bell,
      loaded = icn.checkmark,
      not_loaded = icn.dotted_circle,
    },
  },

  performance = {
    rtp = {
      disabled_plugins = {
        '2html_plugin',
        'tohtml',
        'getscript',
        'getscriptPlugin',
        'gzip',
        'logipat',
        'netrw',
        'netrwPlugin',
        'netrwSettings',
        'netrwFileHandlers',
        'matchit',
        'tar',
        'tarPlugin',
        'rrhelper',
        'spellfile_plugin',
        'vimball',
        'vimballPlugin',
        'zip',
        'zipPlugin',
        'tutor',
        'rplugin',
        'syntax',
        'synmenu',
        'optwin',
        'compiler',
        'bugreport',
        'ftplugin',
      },
    },
  },
}
