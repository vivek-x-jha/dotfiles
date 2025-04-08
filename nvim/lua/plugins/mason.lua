-- https://github.com/williamboman/mason.nvim
return {
  'williamboman/mason.nvim',
  cmd = { 'Mason', 'MasonInstall', 'MasonInstallAll', 'MasonUpdate' },
  opts = function()
    local icn = require 'ui.icons'

    return {
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
  end,
}
