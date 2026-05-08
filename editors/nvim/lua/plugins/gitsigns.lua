local icons = require 'ui.icons'

local signs = {
  add = { text = icons.git_added },
  change = { text = icons.git_changed },
  delete = { text = icons.git_deleted },
  topdelete = { text = icons.git_deleted },
  changedelete = { text = icons.git_deleted },
  untracked = { text = icons.git_untracked },
}

--- @param direction 'next'|'prev'
local cycle_hunk = function(direction)
  if vim.wo.diff then return direction == 'next' and ']c' or '[c' end
  vim.schedule(package.loaded.gitsigns[direction .. '_hunk'])
  return '<Ignore>'
end

local next_hunk = function() return cycle_hunk 'next' end
local prev_hunk = function() return cycle_hunk 'prev' end

require('gitsigns').setup {
  signs = signs,
  signs_staged = signs,

  on_attach = function(bufnr)
    vim.keymap.set('n', ']c', next_hunk, { buffer = bufnr, expr = true, desc = 'Git: next_hunk' })
    vim.keymap.set('n', '[c', prev_hunk, { buffer = bufnr, expr = true, desc = 'Git: prev_hunk' })
  end,
}
