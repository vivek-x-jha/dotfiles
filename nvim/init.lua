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

-- Configure statusline
vim.o.laststatus = 3 -- global statusline
vim.o.showmode = false -- don't show --INSERT--
vim.o.statusline = "%!v:lua.require('nvim-statusline').setup()" -- initialize statusline

-- Configure diagnostics ui
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'single' },
  virtual_lines = { current_line = true },
  virtual_text = { current_line = true, prefix = '#' },

  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.HINT] = 'H',
      [vim.diagnostic.severity.INFO] = 'I',
    },
  },
}

--- @type string -- language server configs path: ~/.config/nvim/lsp/
local server_path = vim.fs.joinpath(vim.fn.stdpath 'config', 'lsp')

-- Ensure the directory exists
assert(vim.fn.isdirectory(server_path) == 1, '[LSP ERROR] Failed to open: "' .. server_path .. '"')

---@type string[] -- language server names
local servers = {}

for name, type in vim.fs.dir(server_path) do
  --- @type boolean -- flag for valid lua file
  local is_lua_file = type == 'file' and name:sub(-4) == '.lua'

  if is_lua_file then table.insert(servers, name:sub(1, -5)) end
end

-- Initialize language servers
vim.lsp.enable(servers)

-- Configure plugins
require 'plugins'

-- Set event triggers
require 'autocmds'

-- Set highlights
vim.cmd.colorscheme 'sourdiesel' -- use shell theme colors

-- Set keymaps - defer to next event loop to prevent unwanted remappings
vim.schedule(function() require 'keymaps' end)
