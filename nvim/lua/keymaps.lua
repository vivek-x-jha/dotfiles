-- Open picker
vim.keymap.set('n', '<leader>ff', function() require('fzf-lua').files() end, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fo', function() require('fzf-lua').oldfiles() end, { desc = '[R]ecent [B]uffers' })
vim.keymap.set('n', '<leader>fa', function() require('fzf-lua').autocmds() end, { desc = '[F]ind Neovim [A]uto-commands' })
vim.keymap.set('n', '<leader>fw', function() require('fzf-lua').live_grep() end, { desc = '[F]ind [W]ord' })
vim.keymap.set('n', '<leader>fc', function() require('fzf-lua').command_history() end, { desc = '[F]ind [C]ommands' })
vim.keymap.set('n', '<leader>fb', function() require('fzf-lua').buffers() end, { desc = '[F]ind [B]uffers' })
vim.keymap.set('n', '<leader>fn', function() require('fzf-lua').commands() end, { desc = '[F]ind Neovim [C]ommands' })
vim.keymap.set('n', '<leader>fg', function() require('fzf-lua').git_files() end, { desc = '[F]ind [G]it Files' })
vim.keymap.set('n', '<leader>glg', function() require('fzf-lua').git_commits() end, { desc = '[G]it [L]og Graph' })
vim.keymap.set('n', '<leader>gst', function() require('fzf-lua').git_status() end, { desc = '[G]it [St]atus' })
vim.keymap.set('n', '<leader>gsw', function() require('fzf-lua').git_branches() end, { desc = '[G]it [S]witch' })

-- Toggle git blame
vim.keymap.set('n', '<leader>gb', function() require('gitsigns').toggle_current_line_blame() end, { desc = 'Toggle [g]it [b]lame' })

-- Toggle search and replace
vim.keymap.set('n', '<leader>S', function() require('spectre').toggle() end, { desc = 'Toggle [S]pectre' })
vim.keymap.set('n', '<leader>sw', function() require('spectre').open_visual { select_word = true } end, { desc = '[S]earch current [w]ord' })
vim.keymap.set('v', '<leader>sw', function() require('spectre').open_visual() end, { desc = '[S]earch current [w]ord' })

-- Toggle File Explorer
vim.keymap.set('n', '<C-n>', function() require('nvim-tree.api').tree.toggle { focus = false } end, { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<leader>e', function() require('nvim-tree.api').tree.open() end, { desc = 'Focus file [e]xplorer' })

-- Dismiss notifications
vim.keymap.set('n', '<leader>nd', function() require('noice').cmd 'dismiss' end, { desc = 'Clear notifications' })

------------------------------------ Local Hotkeys ------------------------------------

-- Open command line
vim.keymap.set('n', ';', ':', { desc = 'Enter CMD mode w/o <Shift>' })

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
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>write<CR>', { desc = '[S]ave file' })
vim.keymap.set('n', '<leader>rr', '<cmd>restart<CR>', { desc = 'Reinitialize Neovim' })
vim.keymap.set('n', '<leader>oo', function()
  vim.cmd 'silent! mksession! Session.vim'
  vim.notify('Updating workspace state: Session.vim', vim.log.levels.INFO)
end, { desc = 'Save workspace config' })

-- Buffers
vim.keymap.set('n', '<leader>b', '<cmd>enew<CR>', { desc = 'Open [b]uffer' })
vim.keymap.set('n', '<leader>x', '<cmd>bdelete<CR>', { desc = 'Close buffer' })
vim.keymap.set('n', '<C-c>', '<cmd>%y+<CR>', { desc = '[C]opy file' })
vim.keymap.set('n', '<Esc>', '<cmd>noh<CR>', { desc = 'Clear highlights' })

-- Terminal
---@type NvTerminal -- terminal buffer
local terminal = require 'nvim-terminal'

vim.keymap.set('t', '<C-x>', '<C-\\><C-N>', { desc = 'Escape terminal mode' })
vim.keymap.set('n', '<leader>h', function() terminal.open { pos = 'sp' } end, { desc = 'Open [h]orizontal terminal' })
vim.keymap.set('n', '<leader>v', function() terminal.open { pos = 'vsp' } end, { desc = 'Open [v]ertical terminal' })
vim.keymap.set({ 'n', 't' }, '<A-v>', function() terminal.toggle { pos = 'vsp', id = 'vtoggleTerm' } end, { desc = 'Toggle [v]ertical terminal' })
vim.keymap.set({ 'n', 't' }, '<A-h>', function() terminal.toggle { pos = 'sp', id = 'htoggleTerm' } end, { desc = 'Toggle [h]orizontal terminal' })
vim.keymap.set({ 'n', 't' }, '<A-i>', function() terminal.toggle { pos = 'float', id = 'floatTerm' } end, { desc = 'Toggle [f]loating terminal' })

-- LSP
vim.keymap.set('n', '<leader>ds', vim.diagnostic.setloclist, { desc = 'LSP diagnostic loclist' })

-- Dashboard
vim.keymap.set('n', '<leader>da', function() require('nvim-dashboard').setup() end, { desc = 'Toggle Dashboard' })
