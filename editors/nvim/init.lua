-- Standardize Neovim logging for interactive and headless launches.
vim.env.NVIM_LOG_FILE = vim.env.NVIM_LOG_FILE or (vim.fn.stdpath 'state' .. '/nvim.log')

-- Configure core editor options.
require 'opts'

-- Configure diagnostics and LSP servers.
require 'lsp'

-- Register autocommands.
require 'autocmds'

-- Register plugin sources.
vim.pack.add {
  -- autocomplete
  { src = 'https://github.com/saghen/blink.lib' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/L3MON4D3/LuaSnip' }, -- blink snippets
  { src = 'https://github.com/brenoprata10/nvim-highlight-colors' },

  -- editing
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/kylechui/nvim-surround' },

  -- files
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' }, -- nvim-tree + statusline icons
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },

  -- format
  { src = 'https://github.com/stevearc/conform.nvim' },

  -- ui
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
  { src = 'https://github.com/MunifTanjim/nui.nvim' }, -- noice dependency
  { src = 'https://github.com/folke/noice.nvim' },
  { src = 'https://github.com/vivek-x-jha/nvim-dashboard' },
  { src = 'https://github.com/rcarriga/nvim-notify' },
  { src = 'https://github.com/vivek-x-jha/nvim-sourdiesel' },
  { src = 'https://github.com/vivek-x-jha/nvim-terminal' },
  { src = 'https://github.com/christoomey/vim-tmux-navigator' },

  -- gitsigns
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },

  -- fzf
  { src = 'https://github.com/ibhagwan/fzf-lua' },
}

-- Configure plugin modules.
require 'plugins.autocomplete'
require 'plugins.editing'
require 'plugins.files'
require 'plugins.format'
require 'plugins.ui'
require 'plugins.gitsigns'
require 'plugins.fzf'

-- Register user commands.
require 'usercmds'

-- Initialize the local statusline.
vim.o.statusline = "%!v:lua.require('statusline').setup()"

-- Apply the shell-aligned colorscheme.
vim.cmd.colorscheme 'sourdiesel' -- use shell theme colors

-- Defer keymaps to the next event loop to avoid unwanted remappings.
vim.schedule(function() require 'keymaps' end)
