-- Set leader key(s)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Prepend mason to $PATH
local is_windows = vim.fn.has 'win32' ~= 0
local sep = is_windows and '\\' or '/'

vim.env.PATH = table.concat {
  table.concat({ vim.fn.stdpath 'data', 'mason', 'bin' }, sep),
  is_windows and ';' or ':',
  vim.env.PATH,
}

-- Disable providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Set scoped opts
vim.opt.fillchars = { eob = ' ' } -- remove trailing ~ on buffers
vim.opt.guicursor = 'n-v-c:block-blinkwait300-blinkon200-blinkoff150,i-ci:ver25-blinkwait300-blinkon200-blinkoff150' -- enable blinking cursor
vim.opt.shortmess:append 'sI' -- disable nvim intro
vim.opt.whichwrap:append '<>[]hl' -- go to previous/next line with h,l,left arrow and right arrow when cursor reaches EOL or BOL
vim.opt.termguicolors = true -- Ensure termguicolors is enabled if not already

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

-- Load plugins
local plugins = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'plugins')

for name, kind in vim.fs.dir(plugins) do
  if kind == 'file' and name:sub(-4) == '.lua' and name ~= 'init.lua' then
    local mod = 'plugins.' .. name:sub(1, -5)
    local ok, err = pcall(require, mod)
    if not ok then vim.schedule(function() vim.notify(('failed loading %s: %s'):format(mod, err), vim.log.levels.WARN) end) end
  end
end

-- Load LSP
require('configs.lsp').setup {
  servers = table.concat { vim.fn.stdpath 'config', sep, 'lsp' },
  linters = { 'shellcheck' },
  formatters = require('conform').list_all_formatters(),
}

-- Load colors
require('configs.highlights').setup()

-- Load statusline
vim.o.statusline = "%!v:lua.require('ui.statusline').setup()"

-- Load event triggers (some deferred)
require 'configs.autocmds'

-- Load keymaps (deferred)
vim.schedule(function() require 'configs.keymaps' end)
