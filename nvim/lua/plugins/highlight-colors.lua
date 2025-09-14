vim.pack.add { 'https://github.com/brenoprata10/nvim-highlight-colors' }

local icn = require('icons')

require('nvim-highlight-colors').setup {
  render = 'virtual',
  virtual_symbol = icn.virtual_block,
}
