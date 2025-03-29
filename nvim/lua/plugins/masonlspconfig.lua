-- https://github.com/williamboman/mason-lspconfig.nvim
return {
  'williamboman/mason-lspconfig.nvim',
  opts = {
    ensure_installed = require('configs.utils').filenames(vim.fn.stdpath 'config' .. '/lua/lsp'),
  },
}
