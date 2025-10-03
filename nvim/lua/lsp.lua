--- @type table<string, string> -- Custom icons
local icons = require 'icons'

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'single' },
  virtual_lines = { current_line = true },
  virtual_text = { current_line = true, prefix = icons.virtualcircle },

  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.HINT] = 'H',
      [vim.diagnostic.severity.INFO] = 'I',
    },
  },
}

---@type string[] language server configs
local servers = {}

-- Create table of language servers in "$XDG_CONFIG_HOME/nvim/lsp/"
for name, kind in vim.fs.dir(vim.fs.joinpath(vim.fn.stdpath 'config', 'lsp')) do
  if name:sub(-4) == '.lua' and kind == 'file' then table.insert(servers, name:sub(1, -5)) end
end

-- Initialize language servers
vim.lsp.enable(servers)
