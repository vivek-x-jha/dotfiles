local fn = vim.fn
local g = vim.g
local o = vim.o

local lazypath = fn.stdpath 'data' .. '/lazy/lazy.nvim'
local lazyopts = require 'configs.lazy'

-- Set globals
g.mapleader = ' '
g.maplocalleader = '\\'
g.colorscheme = 'colors.themes.sourdiesel'

-- Load plugins
require('configs.utils').set_rtp(lazypath)
require('lazy').setup(lazyopts)

-- Load ui elements
o.statusline = "%!v:lua.require('ui.statusline').setup()"
require('ui.buffers').setup()

-- Load colors and highlights
require('colors.highlights').setup(g.colorscheme)

-- Load core configs
require 'configs.options'
require 'configs.usercmds'
require 'configs.autocmds'
vim.schedule(function() require 'configs.mappings' end)
