return {
  'akinsho/toggleterm.nvim',
  lazy = false,
  version = '*',
  opts = {
    size = 200,
    direction = 'float',
    open_mapping = [[<a-i>]],
    highlights = {
      FloatBorder = {
        link = 'FloatBorder',
      },
    },
    float_opts = {
      border = 'curved',
      title = vim.fn.expand '$SHELL', -- Set terminal title to the shell
      title_pos = 'center', -- Position title in the center      width = math.floor(vim.o.columns * 0.8),
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.6),
      row = math.floor((vim.o.lines - (vim.o.lines * 0.6)) / 2),
      col = math.floor((vim.o.columns - (vim.o.columns * 0.8)) / 2),
    },
  },
}
