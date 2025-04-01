local servers = require('configs.utils').filenames(vim.fn.stdpath 'config' .. '/lsp')

-- https://github.com/williamboman/mason-lspconfig.nvim
return {
  'williamboman/mason-lspconfig.nvim',
  opts = {
    ensure_installed = servers,
  },
}
