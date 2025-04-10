local icn = require 'ui.icons'

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

-- Configure global LSP opts
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

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

-- Add names of all lang servers in user's LSP rtp
local servers = {}
local fd = assert(vim.uv.fs_opendir(vim.fn.stdpath 'config' .. '/lsp'))

while true do
  local dir_entries = vim.uv.fs_readdir(fd)
  if not dir_entries then break end
  for _, entry in ipairs(dir_entries) do
    if entry.type == 'file' and entry.name:match '%.lua$' then
      local basename = vim.fn.fnamemodify(entry.name, ':r')
      table.insert(servers, basename)
    end
  end
end

vim.uv.fs_closedir(fd)

local packages = servers

-- Add linters
vim.list_extend(packages, { 'shellcheck' })

-- Add formatters
local conform_exists, conform = pcall(require, 'conform')
if conform_exists then
  for _, v in ipairs(conform.list_all_formatters()) do
    vim.list_extend(packages, vim.split(v.name:gsub(',', ''), '%s+'))
  end
end

-- Install all language servers, formatters, and linters
local mason_registry = require 'mason-registry'
mason_registry.refresh(function()
  for _, p in ipairs(packages) do
    local mason_pkg = assert(require('configs.masonames')[p])
    local pkg = mason_registry.get_package(mason_pkg)

    if not pkg:is_installed() then pkg:install() end
  end
end)

-- Initialize language servers
vim.lsp.enable(servers)
