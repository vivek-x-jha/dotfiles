-- https://github.com/nvim-treesitter/nvim-treesitter
return {
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
}
