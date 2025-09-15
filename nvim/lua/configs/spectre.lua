local spectre = require 'spectre'

spectre.setup {
  result_padding = '',
  default = {
    replace = {
      cmd = 'sed',
    },
  },
}

vim.keymap.set('n', '<leader>S', function() spectre.toggle() end, { desc = 'Toggle [S]pectre' })
vim.keymap.set('n', '<leader>sw', function() spectre.open_visual { select_word = true } end, { desc = '[S]earch current [w]ord' })
vim.keymap.set('v', '<leader>sw', function() spectre.open_visual() end, { desc = '[S]earch current [w]ord' })
