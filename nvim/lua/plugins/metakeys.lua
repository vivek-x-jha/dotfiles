return {
  -- https://github.com/folke/which-key.nvim
  -- TODO create standardized groups and icons (mostly in mappings)
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    keys = { '<leader>', '<c-w>', '"', "'", '`', 'c', 'v', 'g' },
    cmd = 'WhichKey',
    opts = {
      preset = 'helix',
      delay = 500,
    },
  },

  -- https://github.com/nvzone/showkeys
  {
    'nvzone/showkeys',
    cmd = { 'ShowkeysToggle' },
    opts = {
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
      excluded_modes = { 'i' },
      position = 'top-right',

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
