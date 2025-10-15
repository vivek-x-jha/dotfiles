vim.notify = require 'notify'

vim.notify.setup {
  background_colour = os.getenv 'WEZTERM_BG_HEX',
  fps = 60,
  stages = 'fade',
}

require('noice').setup {
  presets = {
    command_palette = true,
    long_message_to_split = true,
  },

  lsp = {
    signature = {
      enabled = false,
    },

    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
  },
}
