-- https://github.com/lukas-reineke/indent-blankline.nvim
return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'User FilePost',
  main = 'ibl',
  opts = { indent = { char = '┊' } },
}
