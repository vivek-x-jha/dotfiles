vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Load annotations
require 'types'

--- @type Utils Load configuration functions
local utl = require 'configs.utils'

-- Load plugins
utl.set_rtp(vim.fn.stdpath 'data' .. '/lazy/lazy.nvim')
require('lazy').setup(require 'configs.lazy')

-- Load options
require 'configs.options'

-- Load buffer manager
require('ui.buffers').setup()

-- Load highlights and colorscheme
require('colors.highlights').setup { colorscheme = 'sourdiesel' }

-- Load statusline
vim.o.statusline = "%!v:lua.require('ui.statusline').setup()"

-- Load & schedule commands and key mappings
utl:load 'usercmds'
utl:load 'autocmds'
utl:load 'mappings'
