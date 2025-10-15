-- Configure diagnostics UI
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'single' },
  virtual_lines = { current_line = true },
  virtual_text = { current_line = true, prefix = '#' },

  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.HINT] = 'H',
      [vim.diagnostic.severity.INFO] = 'I',
    },
  },
}

--- @type string -- language server configs path: ~/.config/nvim/lsp/
local server_path = vim.fs.joinpath(vim.fn.stdpath 'config', 'lsp')

-- Ensure the directory exists
assert(vim.fn.isdirectory(server_path) == 1, '[LSP ERROR] Failed to open: "' .. server_path .. '"')

---@type string[] -- language server names
local servers = {}

for name, type in vim.fs.dir(server_path) do
  --- @type boolean -- flag for valid lua file
  local is_lua_file = type == 'file' and name:sub(-4) == '.lua'

  if is_lua_file then table.insert(servers, name:sub(1, -5)) end
end

-- Initialize language servers
vim.lsp.enable(servers)
