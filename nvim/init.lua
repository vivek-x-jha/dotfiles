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

vim.o.statusline = "%!v:lua.require('ui.statusline').setup()"

require('ui.buffers').setup()
require('ui.highlights').setup()

require 'configs.options'
require 'configs.autocmds'
vim.schedule(function() require 'configs.mappings' end)
