require('conform').setup {
  format_on_save = {
    timeout_ms = 2000,
    lsp_fallback = true,
  },

  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff_format', 'ruff_organize_imports' },
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
