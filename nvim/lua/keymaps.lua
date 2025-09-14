local term = require 'terminal'

-- General mappings
vim.keymap.set('n', ';', ':', { desc = 'Enter CMD mode w/o <Shift>' })
vim.keymap.set('n', '<leader>nd', '<cmd>NoiceDismiss<CR>', { desc = 'Clear notifications' })
vim.keymap.set('n', '<Esc>', '<cmd>noh<CR>', { desc = 'Clear highlights' })
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>', { desc = '[S]ave file' })
vim.keymap.set('n', '<C-c>', '<cmd>%y+<CR>', { desc = '[C]opy file' })

if (vim.version().major > 0) or (vim.version().minor >= 12) then
  vim.keymap.set('n', '<leader>rr', '<cmd>restart<CR>', { desc = 'Reinitialize Neovim' })
end

-- Toggle line numbers
vim.keymap.set('n', '<leader>n', '<cmd>set nu!<CR>', { desc = 'Toggle line number' })
vim.keymap.set('n', '<leader>rn', '<cmd>set rnu!<CR>', { desc = 'Toggle relative number' })

-- Comments
vim.keymap.set('n', '<leader>/', 'gcc', { desc = 'Toggle comment', remap = true })
vim.keymap.set('v', '<leader>/', 'gc', { desc = 'Toggle comment', remap = true })

-- Indentation
vim.keymap.set('v', '<Tab>', '>gv', { desc = 'Indent selection' })
vim.keymap.set('v', '<S-Tab>', '<gv', { desc = 'Outdent selection' })

-- Insert mode navigation
vim.keymap.set('i', '<C-b>', '<ESC>I', { desc = 'Move [b]eginning of line' })
vim.keymap.set('i', '<C-e>', '<End>', { desc = 'Move [e]nd of line' })
vim.keymap.set('i', '<C-h>', '<Left>', { desc = 'Move left' })
vim.keymap.set('i', '<C-l>', '<Right>', { desc = 'Move right' })
vim.keymap.set('i', '<C-j>', '<Down>', { desc = 'Move down' })
vim.keymap.set('i', '<C-k>', '<Up>', { desc = 'Move up' })

-- Scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Page [d]own and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Page [u]p and center' })
vim.keymap.set('n', 'n', 'nzz', { desc = 'Next search result and center' })
vim.keymap.set('n', 'N', 'Nzz', { desc = 'Previous search result and center' })

-- Moving selections
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Sessions
vim.keymap.set('n', '<leader>oo', function()
  vim.cmd 'silent! mksession! Session.vim'
  vim.notify('Updating workspace state: Session.vim', vim.log.levels.INFO)
end, { desc = 'Save workspace config' })

-- Buffers
vim.keymap.set('n', '<leader>b', '<cmd>enew<CR>', { desc = 'Open [b]uffer' })
vim.keymap.set('n', '<leader>x', '<cmd>bdelete<CR>', { desc = 'Close buffer' })

-- Terminal
vim.keymap.set('t', '<C-x>', '<C-\\><C-N>', { desc = 'Escape terminal mode' })
vim.keymap.set('n', '<leader>h', function() term.open { pos = 'sp' } end, { desc = 'Open [h]orizontal terminal' })
vim.keymap.set('n', '<leader>v', function() term.open { pos = 'vsp' } end, { desc = 'Open [v]ertical terminal' })
vim.keymap.set({ 'n', 't' }, '<A-v>', function() term.toggle { pos = 'vsp', id = 'vtoggleTerm' } end, { desc = 'Toggle [v]ertical terminal' })
vim.keymap.set({ 'n', 't' }, '<A-h>', function() term.toggle { pos = 'sp', id = 'htoggleTerm' } end, { desc = 'Toggle [h]orizontal terminal' })
vim.keymap.set({ 'n', 't' }, '<A-i>', function() term.toggle { pos = 'float', id = 'floatTerm' } end, { desc = 'Toggle [f]loating terminal' })

-- LSP
vim.keymap.set('n', '<leader>ds', vim.diagnostic.setloclist, { desc = 'LSP diagnostic loclist' })

-- Dashboard
vim.keymap.set('n', '<leader>da', function() require('dashboard').setup() end, { desc = 'Toggle Dashboard' })
