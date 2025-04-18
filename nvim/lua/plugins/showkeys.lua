-- https://github.com/nvzone/showkeys
return {
  {
    'nvzone/showkeys',
    cmd = { 'ShowkeysToggle' },
    opts = {
      -- :h nvim_open_win params
      winopts = {
        focusable = false,
        relative = 'editor',
        style = 'minimal',
        height = 1,
        row = 1,
        col = 0,
      },

      timeout = 3, -- in secs
      maxkeys = 3,
      show_count = false,
      excluded_modes = { 'i' },
      position = 'bottom-right',

      keyformat = {
        ['<BS>'] = '󰭜 ',
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
    },
  },
}
