-- Prepend Mason to $PATH
local mason_bin = vim.fs.joinpath(vim.fn.stdpath 'data', 'mason', 'bin')
local mason_in_path = vim.env.PATH:find(vim.pesc(mason_bin), 1, true)
local path_sep = vim.fn.has 'win32' == 1 and ';' or ':'

if not mason_in_path then vim.env.PATH = table.concat({ mason_bin, vim.env.PATH }, path_sep) end

-- Load vendor plugins
local configs = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'configs')

for name, kind in vim.fs.dir(configs) do
  local is_cfg = kind == 'file' and name:sub(-4) == '.lua' and name ~= 'init.lua'
  if is_cfg then require('configs.' .. name:sub(1, -5)) end
end

-- Lazy load local plugins
vim.cmd.packadd 'dashboard'
vim.cmd.packadd 'terminal'
