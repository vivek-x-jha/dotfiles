vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Load annotations
require 'types'

--- @type Utils Load configuration functions
local utl = require 'configs.utils'

--- @type string Lazy install path
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

-- Bootstrap lazy if not installed
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})

    vim.fn.getchar()
    os.exit(1)
  end
end

-- Prepend lazy to rtp
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require('lazy').setup(require 'configs.lazy')

-- Load LSP
require 'configs.lsp'

-- Load options
require 'configs.options'

-- Load buffer manager
require('ui.buffers').setup()

-- Load highlights and colorscheme
require('colors.highlights').setup { colorscheme = 'sourdiesel' }

-- Load statusline
vim.o.statusline = "%!v:lua.require('ui.statusline').setup()"

-- Load & schedule commands and key mappings
for _, type in ipairs { 'usercmds', 'autocmds', 'mappings' } do
  local commands = {
    usercmds = utl.create_user_command,
    autocmds = utl.create_auto_command,
    mappings = utl.set_keymap,
  }

  --- @type AutoCmd[]|UserCmd[]|KeyMap[] Auto/User commands or keymappings
  local cmds = require('configs.' .. type)

  --- @type AutoCmd[]|UserCmd[]|KeyMap[] Auto/User commands or keymappings to be scheduled
  local deferred_cmds = {}

  for _, cmd in ipairs(cmds) do
    if cmd.enabled == false then
      goto continue
    elseif cmd.after or type == 'mappings' then
      table.insert(deferred_cmds, cmd)
    else
      commands[type](cmd)
    end

    ::continue::
  end

  vim.schedule(function()
    for _, cmd in ipairs(deferred_cmds) do
      commands[type](cmd)
    end
  end)
end
