require('utils.ui').set_base46 'treesitter'

return {
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
}
