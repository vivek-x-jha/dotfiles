local gs = require 'gitsigns'
local signs = {
  add = { text = '+' },
  change = { text = '~' },
  delete = { text = 'x' },
  topdelete = { text = 'x' },
  changedelete = { text = 'x' },
  untracked = { text = '?' },
}

gs.setup { signs = signs, signs_staged = signs }

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, { callback = function(args) gs.attach(args.buf) end })

vim.keymap.set('n', '<leader>gb', function() gs.toggle_current_line_blame() end, { desc = 'Toggle [g]itsigns current line [b]lame' })
