--  _   _ ______ ______      _______ __  __
-- | \ | |  ____/ __ \ \    / /_   _|  \/  |
-- |  \| | |__ | |  | \ \  / /  | | | \  / |
-- | . ` |  __|| |  | |\ \/ /   | | | |\/| |
-- | |\  | |___| |__| | \  /   _| |_| |  | |
-- |_| \_|______\____/   \/   |_____|_|  |_|
-- https://neovim.io/doc/

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

require 'configs.lazy'
require 'configs.options'
require 'configs.autocmds'
require 'ui'

vim.schedule(function() require 'configs.mappings' end)
