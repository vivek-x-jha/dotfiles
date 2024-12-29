local M = {}
local api = vim.api

M.create_augroup = function(opts)
  if type(opts) == 'string' then return vim.api.nvim_create_augroup(opts, {}) end
  return api.nvim_create_augroup(opts[1], { clear = opts[2] })
end

M.create_autocmd = function(opts)
  local event = opts.event
  opts.event = nil

  api.nvim_create_autocmd(event, opts)
end

M.create_user_command = function(opts)
  local name = opts.name
  local cmd = opts.command

  opts.name = nil
  opts.command = nil

  api.nvim_create_user_command(name, cmd, opts)
end

M.set_keymap = function(opts)
  local mode = opts.mode
  local keys = opts.keys
  local command = opts.command

  opts.mode = nil
  opts.keys = nil
  opts.command = nil

  vim.keymap.set(mode, keys, command, opts)
end

return M
