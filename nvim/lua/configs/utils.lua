--- @class M
local M = {}
local api = vim.api
local fn = vim.fn

--- Converts autocommand group name to ID and clears old group commands
--- (For more help :h nvim_create_augroup)
--- ```lua
--- -- Create DashAU autocommand group
--- require('configs.utils').create_augroup 'DashAU'
---
--- -- Keep old group commands
--- require('configs.utils').create_augroup { 'LspSignatureAU', false }
---
--- -- The below are functionally equivalent:
--- require('configs.utils').create_augroup { 'YankAU', true }
--- require('configs.utils').create_augroup 'YankAU'
--- ```
--- @param opts string|{[1]: string, [2]: boolean} AU Group name | { AU Group name, Clear Group }
--- @return integer
M.create_augroup = function(opts)
  if type(opts) == 'string' then return api.nvim_create_augroup(opts, {}) end
  return api.nvim_create_augroup(opts[1], { clear = opts[2] })
end

--- Creates and configures autocommand
--- (For more help :h nvim_create_autocmd)
--- ```lua
--- require('configs.utils').create_autocmd {
---   event = 'FileType',
---   group = augroup 'SpectreAU',
---   pattern = 'spectre_panel',
---   desc = 'Hide line numbers for Spectre',
---   callback = function()
---     vim.opt_local.number = false
---     vim.opt_local.relativenumber = false
---   end,
--- }
--- ```
--- @param opts table  Options Dictionary: `event` required
M.create_autocmd = function(opts)
  --- @type string|string[] Event(s) for the autocmd
  local event = opts.event
  opts.event = nil

  api.nvim_create_autocmd(event, opts)
end

--- Creates and configures user command
--- (For more help, see :h nvim_create_user_command)
--- ```lua
--- require('configs.utils').create_user_command {
---   name = 'ReloadConfig',
---   command = 'source $MYVIMRC',
---   desc = 'Reload Neovim configuration',
--- }
--- ```
--- @param opts table Options Dictionary: `name`, `cmd` required
M.create_user_command = function(opts)
  --- @type string Command name
  local name = opts.name
  --- @type string|function Command definition
  local cmd = opts.command

  opts.name = nil
  opts.command = nil

  api.nvim_create_user_command(name, cmd, opts)
end

--- Remaps key sequence
--- (For more help, see :h vim.keymap.set)
--- ```lua
--- require('configs.utils').set_keymap {
---   desc = 'Find files',
---   mode = 'n',
---   keys = '<leader>f',
---   command = '<cmd>Telescope find_files<CR>',
--- }
--- ```
--- @param opts table Options Dictionary: `mode`, `keys`, and `command` required
M.set_keymap = function(opts)
  --- @type string|string[] Neovim Mode(s)
  local mode = opts.mode
  --- @type string Key sequence (LHS)
  local keys = opts.keys
  --- @type string|function Action (RHS)
  local command = opts.command

  opts.mode = nil
  opts.keys = nil
  opts.command = nil

  vim.keymap.set(mode, keys, command, opts)
end

--- Sets runtime path (rtp) and clones lazy.nvim repo if not present
--- (For more help, see :h 'runtimepath')
--- ```lua
--- require('configs.utils').set_rtp('~/.local/share/nvim/lazy/lazy.nvim')
--- ```
--- @param lazypath string Path to lazy.nvim directory
M.set_rtp = function(lazypath)
  -- Bootstrap lazy if not installed
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'

    local out = fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      '--branch=stable',
      lazyrepo,
      lazypath,
    }

    if vim.v.shell_error ~= 0 then
      api.nvim_echo({
        { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
        { out, 'WarningMsg' },
        { '\nPress any key to exit...' },
      }, true, {})

      fn.getchar()
      os.exit(1)
    end
  end

  -- Prepend lazy to runtimepath
  vim.opt.rtp:prepend(lazypath)
end

return M
