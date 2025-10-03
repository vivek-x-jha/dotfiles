-- Set leader key(s)
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
vim.opt.whichwrap:append '<>[]hl' -- go to previous/next line with h,l,left arrow and right arrow when cursor reaches EOL or BOL

-- Set global opts
vim.o.number = true -- print line number in front of each line
vim.o.relativenumber = true -- show relative line numbers
vim.o.numberwidth = 2 -- minimal number of columns for line number
vim.o.ruler = false -- hide the line/column position

vim.o.expandtab = true -- use spaces instead of tabs
vim.o.shiftwidth = 2 -- spaces per indent
vim.o.smartindent = true -- autoindent smartly
vim.o.tabstop = 2 -- spaces per tab
vim.o.softtabstop = 2 -- editing width of a tab

vim.o.ignorecase = true -- ignore case in search
vim.o.smartcase = true -- override ignorecase if uppercase in search

vim.o.clipboard = 'unnamedplus' -- use system clipboard
vim.o.cursorline = true -- highlight the current line
vim.o.laststatus = 3 -- global statusline
vim.o.mouse = 'a' -- enable mouse support
vim.o.showmode = false -- don't show --INSERT--
vim.o.signcolumn = 'yes' -- always show sign column
vim.o.splitbelow = true -- new horizontal splits below
vim.o.splitright = true -- new vertical splits to the right
vim.o.timeoutlen = 400 -- keymap timeout
vim.o.undofile = true -- persistent undo
vim.o.updatetime = 250 -- swap write & CursorHold delay
vim.o.winborder = 'single'
