-------------------------- Mason Path -----------------------------

local is_windows = vim.fn.has 'win32' ~= 0
local sep = is_windows and '\\' or '/'
local delim = is_windows and ';' or ':'
local masonbin = { vim.fn.stdpath 'data', 'mason', 'bin' }

vim.env.PATH = table.concat {
  table.concat(masonbin, sep),
  delim,
  vim.env.PATH,
}

-------------------------- Disable Providers -----------------------------

for _, provider in ipairs {
  'node',
  'python3',
  'perl',
  'ruby',
} do
  vim.g[table.concat { 'loaded_', provider, '_provider' }] = 0
end

-------------------------- Scoped Options -----------------------------

vim.opt.fillchars = { eob = ' ' } -- remove trailing ~ on buffers
vim.opt.shortmess:append 'sI' -- disable nvim intro
vim.opt.whichwrap:append '<>[]hl' -- go to previous/next line with h,l,left arrow and right arrow when cursor reaches EOL or BOL
vim.opt.guicursor = 'n-v-c:block-blinkwait300-blinkon200-blinkoff150,i-ci:ver25-blinkwait300-blinkon200-blinkoff150' -- enable blinking cursor

-------------------------- Global Options -----------------------------

vim.o.number = true -- print line number in front of each line
vim.o.relativenumber = true -- show line number relative to the line with the cursor in front of each line
vim.o.numberwidth = 2 -- Minimal number of columns to use for the line number
vim.o.ruler = false -- Hide the line and column number of the cursor position

vim.o.expandtab = true -- in Insert mode: Use the appropriate number of spaces to insert a <Tab>
vim.o.shiftwidth = 2 -- number of spaces to use for each step of (auto)indent
vim.o.smartindent = true -- do smart autoindenting when starting a new line
vim.o.tabstop = 2 -- number of spaces that a <Tab> in the file counts for
vim.o.softtabstop = 2 -- number of spaces that a <Tab> counts for while performing editing operations

vim.o.ignorecase = true -- Ignore case in search patterns
vim.o.smartcase = true -- Override 'ignorecase' if search pattern contains upper case chars

vim.o.clipboard = 'unnamedplus' -- use system clipboard for all yank, delete, change, and put operations
vim.o.cursorline = true -- highlight text line of the cursor
vim.o.laststatus = 3 -- only last window will always have a status line
vim.o.mouse = 'a' -- Enable mouse support for all modes
vim.o.showmode = false -- hide mode display (i.e., -- INSERT --)
vim.o.signcolumn = 'yes' -- always draw the signcolumn
vim.o.splitbelow = true -- :split puts new window below current
vim.o.splitright = true -- :vsplit puts new window right current
vim.o.timeoutlen = 400 -- Time (ms) to wait for mapped sequence to complete
vim.o.undofile = true -- saves/restores undo history to an undo file
vim.o.updatetime = 250 -- interval for writing swap file to disk (also used by gitsigns)
