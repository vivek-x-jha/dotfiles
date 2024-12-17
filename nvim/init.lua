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

require 'lazyconfig'
require 'options'

vim.o.statusline = "%!v:lua.require('statusline').open()"
require('statusline').autocmds()

require 'ui.tabufline.lazyload'
require 'terminal'
require 'highlights'
require 'autocmds'

vim.schedule(function() require 'mappings' end)
