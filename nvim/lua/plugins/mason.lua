vim.pack.add { 'https://github.com/williamboman/mason.nvim' }

local icn = require 'icons'

require('mason').setup {
  PATH = 'skip',
  ui = {
    icons = {
      package_pending = icn.download,
      package_installed = icn.checkmark,
      package_uninstalled = icn.dotted_circle,
    },
  },
  max_concurrent_installers = 10,
}
