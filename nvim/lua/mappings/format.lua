local map = vim.keymap.set
local conform = require 'conform'

-- format with conform
map('n', '<leader>fm', function()
  conform.format { lsp_fallback = true }
end, { desc = 'general format file' })
