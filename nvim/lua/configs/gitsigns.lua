vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }

require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = 'x' },
    topdelete = { text = 'x' },
    changedelete = { text = 'x' },
    untracked = { text = '?' },
  },
  signs_staged = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = 'x' },
    topdelete = { text = 'x' },
    changedelete = { text = 'x' },
    untracked = { text = '?' },
  },
}

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  callback = function(args)
    require('gitsigns').attach(args.buf)
  end,
})

vim.keymap.set('n', '<leader>gb', '<cmd>Gitsigns toggle_current_line_blame<CR>', { desc = 'Toggle [g]itsigns current line [b]lame' })
