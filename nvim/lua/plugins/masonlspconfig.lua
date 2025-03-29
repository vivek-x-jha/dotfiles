local utl = require 'configs.utils'
local lsp_servers = vim.fn.stdpath 'config' .. '/lua/lsp'

-- https://github.com/williamboman/mason-lspconfig.nvim
return {
  'williamboman/mason-lspconfig.nvim',
  opts = { ensure_installed = utl.filenames(lsp_servers) },
}
