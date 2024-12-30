local fn = vim.fn
local g = vim.g
local o = vim.o

local utl = require 'configs.utils'

-- Set globals
g.mapleader = ' '
g.maplocalleader = '\\'
g.colorscheme = 'colors.themes.sourdiesel'

-- Load plugins
local lazypath = fn.stdpath 'data' .. '/lazy/lazy.nvim'
local lazyopts = require 'configs.lazy'

require('configs.utils').set_rtp(lazypath)
require('lazy').setup(lazyopts)

-- Load ui elements
o.statusline = "%!v:lua.require('ui.statusline').setup()"
require('ui.buffers').setup()

-- Load colors and highlights
require('colors.highlights').setup(g.colorscheme)

-- Configure global and window opts
require 'configs.options'

-- Load & schedule user commands
local usr = require 'configs.usercmds'

for _, opts in ipairs(usr.main_cmds) do
  utl.create_user_command(opts)
end

vim.schedule(function()
  for _, opts in ipairs(usr.deferred_cmds) do
    utl.create_user_command(opts)
  end
end)

-- Load lsp progress bar
require('ui.statusline').autocmds()

-- Load & schedule auto commands
local au = require 'configs.autocmds'

for _, opts in ipairs(au.main_cmds) do
  utl.create_auto_command(opts)
end

vim.schedule(function()
  for _, opts in ipairs(au.deferred_cmds) do
    utl.create_auto_command(opts)
  end
end)

-- Schedule mappings
vim.schedule(function()
  local mappings = require 'configs.mappings'

  for _, opts in ipairs(mappings) do
    utl.set_keymap(opts)
  end
end)
