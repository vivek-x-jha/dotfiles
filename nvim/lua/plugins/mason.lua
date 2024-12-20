-- https://github.com/williamboman/mason.nvim
return {
  'williamboman/mason.nvim',
  cmd = {
    'Mason',
    'MasonInstall',
    'MasonInstallAll',
    'MasonUpdate',
  },

  opts = function()
    return {
      PATH = 'skip',
      ui = {
        icons = {
          package_pending = ' ',
          package_installed = ' ',
          package_uninstalled = ' ',
        },
      },
      max_concurrent_installers = 10,
      ensure_installed = {
        'lua-language-server',
        'stylua',
        'html-lsp',
        'css-lsp',
        'prettier',
        'pyre',
      },
    }
  end,
}
