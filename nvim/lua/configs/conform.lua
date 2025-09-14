require('conform').setup {
  format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },

  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff' },
    bash = { 'shfmt' },
    zsh = { 'shfmt' },
    sh = { 'shfmt' },
  },
}

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(args) require('conform').format { bufnr = args.buf } end,
})

vim.keymap.set('n', '<leader>fm', function() require('conform').format { lsp_fallback = true } end, { desc = '[f]or[m]at file with linter' })
