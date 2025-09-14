-- Set leader key(s)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Disable providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

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
