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
vim.opt.guicursor = 'n-v-c:block-blinkwait300-blinkon200-blinkoff150,i-ci:ver25-blinkwait300-blinkon200-blinkoff150' -- enable blinking cursor

vim.opt.shortmess:append 'sI' -- disable nvim intro
vim.opt.whichwrap:append '<>[]hl' -- go to previous/next line with h,l,left arrow and right arrow when cursor reaches EOL or BOL

-------------------------- Global Options -----------------------------
for option, value in pairs {
  number = true, -- print line number in front of each line
  relativenumber = true, -- show relative line numbers
  numberwidth = 2, -- minimal number of columns for line number
  ruler = false, -- hide the line/column position

  expandtab = true, -- use spaces instead of tabs
  shiftwidth = 2, -- spaces per indent
  smartindent = true, -- autoindent smartly
  tabstop = 2, -- spaces per tab
  softtabstop = 2, -- editing width of a tab

  ignorecase = true, -- ignore case in search
  smartcase = true, -- override ignorecase if uppercase in search

  clipboard = 'unnamedplus', -- use system clipboard
  cursorline = true, -- highlight the current line
  laststatus = 3, -- global statusline
  mouse = 'a', -- enable mouse support
  showmode = false, -- don't show --INSERT--
  signcolumn = 'yes', -- always show sign column
  splitbelow = true, -- new horizontal splits below
  splitright = true, -- new vertical splits to the right
  timeoutlen = 400, -- keymap timeout
  undofile = true, -- persistent undo
  updatetime = 250, -- swap write & CursorHold delay
} do
  vim.o[option] = value
end
