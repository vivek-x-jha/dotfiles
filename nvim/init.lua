-- Set leader key(s)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Disable providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Prepend Mason to $PATH
local mason_bin = vim.fs.joinpath(vim.fn.stdpath 'data', 'mason', 'bin')
local mason_in_path = vim.env.PATH:find(vim.pesc(mason_bin), 1, true)
local path_sep = vim.fn.has 'win32' == 1 and ';' or ':'

if not mason_in_path then vim.env.PATH = table.concat({ mason_bin, vim.env.PATH }, path_sep) end

-- Load settings
require 'options'

-- Load plugins
require 'configs'

-- Load lsp + linters + formatters
require('lsp').setup { ensure_installed = { 'shellcheck' } }

-- Set colorscheme
vim.cmd.colorscheme 'sourdiesel'
require('highlights').setup()

-- Set event triggers
require 'autocmds'

-- Deferred load key mappings
vim.schedule(function() require 'keymaps' end)
