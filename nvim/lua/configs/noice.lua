require('nvim-treesitter.configs').setup {
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

require('notify').setup {
  background_colour = '#000000',
  fps = 60,
  stages = 'fade',
}
vim.notify = require 'notify'

require('noice').setup {
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
    signature = { enabled = false },
  },
  presets = {
    command_palette = true,
    long_message_to_split = true,
  },
}
