local fn = vim.fn
local g = vim.g
local o = vim.o

local autocmds = require 'configs.autocmds'
local lazyopts = require 'configs.lazy'
local usrcmds = require 'configs.usercmds'
local utl = require 'configs.utils'

local lazypath = fn.stdpath 'data' .. '/lazy/lazy.nvim'
local deferred_usrcmds = {}
local deferred_autocmds = {}

-- Set globals
g.mapleader = ' '
g.maplocalleader = '\\'
g.colorscheme = 'colors.themes.sourdiesel'

-- Load plugins
require('configs.utils').set_rtp(lazypath)
require('lazy').setup(lazyopts)

-- Load Statusline dynamically
o.statusline = "%!v:lua.require('ui.statusline').setup()"

-- Enable Buffer cycling
require('ui.buffers').setup()

-- Load colors and highlights
require('colors.highlights').setup(g.colorscheme)

-- Configure global and window opts
require 'configs.options'

-- Load & schedule user commands
for _, opts in ipairs(usrcmds) do
  if opts.after then
    table.insert(deferred_usrcmds, opts)
  else
    utl.create_user_command(opts)
  end
end

vim.schedule(function()
  for _, opts in ipairs(deferred_usrcmds) do
    utl.create_user_command(opts)
  end
end)

-- Load lsp progress bar
require('ui.statusline').autocmds()

-- Load & schedule auto commands
for _, opts in ipairs(autocmds) do
  if opts.after then
    table.insert(deferred_autocmds, opts)
  else
    utl.create_auto_command(opts)
  end
end

vim.schedule(function()
  for _, opts in ipairs(deferred_autocmds) do
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
