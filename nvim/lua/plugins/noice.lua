-- https://github.com/folke/noice.nvim
-- TODO update colorscheme

return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
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
  },
}
