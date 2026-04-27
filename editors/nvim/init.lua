-- Standardize non-interactive history
vim.env.NVIM_LOG_FILE = vim.env.NVIM_LOG_FILE or (vim.fn.stdpath 'state' .. '/nvim.log')

-- Configure options
require 'opts'

-- Configure diagnostics and LSP servers
require 'lsp'

-- Set event triggers
require 'autocmds'

-- Configure plugins
require 'plugins'

-- Create user commands
require 'usercmds'

-- Initialize statusline
vim.o.statusline = "%!v:lua.require('statusline').setup()"

-- Set highlights
vim.cmd.colorscheme 'sourdiesel' -- use shell theme colors

-- Set keymaps - defer to next event loop to prevent unwanted remappings
vim.schedule(function() require 'keymaps' end)
