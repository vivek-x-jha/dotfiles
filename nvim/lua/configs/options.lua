local fn = vim.fn
local g = vim.g
local env = vim.env
local o = vim.o
local opt = vim.opt

-------------------------- Mason Path -----------------------------

local is_windows = fn.has 'win32' ~= 0
local sep = is_windows and '\\' or '/'
local delim = is_windows and ';' or ':'
local masonbin = { fn.stdpath 'data', 'mason', 'bin' }

env.PATH = table.concat(masonbin, sep) .. delim .. env.PATH

-------------------------- Disable Providers -----------------------------

g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-------------------------- Scoped Options -----------------------------

opt.fillchars = { eob = ' ' } -- remove trailing ~ on buffers
opt.shortmess:append 'sI' -- disable nvim intro
opt.whichwrap:append '<>[]hl' -- go to previous/next line with h,l,left arrow and right arrow when cursor reaches EOL or BOL
opt.guicursor = 'n-v-c:block-blinkwait300-blinkon200-blinkoff150,i-ci:ver25-blinkwait300-blinkon200-blinkoff150' -- enable blinking cursor

-------------------------- Global Options -----------------------------

o.number = true -- print line number in front of each line
o.relativenumber = true -- show line number relative to the line with the cursor in front of each line
o.numberwidth = 2 -- Minimal number of columns to use for the line number
o.ruler = false -- Hide the line and column number of the cursor position

o.expandtab = true -- in Insert mode: Use the appropriate number of spaces to insert a <Tab>
o.shiftwidth = 2 -- number of spaces to use for each step of (auto)indent
o.smartindent = true -- do smart autoindenting when starting a new line
o.tabstop = 2 -- number of spaces that a <Tab> in the file counts for
o.softtabstop = 2 -- number of spaces that a <Tab> counts for while performing editing operations

o.ignorecase = true -- Ignore case in search patterns
o.smartcase = true -- Override 'ignorecase' if search pattern contains upper case chars

o.clipboard = 'unnamedplus' -- use system clipboard for all yank, delete, change, and put operations
o.cursorline = true -- highlight text line of the cursor
o.laststatus = 3 -- only last window will always have a status line
o.mouse = 'a' -- Enable mouse support for all modes
o.showmode = false -- hide mode display (i.e., -- INSERT --)
o.signcolumn = 'yes' -- always draw the signcolumn
o.splitbelow = true -- :split puts new window below current
o.splitright = true -- :vsplit puts new window right current
o.timeoutlen = 400 -- Time (ms) to wait for mapped sequence to complete
o.undofile = true -- saves/restores undo history to an undo file
o.updatetime = 250 -- interval for writing swap file to disk (also used by gitsigns)
