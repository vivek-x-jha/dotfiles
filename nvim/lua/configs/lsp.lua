local icn = require 'ui.icons'
local servers = require('configs.utils').filenames(vim.fn.stdpath 'config' .. '/lsp')

-- on_attach to set LSP keymaps
local on_attach = function(bufnr)
  local map = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end

  -- LSP functionality
  map('n', 'gd', vim.lsp.buf.definition, 'LSP: Go to Definition')
  map('n', 'gD', vim.lsp.buf.declaration, 'LSP: Go to Declaration')
  map('n', 'gi', vim.lsp.buf.implementation, 'LSP: Go to Implementation')
  map('n', 'gr', vim.lsp.buf.references, 'LSP: Go to References')
  map('n', 'K', vim.lsp.buf.hover, 'LSP: Hover Documentation')
  map('n', '<C-k>', vim.lsp.buf.signature_help, 'LSP: Signature Help')
  map('n', '<leader>rn', vim.lsp.buf.rename, 'LSP: Rename Symbol')
  map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'LSP: Code Action')
  map('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, 'LSP: Format Document')

  -- Diagnostics
  map('n', '<leader>e', vim.diagnostic.open_float, 'Diagnostic: Open Float')
  map('n', '<leader>q', vim.diagnostic.setloclist, 'Diagnostic: Set Loclist')
end

-- Configure diagnostics
vim.diagnostic.config {
  float = { border = 'single' },
  severity_sort = true,

  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icn.error,
      [vim.diagnostic.severity.WARN] = icn.warn,
      [vim.diagnostic.severity.HINT] = icn.hint,
      [vim.diagnostic.severity.INFO] = icn.info,
    },
  },

  virtual_lines = {
    current_line = true,
  },

  virtual_text = {
    current_line = true,
    prefix = icn.virtualcircle,
  },
}

-- Initialize language servers
for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end
