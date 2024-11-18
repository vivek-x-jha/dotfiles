require 'mappings.format'
require 'mappings.keymeta'
require 'mappings.lsp'
require 'mappings.navigation'
require 'mappings.search'
require 'mappings.workspace'

local map = vim.keymap.set

-- command line with ;
map('n', ';', ':', { desc = 'CMD enter command mode' })

-- clear highlights
map('n', '<Esc>', '<cmd>noh<CR>', { desc = 'general clear highlights' })

-- save in any mode
map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>', { desc = 'general save file' })

-- copy file
map('n', '<C-c>', '<cmd>%y+<CR>', { desc = 'general copy whole file' })

-- line numbers
map('n', '<leader>n', '<cmd>set nu!<CR>', { desc = 'toggle line number' })
map('n', '<leader>rn', '<cmd>set rnu!<CR>', { desc = 'toggle relative number' })

-- comment
map('n', '<leader>/', 'gcc', { desc = 'toggle comment', remap = true })
map('v', '<leader>/', 'gc', { desc = 'toggle comment', remap = true })
