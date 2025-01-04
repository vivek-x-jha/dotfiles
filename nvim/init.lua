vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.g.colorscheme = 'colors.themes.sourdiesel'

-- Load annotations
require 'types'

--- @type Utils Load configuration functions
local utl = require 'configs.utils'

--------------------------- Load plugins & UI elements --------------------------

utl.set_rtp(vim.fn.stdpath 'data' .. '/lazy/lazy.nvim')
require('lazy').setup(require 'configs.lazy')

vim.o.statusline = "%!v:lua.require('ui.statusline').setup()"

require('ui.buffers').setup()

require('colors.highlights').setup { colorscheme = vim.g.colorscheme }

require 'configs.options'

--------------------------- Load & schedule user commands --------------------------

--- @type UserCmd[] User commands to be scheduled
local deferred_usrcmds = {}

for _, opts in ipairs(require 'configs.usercmds') do
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

--------------------------- Load & schedule auto commands --------------------------

--- @type AutoCmd[] Auto commands to be scheduled
local deferred_autocmds = {}

for _, opts in ipairs(require 'configs.autocmds') do
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

--------------------------- Schedule key mappings --------------------------

vim.schedule(function()
  --- @type KeyMap[] Mappings to be scheduled
  local mappings = require 'configs.mappings'

  for _, opts in ipairs(mappings) do
    utl.set_keymap(opts)
  end
end)
