-- format with conform
vim.keymap.set('n', '<leader>fm', function()
  require('conform').format { lsp_fallback = true }
end, { desc = 'general format file' })
