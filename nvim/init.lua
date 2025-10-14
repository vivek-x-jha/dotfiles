-- Set leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Disable providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Set scoped opts
vim.opt.fillchars = { eob = ' ' } -- remove trailing ~ on buffers
vim.opt.guicursor = 'n-v-c:block-blinkwait300-blinkon200-blinkoff150,i-ci:ver25-blinkwait300-blinkon200-blinkoff150' -- enable blinking cursor
vim.opt.shortmess:append 'sI' -- disable nvim intro
vim.opt.swapfile = false -- disable swap files
vim.opt.termguicolors = true -- Ensure termguicolors is enabled if not already
vim.opt.whichwrap:append '<>[]hl' -- go to previous/next line with h,l,left/right arrows at EOL/BOL

-- Set global opts
vim.o.clipboard = 'unnamedplus' -- use system clipboard
vim.o.cursorline = true -- highlight the current line
vim.o.splitbelow = true -- new horizontal splits below
vim.o.splitright = true -- new vertical splits to the right
vim.o.timeoutlen = 400 -- keymap timeout
vim.o.undofile = true -- persistent undo
vim.o.updatetime = 250 -- swap write & CursorHold delay
vim.o.winborder = 'single'

-- Configure gutter
vim.o.number = true -- print line number in front of each line
vim.o.relativenumber = true -- show relative line numbers
vim.o.numberwidth = 2 -- minimal number of columns for line number
vim.o.ruler = false -- hide the line/column position
vim.o.signcolumn = 'yes' -- always show sign column

-- Configure spaces & tabs
vim.o.expandtab = true -- use spaces instead of tabs
vim.o.shiftwidth = 2 -- spaces per indent
vim.o.smartindent = true -- autoindent smartly
vim.o.tabstop = 2 -- spaces per tab
vim.o.softtabstop = 2 -- editing width of a tab

-- Case Sensitive Search
vim.o.ignorecase = true -- ignore case in search
vim.o.smartcase = true -- override ignorecase if uppercase in search

-- Load plugins
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

-- Set highlights
vim.cmd.colorscheme 'sourdiesel' -- use shell theme colors

-- Configure statusline
vim.o.laststatus = 3 -- global statusline
vim.o.showmode = false -- don't show --INSERT--
vim.o.statusline = "%!v:lua.require('nvim-statusline').setup()" -- initialize statusline

-- Initialize language servers
require 'lsp'

-- Configure plugins
require 'plugins'

-- Set event triggers
require 'autocmds'

-- Set keymaps - defer to next event loop to prevent unwanted remappings
vim.schedule(function() require 'keymaps' end)
