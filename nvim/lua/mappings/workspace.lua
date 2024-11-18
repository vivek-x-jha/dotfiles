local map = vim.keymap.set
local tabufline = require 'nvchad.tabufline'
local term = require 'nvchad.term'

-- tabufline
map('n', '<leader>b', '<cmd>enew<CR>', { desc = 'buffer new' })

map('n', '<tab>', function()
  tabufline.next()
end, { desc = 'buffer goto next' })
map('n', '<S-tab>', function()
  tabufline.prev()
end, { desc = 'buffer goto prev' })
map('n', '<leader>x', function()
  tabufline.close_buffer()
end, { desc = 'buffer close' })

-- nvimtree
map('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', { desc = 'nvimtree toggle window' })
map('n', '<leader>e', '<cmd>NvimTreeFocus<CR>', { desc = 'nvimtree focus window' })

-- terminal
map('t', '<C-x>', '<C-\\><C-N>', { desc = 'terminal escape terminal mode' })

map('n', '<leader>h', function()
  term.new { pos = 'sp' }
end, { desc = 'terminal new horizontal term' })
map('n', '<leader>v', function()
  term.new { pos = 'vsp' }
end, { desc = 'terminal new vertical term' })

map({ 'n', 't' }, '<A-v>', function()
  term.toggle { pos = 'vsp', id = 'vtoggleTerm' }
end, { desc = 'terminal toggleable vertical term' })
map({ 'n', 't' }, '<A-h>', function()
  term.toggle { pos = 'sp', id = 'htoggleTerm' }
end, { desc = 'terminal toggleable horizontal term' })
map({ 'n', 't' }, '<A-i>', function()
  term.toggle { pos = 'float', id = 'floatTerm' }
end, { desc = 'terminal toggle floating term' })
