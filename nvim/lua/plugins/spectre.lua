vim.pack.add {
  'https://github.com/nvim-pack/nvim-spectre',
  'https://github.com/nvim-lua/plenary.nvim',
}

vim.schedule(function() require('configs.highlights').setup 'spectre' end)

require('spectre').setup {
  result_padding = '',
  default = {
    replace = {
      cmd = 'sed',
    },
  },
}

vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', { desc = 'Toggle [S]pectre' })
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = '[S]earch current [w]ord' })
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = '[S]earch current [w]ord' })
