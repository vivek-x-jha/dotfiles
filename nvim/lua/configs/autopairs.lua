vim.pack.add { 'https://github.com/windwp/nvim-autopairs' }

require('nvim-autopairs').setup {
  fast_wrap = {},
  disable_filetype = { 'vim' },
}
