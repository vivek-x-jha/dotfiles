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
