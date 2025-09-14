-- Load plugins
local repos = {
  'windwp/nvim-autopairs',
  'saghen/blink.cmp',
  'L3MON4D3/LuaSnip',
  'stevearc/conform.nvim',
  'ibhagwan/fzf-lua',
  'lewis6991/gitsigns.nvim',
  'brenoprata10/nvim-highlight-colors',
  'lukas-reineke/indent-blankline.nvim',
  'williamboman/mason.nvim',
  'rcarriga/nvim-notify',
  'folke/noice.nvim',
  'MunifTanjim/nui.nvim',
  'nvim-treesitter/nvim-treesitter',
  'nvim-pack/nvim-spectre',
  'nvim-lua/plenary.nvim',
  'kylechui/nvim-surround',
  'christoomey/vim-tmux-navigator',
  'nvim-tree/nvim-tree.lua',
  'nvim-tree/nvim-web-devicons',
}

local gh = 'https://github.com/'
local specs = {}

for _, repo in ipairs(repos) do
  table.insert(specs, gh .. repo)
end

vim.pack.add(specs)

-- Configure plugins in $XDG_CONFIG_HOME/nvim/lua/configs/
local configs = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'configs')

for name, kind in vim.fs.dir(configs) do
  local is_cfg = kind == 'file' and name:sub(-4) == '.lua' and name ~= 'init.lua'
  if is_cfg then require('configs.' .. name:sub(1, -5)) end
end

-- Lazy load local plugins
vim.cmd.packadd 'dashboard'
vim.cmd.packadd 'terminal'
