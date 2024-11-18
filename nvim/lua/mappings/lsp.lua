local map = vim.keymap.set
local diag = vim.diagnostic

-- global lsp mappings
map('n', '<leader>ds', diag.setloclist, { desc = 'LSP diagnostic loclist' })
