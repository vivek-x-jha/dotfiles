vim.pack.add {
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
  { src = 'https://github.com/nvim-pack/nvim-spectre' },
  { src = 'https://github.com/vivek-x-jha/nvim-statusline' },
  { src = 'https://github.com/kylechui/nvim-surround' },
  { src = 'https://github.com/vivek-x-jha/nvim-terminal' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' }, -- noice syntax parsing
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' }, -- nvim-tree + statusline icons
  { src = 'https://github.com/nvim-lua/plenary.nvim' }, -- spectre dependency
  { src = 'https://github.com/christoomey/vim-tmux-navigator' },
}

vim.cmd.colorscheme 'sourdiesel' -- use shell theme colors

require 'options' -- set global/buffer opts + initialize statusline
require 'lsp' -- initialize language servers
require 'plugins' -- configure plugins
require 'autocmds' -- set event triggers

vim.schedule(function() require 'keymaps' end) -- defer settings key maps to next event loop to prevent unwanted remappings
