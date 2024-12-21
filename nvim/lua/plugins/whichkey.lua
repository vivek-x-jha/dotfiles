-- https://github.com/folke/which-key.nvim
-- TODO create standardized groups and icons (mostly in mappings)
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  keys = { '<leader>', '<c-w>', '"', "'", '`', 'c', 'v', 'g' },
  cmd = 'WhichKey',
  opts = {
    preset = 'modern',
  },
}
