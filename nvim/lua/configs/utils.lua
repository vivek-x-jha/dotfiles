local M = {}
local api = vim.api

M.create_autocmd = function(opts)
  local event = opts.event
  opts.event = nil
  api.nvim_create_autocmd(event, opts)
end

M.create_augroup = function(name, clear)
  local opts = {}
  if clear == false then opts = { clear = false } end
  return api.nvim_create_augroup(name, opts)
end

M.set_keymap = function(opts)
  local options = { desc = opts.desc }
  if opts.remap then options.remap = true end
  vim.keymap.set(opts.mode, opts.keys, opts.command, options)
end

M.create_user_command = function(opts)
  local options = { desc = opts.desc }
  api.nvim_create_user_command(opts.name, opts.command, options)
end

return M
