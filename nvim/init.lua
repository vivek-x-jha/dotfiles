vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.g.colorscheme = 'colors.themes.sourdiesel'

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
require('colors.highlights').setup { colorscheme = vim.g.colorscheme }

-- Load statusline
vim.o.statusline = "%!v:lua.require('ui.statusline').setup()"

-- Load & schedule commands
utl:load 'usercmds'
utl:load 'autocmds'

-- Schedule key mappings
vim.schedule(function()
  --- @type KeyMap[] Mappings to be scheduled
  local mappings = require 'configs.mappings'

  for _, opts in ipairs(mappings) do
    utl.set_keymap(opts)
  end
end)
