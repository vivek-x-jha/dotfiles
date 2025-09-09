local icn = require 'icons'

-- https://github.com/williamboman/mason.nvim
return {
  'williamboman/mason.nvim',
  cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonUpdate', 'MasonLog' },
  opts = {
    PATH = 'skip',
    ui = {
      icons = {
        package_pending = icn.download,
        package_installed = icn.checkmark,
        package_uninstalled = icn.dotted_circle,
      },
    },
    max_concurrent_installers = 10,
  },
}
