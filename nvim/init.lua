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
require 'configs.usercmds'
require 'configs.autocmds'
vim.schedule(function() require 'configs.mappings' end)
