local icons = require 'ui.icons'

return {
  -- https://github.com/lewis6991/gitsigns.nvim
  {
    'lewis6991/gitsigns.nvim',
    event = 'User FilePost',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '-' },
        topdelete = { text = '‾' },
        changedelete = { text = '/' },
        untracked = { text = '?' },
      },
    },
  },

  -- https://github.com/nvim-tree/nvim-web-devicons
  {
    'nvim-tree/nvim-web-devicons',
    opts = {
      override = {
        default_icon = { icon = icons.completions.File, name = 'Default' },
        js = { icon = icons.javascript, name = 'js' },
        ts = { icon = icons.typescript, name = 'ts' },
        lock = { icon = icons.lock, name = 'lock' },
        ['robots.txt'] = { icon = icons.robot, name = 'robots' },
      },
    },
  },

  -- https://github.com/nvim-treesitter/nvim-treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'fish',
        'lua',
        'luadoc',
        'markdown',
        'printf',
        'toml',
        'vim',
        'vimdoc',
        'yaml',
      },

      highlight = {
        enable = true,
        use_languagetree = true,
      },

      indent = { enable = true },
    },
  },
}
