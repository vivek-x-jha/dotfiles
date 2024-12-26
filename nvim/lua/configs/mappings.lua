-- TODO standardize keymap descriptions
-- TODO fix scrolling move line up/down
local buf = require 'ui.buffers'
local term = require 'ui.terminal'

local remap = function(mode, keys, action, desc, remap)
  local opts = { desc = desc, remap = remap or false }
  vim.keymap.set(mode, keys, action, opts)
end

remap('n', ';', ':', 'CMD enter command mode')

remap('n', '<Esc>', '<cmd>noh<CR>', 'Clear highlights')
remap({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>', '[s]ave file')
remap('n', '<C-c>', '<cmd>%y+<CR>', '[C]opy file')

remap('n', '<leader>n', '<cmd>set nu!<CR>', 'Toggle line number')
remap('n', '<leader>rn', '<cmd>set rnu!<CR>', 'Toggle relative number')
remap('n', '<leader>/', 'gcc', 'Toggle comment', true)
remap('v', '<leader>/', 'gc', 'Toggle comment', true)
remap('v', '<Tab>', '>gv', 'Indent selection')
remap('v', '<S-Tab>', '<gv', 'Outdent selection')

-- insert mode
remap('i', '<C-b>', '<ESC>I', 'Move [b]eginning of line')
remap('i', '<C-e>', '<End>', 'Move [e]nd of line')
remap('i', '<C-h>', '<Left>', 'Move left')
remap('i', '<C-l>', '<Right>', 'Move right')
remap('i', '<C-j>', '<Down>', 'Move down')
remap('i', '<C-k>', '<Up>', 'Move up')

-- scrolling
remap('n', '<C-d>', '<C-d>zz', 'Page [d]own and center')
remap('n', '<C-u>', '<C-u>zz', 'Page [u]p and center')

remap('v', 'J', ":m '>+1<CR>gv=gv", 'Move selection down')
remap('v', 'K', ":m '<-2<CR>gv=gv", 'Move selection up')

-- obsession
remap('n', '<leader>ob', '<cmd>Obsession<CR>', 'Toggle [ob]session')
remap('n', '<leader>oo', function()
  vim.cmd 'silent! Obsession'
  vim.cmd 'silent! Obsession'
  vim.notify('Updating workspace state: Session.vim', vim.log.levels.INFO)
end, 'Save workspace config')

-- buffers
remap('n', '<leader>b', '<cmd>enew<CR>', 'Open [b]uffer')
remap('n', '<tab>', buf.next, 'Next buffer')
remap('n', '<S-tab>', buf.prev, 'Prev buffer')
remap('n', '<leader>x', buf.close, 'Close buffer')

-- nvimtree
remap('n', '<C-n>', function()
  require('nvim-tree.api').tree.toggle { focus = false }
  vim.cmd 'wincmd ='
end, 'Toggle file explorer')

remap('n', '<leader>e', function()
  require('nvim-tree.api').tree.open()
  vim.cmd 'wincmd ='
end, 'Focus file [e]xplorer')

-- terminal
remap('t', '<C-x>', '<C-\\><C-N>', 'Escape terminal mode')

remap('n', '<leader>h', function() term.open { pos = 'sp' } end, 'Open [h]orizontal terminal')
remap('n', '<leader>v', function() term.open { pos = 'vsp' } end, 'Open [v]ertical terminal')

remap({ 'n', 't' }, '<A-v>', function() term.toggle { pos = 'vsp', id = 'vtoggleTerm' } end, 'Toggle [v]ertical terminal')
remap({ 'n', 't' }, '<A-h>', function() term.toggle { pos = 'sp', id = 'htoggleTerm' } end, 'Toggle [h]orizontal terminal')
remap({ 'n', 't' }, '<A-i>', function() term.toggle { pos = 'float', id = 'floatTerm' } end, 'Toggle [f]loating terminal')

-- telescope
remap('n', '<leader>cm', '<cmd>Telescope git_commits<CR>', 'Telescope git [c]o[m]mits')
remap('n', '<leader>fa', '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>', 'Telescope [f]ind [a]ll files')
remap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', 'Telescope [f]ind [b]uffers')
remap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', 'Telescope [f]ind [f]iles')
remap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', 'Telescope [h]elp page')
remap('n', '<leader>fo', '<cmd>Telescope oldfiles<CR>', 'Telescope [f]ind [o]ldfiles')
remap('n', '<leader>fw', '<cmd>Telescope live_grep<CR>', 'Telescope [f]ind [w]ord')
remap('n', '<leader>fz', '<cmd>Telescope current_buffer_fuzzy_find<CR>', 'Telescope [f]u[z]zy find in current buffer')
remap('n', '<leader>gt', '<cmd>Telescope git_status<CR>', 'Telescope [g]it s[t]atus')
remap('n', '<leader>ma', '<cmd>Telescope marks<CR>', 'Telescope [m]arks')
remap('n', '<leader>pt', '<cmd>Telescope terms<CR>', 'Telescope [p]ick [t]erm')

-- global lsp remappings
remap('n', '<leader>ds', vim.diagnostic.setloclist, 'LSP diagnostic loclist')

-- whichkey
remap('n', '<leader>wK', '<cmd>WhichKey <CR>', 'Toggle all [w]hichkey [K]eymaps')
remap('n', '<leader>wk', function() vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ') end, 'Search [w]hich[k]ey')

-- showkey
remap('n', '<leader>sk', '<cmd>ShowkeysToggle<CR>', 'Toggle [s]how[k]eys')

-- conform
remap('n', '<leader>fm', function() require('conform').format { lsp_fallback = true } end, '[f]or[m]at file with linter')

-- spectre
remap('n', '<leader>S', '<cmd>SpectreToggle<CR>', 'Toggle [S]earch & Replace')
remap({ 'n', 'v' }, '<leader>sw', '<cmd>SpectreCurrWord<CR>', '[s]earch current [w]ord')
remap('n', '<leader>sf', '<cmd>SpectreCurrFile<CR>', '[s]earch current word & [f]ile')
