-- local tbl = require 'ui.tabufline'
local term = require 'ui.terminal'

local map = function(mode, lhs, rhs, desc, remap) vim.keymap.set(mode, lhs, rhs, { desc = desc, remap = remap or false }) end

--------------------------- general -------------------------------------------

map('n', ';', ':', 'CMD enter command mode')

map('n', '<Esc>', '<cmd>noh<CR>', 'general clear highlights')
map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>', 'general save file')
map('n', '<C-c>', '<cmd>%y+<CR>', 'general copy whole file')

map('n', '<leader>n', '<cmd>set nu!<CR>', 'toggle line number')
map('n', '<leader>rn', '<cmd>set rnu!<CR>', 'toggle relative number')
map('n', '<leader>/', 'gcc', 'toggle comment', true)
map('v', '<leader>/', 'gc', 'toggle comment', true)

--------------------------- workspace -----------------------------------------

-- obsession
map('n', '<leader>ob', '<cmd>Obsession<CR>', 'Toggle Obsession session')
map('n', '<leader>oo', function()
	vim.cmd 'silent! Obsession'
	vim.cmd 'silent! Obsession'
	vim.notify('Restarting session in Session.vim', vim.log.levels.INFO)
end, 'Restart Obsession session')

-- tabufline
map('n', '<leader>b', '<cmd>enew<CR>', 'buffer new')
-- map('n', '<tab>', tbl.next, 'Buffer goto next')
-- map('n', '<S-tab>', tbl.prev, 'Buffer goto prev')
-- map('n', '<leader>x', tbl.close_buffer, 'Buffer close')

-- nvimtree
map('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', 'nvimtree toggle window')
map('n', '<leader>e', '<cmd>NvimTreeFocus<CR>', 'nvimtree focus window')

-- terminal
map('t', '<C-x>', '<C-\\><C-N>', 'terminal escape terminal mode')

map('n', '<leader>h', function() term.new { pos = 'sp' } end, 'terminal new horizontal term')
map('n', '<leader>v', function() term.new { pos = 'vsp' } end, 'terminal new vertical term')

map({ 'n', 't' }, '<A-v>', function() term.toggle { pos = 'vsp', id = 'vtoggleTerm' } end, 'terminal toggleable vertical term')
map({ 'n', 't' }, '<A-h>', function() term.toggle { pos = 'sp', id = 'htoggleTerm' } end, 'terminal toggleable horizontal term')
map({ 'n', 't' }, '<A-i>', function() term.toggle { pos = 'float', id = 'floatTerm' } end, 'terminal toggle floating term')

--------------------------- search --------------------------------------------

-- telescope
map('n', '<leader>cm', '<cmd>Telescope git_commits<CR>', 'telescope git commits')
map('n', '<leader>fa', '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>', 'telescope find all files')
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', 'telescope find buffers')
map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', 'telescope find files')
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', 'telescope help page')
map('n', '<leader>fo', '<cmd>Telescope oldfiles<CR>', 'telescope find oldfiles')
map('n', '<leader>fw', '<cmd>Telescope live_grep<CR>', 'telescope live grep')
map('n', '<leader>fz', '<cmd>Telescope current_buffer_fuzzy_find<CR>', 'telescope find in current buffer')
map('n', '<leader>gt', '<cmd>Telescope git_status<CR>', 'telescope git status')
map('n', '<leader>ma', '<cmd>Telescope marks<CR>', 'telescope find marks')
map('n', '<leader>pt', '<cmd>Telescope terms<CR>', 'telescope pick hidden term')

--------------------------- navigation ----------------------------------------

-- insert mode
map('i', '<C-b>', '<ESC>^i', 'move beginning of line')
map('i', '<C-e>', '<End>', 'move end of line')
map('i', '<C-h>', '<Left>', 'move left')
map('i', '<C-l>', '<Right>', 'move right')
map('i', '<C-j>', '<Down>', 'move down')
map('i', '<C-k>', '<Up>', 'move up')

--------------------------- lsp -----------------------------------------------

-- global lsp mappings
map('n', '<leader>ds', vim.diagnostic.setloclist, 'LSP diagnostic loclist')

--------------------------- keymeta -------------------------------------------

-- cheatsheet
map('n', '<leader>ch', '<cmd>NvCheatsheet<CR>', 'toggle nvcheatsheet')

-- whichkey
map('n', '<leader>wK', '<cmd>WhichKey <CR>', 'whichkey all keymaps')
map('n', '<leader>wk', function() vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ') end, 'whichkey query lookup')

-- showkey
map('n', '<leader>sk', '<cmd>ShowkeysToggle<CR>', 'Toggle Showkeys')

--------------------------- format --------------------------------------------

-- conform
map('n', '<leader>fm', function() require('conform').format { lsp_fallback = true } end, 'general format file')
