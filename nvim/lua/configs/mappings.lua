local key = vim.keymap
local buf = require 'ui.buffers'
local term = require 'ui.terminal'

-- Command mode
key.set('n', ';', ':', { desc = 'CMD enter command mode' })
key.set('n', '<Esc>', '<cmd>noh<CR>', { desc = 'Clear highlights' })

-- Save and Copy
key.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>', { desc = '[s]ave file' })
key.set('n', '<C-c>', '<cmd>%y+<CR>', { desc = '[C]opy file' })

-- Toggle line numbers
key.set('n', '<leader>n', '<cmd>set nu!<CR>', { desc = 'Toggle line number' })
key.set('n', '<leader>rn', '<cmd>set rnu!<CR>', { desc = 'Toggle relative number' })

-- Comments
key.set('n', '<leader>/', 'gcc', { desc = 'Toggle comment', remap = true })
key.set('v', '<leader>/', 'gc', { desc = 'Toggle comment', remap = true })

-- Indentation
key.set('v', '<Tab>', '>gv', { desc = 'Indent selection' })
key.set('v', '<S-Tab>', '<gv', { desc = 'Outdent selection' })

-- Insert mode navigation
key.set('i', '<C-b>', '<ESC>I', { desc = 'Move [b]eginning of line' })
key.set('i', '<C-e>', '<End>', { desc = 'Move [e]nd of line' })
key.set('i', '<C-h>', '<Left>', { desc = 'Move left' })
key.set('i', '<C-l>', '<Right>', { desc = 'Move right' })
key.set('i', '<C-j>', '<Down>', { desc = 'Move down' })
key.set('i', '<C-k>', '<Up>', { desc = 'Move up' })

-- Scrolling
-- TODO fix scrolling move line up/down
key.set('n', '<C-d>', '<C-d>zz', { desc = 'Page [d]own and center' })
key.set('n', '<C-u>', '<C-u>zz', { desc = 'Page [u]p and center' })

-- Moving selections
key.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
key.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Sessions
key.set('n', '<leader>ob', '<cmd>Obsession<CR>', { desc = 'Toggle [ob]session' })
key.set('n', '<leader>oo', function()
  vim.cmd 'silent! Obsession'
  vim.cmd 'silent! Obsession'
  vim.notify('Updating workspace state: Session.vim', vim.log.levels.INFO)
end, { desc = 'Save workspace config' })

-- Buffers
key.set('n', '<leader>b', '<cmd>enew<CR>', { desc = 'Open [b]uffer' })
key.set('n', '<tab>', buf.next, { desc = 'Next buffer' })
key.set('n', '<S-tab>', buf.prev, { desc = 'Prev buffer' })
key.set('n', '<leader>x', buf.close, { desc = 'Close buffer' })

-- NvimTree
key.set('n', '<C-n>', function()
  require('nvim-tree.api').tree.toggle { focus = false }
  vim.cmd 'wincmd ='
end, { desc = 'Toggle file explorer' })

key.set('n', '<leader>e', function()
  require('nvim-tree.api').tree.open()
  vim.cmd 'wincmd ='
end, { desc = 'Focus file [e]xplorer' })

-- Terminal
key.set('t', '<C-x>', '<C-\\><C-N>', { desc = 'Escape terminal mode' })

key.set('n', '<leader>h', function() term.open { pos = 'sp' } end, { desc = 'Open [h]orizontal terminal' })
key.set('n', '<leader>v', function() term.open { pos = 'vsp' } end, { desc = 'Open [v]ertical terminal' })

key.set({ 'n', 't' }, '<A-v>', function() term.toggle { pos = 'vsp', id = 'vtoggleTerm' } end, { desc = 'Toggle [v]ertical terminal' })
key.set({ 'n', 't' }, '<A-h>', function() term.toggle { pos = 'sp', id = 'htoggleTerm' } end, { desc = 'Toggle [h]orizontal terminal' })
key.set({ 'n', 't' }, '<A-i>', function() term.toggle { pos = 'float', id = 'floatTerm' } end, { desc = 'Toggle [f]loating terminal' })

-- Telescope
key.set('n', '<leader>cm', '<cmd>Telescope git_commits<CR>', { desc = 'Telescope git [c]o[m]mits' })
key.set('n', '<leader>fa', '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>', { desc = 'Telescope [f]ind [a]ll files' })
key.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'Telescope [f]ind [b]uffers' })
key.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'Telescope [f]ind [f]iles' })
key.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = 'Telescope [h]elp page' })
key.set('n', '<leader>fo', '<cmd>Telescope oldfiles<CR>', { desc = 'Telescope [f]ind [o]ldfiles' })
key.set('n', '<leader>fw', '<cmd>Telescope live_grep<CR>', { desc = 'Telescope [f]ind [w]ord' })
key.set('n', '<leader>fz', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { desc = 'Telescope [f]u[z]zy find in current buffer' })
key.set('n', '<leader>gt', '<cmd>Telescope git_status<CR>', { desc = 'Telescope [g]it s[t]atus' })
key.set('n', '<leader>ma', '<cmd>Telescope marks<CR>', { desc = 'Telescope [m]arks' })
key.set('n', '<leader>pt', '<cmd>Telescope terms<CR>', { desc = 'Telescope [p]ick [t]erm' })

-- LSP
key.set('n', '<leader>ds', vim.diagnostic.setloclist, { desc = 'LSP diagnostic loclist' })

-- WhichKey
key.set('n', '<leader>wK', '<cmd>WhichKey <CR>', { desc = 'Toggle all [w]hichkey [K]eymaps' })
key.set('n', '<leader>wk', function() vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ') end, { desc = 'Search [w]hich[k]ey' })

-- Showkeys
key.set('n', '<leader>sk', '<cmd>ShowkeysToggle<CR>', { desc = 'Toggle [s]how[k]eys' })

-- Conform
key.set('n', '<leader>fm', function() require('conform').format { lsp_fallback = true } end, { desc = '[f]or[m]at file with linter' })
