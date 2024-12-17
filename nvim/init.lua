--  _   _ ______ ______      _______ __  __
-- | \ | |  ____/ __ \ \    / /_   _|  \/  |
-- |  \| | |__ | |  | \ \  / /  | | | \  / |
-- | . ` |  __|| |  | |\ \/ /   | | | |\/| |
-- | |\  | |___| |__| | \  /   _| |_| |  | |
-- |_| \_|______\____/   \/   |_____|_|  |_|
-- https://neovim.io/doc/
local g = vim.g

g.mapleader = ' '
g.maplocalleader = '\\'
g.theme = 'themes.sourdiesel'

require 'configs.lazy'
require 'configs.options'
require 'configs.autocmds'

vim.o.statusline = "%!v:lua.require('ui.statusline').open()"

require('ui.statusline').autocmds()
require('ui.buffers').load()
require 'ui.terminal'
require('ui.highlights').color_all()

vim.schedule(function() require 'configs.mappings' end)
