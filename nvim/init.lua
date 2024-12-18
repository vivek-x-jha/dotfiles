--  _   _ ______ ______      _______ __  __
-- | \ | |  ____/ __ \ \    / /_   _|  \/  |
-- |  \| | |__ | |  | \ \  / /  | | | \  / |
-- | . ` |  __|| |  | |\ \/ /   | | | |\/| |
-- | |\  | |___| |__| | \  /   _| |_| |  | |
-- |_| \_|______\____/   \/   |_____|_|  |_|
-- https://neovim.io/doc/
local g = vim.g

-- Load plugins
g.mapleader = ' '
g.maplocalleader = '\\'

require 'configs.lazy'

-- Load ui elements
vim.o.statusline = "%!v:lua.require('ui.statusline').setup()"
require('ui.buffers').setup()

-- Load colors and highlights
g.theme = 'colors.themes.sourdiesel'
require('colors.highlights').setup()

-- Load core configs
require 'configs.options'
require 'configs.autocmds'
vim.schedule(function() require 'configs.mappings' end)
