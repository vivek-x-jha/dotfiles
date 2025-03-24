-- https://github.com/lewis6991/gitsigns.nvim

return {
  'lewis6991/gitsigns.nvim',
  event = 'User FilePost',
  opts = {
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
  },
}
