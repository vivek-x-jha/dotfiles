-- TODO standardize keymap descriptions
local buf = require 'ui.buffers'
local term = require 'ui.terminal'

local map = function(mode, keys, action, desc, remap)
  local opts = { desc = desc, remap = remap or false }
  vim.keymap.set(mode, keys, action, opts)
end

map('n', ';', ':', 'CMD enter command mode')

map('n', '<Esc>', '<cmd>noh<CR>', 'Clear highlights')
map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>', '[s]ave file')
map('n', '<C-c>', '<cmd>%y+<CR>', '[C]opy file')

map('n', '<leader>n', '<cmd>set nu!<CR>', 'Toggle line number')
map('n', '<leader>rn', '<cmd>set rnu!<CR>', 'Toggle relative number')
map('n', '<leader>/', 'gcc', 'Toggle comment', true)
map('v', '<leader>/', 'gc', 'Toggle comment', true)

-- scrolling
map('n', '<C-d>', '<C-d>zz', 'Page [d]own and center')
map('n', '<C-u>', '<C-u>zz', 'Page [u]p and center')

map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

-- obsession
map('n', '<leader>ob', '<cmd>Obsession<CR>', 'Toggle [ob]session')
map('n', '<leader>oo', function()
  vim.cmd 'silent! Obsession'
  vim.cmd 'silent! Obsession'
  vim.notify('Updating workspace state: Session.vim', vim.log.levels.INFO)
end, 'Save workspace config')

-- buffers
map('n', '<leader>b', '<cmd>enew<CR>', 'Open [b]uffer')
map('n', '<tab>', buf.next, 'Next buffer')
map('n', '<S-tab>', buf.prev, 'Prev buffer')
map('n', '<leader>x', buf.close, 'Close buffer')

-- nvimtree
map('n', '<C-n>', function()
  require('nvim-tree.api').tree.toggle { focus = false }
  vim.cmd 'wincmd ='
end, 'Toggle file explorer')

map('n', '<leader>e', function()
  require('nvim-tree.api').tree.open()
  vim.cmd 'wincmd ='
end, 'Focus file [e]xplorer')

-- terminal
map('t', '<C-x>', '<C-\\><C-N>', 'Escape terminal mode')

map('n', '<leader>h', function() term.open { pos = 'sp' } end, 'Open [h]orizontal terminal')
map('n', '<leader>v', function() term.open { pos = 'vsp' } end, 'Open [v]ertical terminal')

map({ 'n', 't' }, '<A-v>', function() term.toggle { pos = 'vsp', id = 'vtoggleTerm' } end, 'Toggle [v]ertical terminal')
map({ 'n', 't' }, '<A-h>', function() term.toggle { pos = 'sp', id = 'htoggleTerm' } end, 'Toggle [h]orizontal terminal')
map({ 'n', 't' }, '<A-i>', function() term.toggle { pos = 'float', id = 'floatTerm' } end, 'Toggle [f]loating terminal')

-- telescope
map('n', '<leader>cm', '<cmd>Telescope git_commits<CR>', 'Telescope git [c]o[m]mits')
map('n', '<leader>fa', '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>', 'Telescope [f]ind [a]ll files')
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', 'Telescope [f]ind [b]uffers')
map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', 'Telescope [f]ind [f]iles')
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', 'Telescope [h]elp page')
map('n', '<leader>fo', '<cmd>Telescope oldfiles<CR>', 'Telescope [f]ind [o]ldfiles')
map('n', '<leader>fw', '<cmd>Telescope live_grep<CR>', 'Telescope [f]ind [w]ord')
map('n', '<leader>fz', '<cmd>Telescope current_buffer_fuzzy_find<CR>', 'Telescope [f]u[z]zy find in current buffer')
map('n', '<leader>gt', '<cmd>Telescope git_status<CR>', 'Telescope [g]it s[t]atus')
map('n', '<leader>ma', '<cmd>Telescope marks<CR>', 'Telescope [m]arks')
map('n', '<leader>pt', '<cmd>Telescope terms<CR>', 'Telescope [p]ick [t]erm')

-- insert mode
map('i', '<C-b>', '<ESC>I', 'Move [b]eginning of line')
map('i', '<C-e>', '<End>', 'Move [e]nd of line')
map('i', '<C-h>', '<Left>', 'Move left')
map('i', '<C-l>', '<Right>', 'Move right')
map('i', '<C-j>', '<Down>', 'Move down')
map('i', '<C-k>', '<Up>', 'Move up')

-- global lsp mappings
map('n', '<leader>ds', vim.diagnostic.setloclist, 'LSP diagnostic loclist')

-- whichkey
map('n', '<leader>wK', '<cmd>WhichKey <CR>', 'Toggle all [w]hichkey [K]eymaps')
map('n', '<leader>wk', function() vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ') end, 'Search [w]hich[k]ey')

-- showkey
map('n', '<leader>sk', '<cmd>ShowkeysToggle<CR>', 'Toggle [s]how[k]eys')

-- conform
map('n', '<leader>fm', function() require('conform').format { lsp_fallback = true } end, '[f]or[m]at file with linter')

-- spectre
map('n', '<leader>S', '<cmd>SpectreToggle<CR>', 'Toggle [S]earch & Replace')
map({ 'n', 'v' }, '<leader>sw', '<cmd>SpectreCurrWord<CR>', '[s]earch current [w]ord')
map('n', '<leader>sf', '<cmd>SpectreCurrFile<CR>', '[s]earch current word & [f]ile')
