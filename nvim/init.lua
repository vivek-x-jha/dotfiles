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

if not mason_in_path then vim.env.PATH = mason_bin .. path_sep .. vim.env.PATH end

-- Set colorscheme
vim.cmd.colorscheme 'sourdiesel'

-- Load global and scoped settings
require 'options'

-- Load and configure plugins
require 'configs'

-- Load language servers + linters + formatters
require('lsp').setup { ensure_installed = { 'shellcheck' } }

-- Set event triggers
require 'autocmds'

-- Set key mappings - deferred to prevent being overwritten
vim.schedule(function() require 'keymaps' end)
