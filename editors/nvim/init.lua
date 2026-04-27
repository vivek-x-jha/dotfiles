-- Standardize non-interactive history
vim.env.NVIM_LOG_FILE = vim.env.NVIM_LOG_FILE or (vim.fn.stdpath 'state' .. '/nvim.log')

-- Configure options
require 'opts'

-- Configure diagnostics and LSP servers
require 'lsp'

-- Set event triggers
require 'autocmds'

-- Configure plugins
vim.pack.add {
  { src = 'https://github.com/saghen/blink.lib' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
  { src = 'https://github.com/L3MON4D3/LuaSnip' }, -- blink snippets
  { src = 'https://github.com/folke/noice.nvim' },
  { src = 'https://github.com/MunifTanjim/nui.nvim' }, -- noice dependency
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/vivek-x-jha/nvim-dashboard' },
  { src = 'https://github.com/brenoprata10/nvim-highlight-colors' },
  { src = 'https://github.com/rcarriga/nvim-notify' },
  { src = 'https://github.com/vivek-x-jha/nvim-sourdiesel' },
  { src = 'https://github.com/kylechui/nvim-surround' },
  { src = 'https://github.com/vivek-x-jha/nvim-terminal' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' }, -- nvim-tree + statusline icons
  { src = 'https://github.com/christoomey/vim-tmux-navigator' },
}

require 'plugins.autocomplete'
require 'plugins.files'
require 'plugins.format'
require 'plugins.ui'
require 'plugins.gitsigns'
require 'plugins.fzf'

-- Create user commands
require 'usercmds'

-- Initialize statusline
vim.o.statusline = "%!v:lua.require('statusline').setup()"

-- Set highlights
vim.cmd.colorscheme 'sourdiesel' -- use shell theme colors

-- Set keymaps - defer to next event loop to prevent unwanted remappings
vim.schedule(function() require 'keymaps' end)
