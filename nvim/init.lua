--  _   _ ______ ______      _______ __  __
-- | \ | |  ____/ __ \ \    / /_   _|  \/  |
-- |  \| | |__ | |  | \ \  / /  | | | \  / |
-- | . ` |  __|| |  | |\ \/ /   | | | |\/| |
-- | |\  | |___| |__| | \  /   _| |_| |  | |
-- |_| \_|______\____/   \/   |_____|_|  |_|
-- https://neovim.io/doc/

local g = vim.g
local opt = vim.opt
local fn = vim.fn
local api = vim.api
local v = vim.v

g.mapleader = ' '
g.maplocalleader = '\\'
g.base46_cache = fn.stdpath 'data' .. '/nvchad/base46/'

-- Bootstrap lazy.nvim
local lazypath = fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if v.shell_error ~= 0 then
    api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    fn.getchar()
    os.exit(1)
  end
end
opt.rtp:prepend(lazypath)

local lazy_config = require 'configs.lazy'
require('lazy').setup({
  {
    'NvChad/NvChad',
    lazy = false,
    branch = 'v2.5',
    import = 'nvchad.plugins',
  },

  { import = 'plugins' },
}, lazy_config)

-- load theme
dofile(g.base46_cache .. 'defaults')
dofile(g.base46_cache .. 'statusline')

require 'options'
require 'autocmds'

vim.schedule(function()
  require 'mappings'
end)
