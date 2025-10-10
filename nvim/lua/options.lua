local opt = vim.opt
local o = vim.o
local g = vim.g

-- Set leader key(s)
g.mapleader = ' '
g.maplocalleader = '\\'

-- Disable providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Set scoped opts
opt.fillchars = { eob = ' ' } -- remove trailing ~ on buffers
opt.guicursor = 'n-v-c:block-blinkwait300-blinkon200-blinkoff150,i-ci:ver25-blinkwait300-blinkon200-blinkoff150' -- enable blinking cursor
opt.shortmess:append 'sI' -- disable nvim intro
opt.swapfile = false -- disable swap files
opt.termguicolors = true -- Ensure termguicolors is enabled if not already
opt.whichwrap:append '<>[]hl' -- go to previous/next line with h,l,left arrow and right arrow when cursor reaches EOL or BOL

-- Set global opts
o.clipboard = 'unnamedplus' -- use system clipboard
o.cursorline = true -- highlight the current line
o.mouse = 'a' -- enable mouse support
o.splitbelow = true -- new horizontal splits below
o.splitright = true -- new vertical splits to the right
o.timeoutlen = 400 -- keymap timeout
o.undofile = true -- persistent undo
o.updatetime = 250 -- swap write & CursorHold delay
o.winborder = 'single'

-- Statusline
o.laststatus = 3 -- global statusline
o.showmode = false -- don't show --INSERT--
o.statusline = "%!v:lua.require('nvim-statusline').setup()" -- invoke statusline

-- Gutter
o.number = true -- print line number in front of each line
o.relativenumber = true -- show relative line numbers
o.numberwidth = 2 -- minimal number of columns for line number
o.ruler = false -- hide the line/column position
o.signcolumn = 'yes' -- always show sign column

-- Spaces & Tabs
o.expandtab = true -- use spaces instead of tabs
o.shiftwidth = 2 -- spaces per indent
o.smartindent = true -- autoindent smartly
o.tabstop = 2 -- spaces per tab
o.softtabstop = 2 -- editing width of a tab

-- Case Sensitive Search
o.ignorecase = true -- ignore case in search
o.smartcase = true -- override ignorecase if uppercase in search
