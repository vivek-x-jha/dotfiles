-- https://github.com/stevearc/conform.nvim
return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      -- python = { 'ruff?' },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
  },
}
