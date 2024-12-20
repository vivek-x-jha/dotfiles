-- https://github.com/stevearc/conform.nvim
return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  opts = {
    formatters_by_ft = {
      lua = {
        'stylua',
        -- extra_args = {
        --   '--call-parentheses=none', -- Prevents Stylua from wrapping arguments in parentheses
        --   '--column-width=0', -- Disables wrapping entirely
        -- },
      },
      -- css = { 'prettier' },
      -- html = { 'prettier' },
    },

    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
  },
}
