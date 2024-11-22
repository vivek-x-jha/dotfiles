return {
  -- :h nvim_open_win params
  winopts = {
    focusable = false,
    relative = 'editor',
    style = 'minimal',
    border = 'single',
    height = 1,
    row = 1,
    col = 0,
  },

  timeout = 3, -- in secs
  maxkeys = 3,
  show_count = false,
  excluded_modes = {}, -- example: {"i"}

  -- bottom-left, bottom-right, bottom-center, top-left, top-right, top-center
  position = 'bottom-right',

  keyformat = {
    ['<BS>'] = '󰁮 ',
    ['<CR>'] = '󰘌',
    ['<Space>'] = '󱁐',
    ['<Up>'] = '󰁝',
    ['<Down>'] = '󰁅',
    ['<Left>'] = '󰁍',
    ['<Right>'] = '󰁔',
    ['<PageUp>'] = 'Page 󰁝',
    ['<PageDown>'] = 'Page 󰁅',
    ['<M>'] = 'Alt',
    ['<C>'] = 'Ctrl',
  },
}