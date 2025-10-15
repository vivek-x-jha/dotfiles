require('conform').setup {
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'fallback',
  },

  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff' },
    bash = { 'shfmt' },
    zsh = { 'shfmt' },
    sh = { 'shfmt' },
  },
}

require('ibl').setup {
  indent = {
    char = '┊',
  },
}
