--  _   _ ______ ______      _______ __  __
-- | \ | |  ____/ __ \ \    / /_   _|  \/  |
-- |  \| | |__ | |  | \ \  / /  | | | \  / |
-- | . ` |  __|| |  | |\ \/ /   | | | |\/| |
-- | |\  | |___| |__| | \  /   _| |_| |  | |
-- |_| \_|______\____/   \/   |_____|_|  |_|
-- https://neovim.io/doc/

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Load plugins
require 'configs.lazy'

-- Load ui elements
vim.o.statusline = "%!v:lua.require('ui.statusline').setup()"
require('ui.buffers').setup()

-- Load colors and highlights
vim.g.colorscheme = 'colors.themes.sourdiesel'
require('colors.highlights').setup(vim.g.colorscheme)

-- Load core configs
require 'configs.options'
require 'configs.autocmds'
vim.schedule(function() require 'configs.mappings' end)
