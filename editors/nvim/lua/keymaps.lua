-- [1/18] Open command line
vim.keymap.set('n', ';', ':', { desc = 'Enter CMD mode w/o <Shift>' })

-- [2/18] Toggle line numbers
vim.keymap.set('n', '<leader>n', '<cmd>set nu!<CR>', { desc = 'Toggle line number' })
vim.keymap.set('n', '<leader>rn', '<cmd>set rnu!<CR>', { desc = 'Toggle relative number' })

-- [3/18] Indentation
vim.keymap.set('v', '<Tab>', '>gv', { desc = 'Indent selection' })
vim.keymap.set('v', '<S-Tab>', '<gv', { desc = 'Outdent selection' })

-- [4/18] Insert mode navigation
vim.keymap.set('i', '<C-b>', '<ESC>I', { desc = 'Move [b]eginning of line' })
vim.keymap.set('i', '<C-e>', '<End>', { desc = 'Move [e]nd of line' })
vim.keymap.set('i', '<C-h>', '<Left>', { desc = 'Move left' })
vim.keymap.set('i', '<C-l>', '<Right>', { desc = 'Move right' })
vim.keymap.set('i', '<C-j>', '<Down>', { desc = 'Move down' })
vim.keymap.set('i', '<C-k>', '<Up>', { desc = 'Move up' })

-- [5/18] Scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Page [d]own and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Page [u]p and center' })
vim.keymap.set('n', 'n', 'nzz', { desc = 'Next search result and center' })
vim.keymap.set('n', 'N', 'Nzz', { desc = 'Previous search result and center' })

-- [6/18] Moving selections
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- [7/18] Sessions
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>write<CR>', { desc = '[S]ave file' })
vim.keymap.set('n', '<leader>oo', function() require('workspace').sync_session() end, { desc = 'Save workspace config' })

-- [8/18] Buffers
vim.keymap.set('n', '<leader>b', '<cmd>enew<CR>', { desc = 'Open [b]uffer' })
vim.keymap.set('n', '<leader>x', '<cmd>bdelete<CR>', { desc = 'Close buffer' })
vim.keymap.set('n', '<C-c>', '<cmd>%y+<CR>', { desc = '[C]opy file' })
vim.keymap.set('n', '<Esc>', '<cmd>noh<CR>', { desc = 'Clear highlights' })

-- [9/18] Tabs
vim.keymap.set('n', '<Tab>', '<cmd>tabnext<CR>', { desc = 'Open next tab' })
vim.keymap.set('n', '<S-Tab>', '<cmd>tabprevious<CR>', { desc = 'Open previous tab' })

-- [10/18] Path
vim.keymap.set('n', '<leader>pp', function()
  for _, path in ipairs(vim.opt.runtimepath:get()) do
    print(path)
  end
end, { desc = 'List all packages in PATH' })

-- [11/18] Terminal
local term = require 'ui.terminal'

vim.keymap.set('t', '<C-x>', '<C-\\><C-N>', { desc = 'Escape terminal mode' })
vim.keymap.set('n', '<leader>h', function() term.open { pos = 'sp' } end, { desc = 'Open [h]orizontal terminal' })
vim.keymap.set('n', '<leader>v', function() term.open { pos = 'vsp' } end, { desc = 'Open [v]ertical terminal' })
vim.keymap.set({ 'n', 't' }, '<A-v>', function() term.toggle { pos = 'vsp', id = 'vtoggleTerm' } end, { desc = 'Toggle [v]ertical terminal' })
vim.keymap.set({ 'n', 't' }, '<A-h>', function() term.toggle { pos = 'sp', id = 'htoggleTerm' } end, { desc = 'Toggle [h]orizontal terminal' })
vim.keymap.set({ 'n', 't' }, '<A-i>', function() term.toggle { pos = 'float', id = 'floatTerm' } end, { desc = 'Toggle [f]loating terminal' })

-- [12/18] LSP
vim.keymap.set('n', '<leader>ds', vim.diagnostic.setloclist, { desc = 'LSP diagnostic loclist' })

-- [13/18] Dashboard
vim.keymap.set('n', '<leader>da', function() require('ui.dashboard').setup() end, { desc = 'Toggle Dashboard' })

-- [14/18] Fzf.lua pickers
local fzf = require 'fzf-lua'

vim.keymap.set('n', '<leader>ff', function() fzf.files() end, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fo', function() fzf.oldfiles() end, { desc = '[R]ecent [B]uffers' })
vim.keymap.set('n', '<leader>fa', function() fzf.autocmds() end, { desc = '[F]ind Neovim [A]uto-commands' })
vim.keymap.set('n', '<leader>fw', function() fzf.live_grep() end, { desc = '[F]ind [W]ord' })
vim.keymap.set('n', '<leader>fc', function() fzf.command_history() end, { desc = '[F]ind [C]ommands' })
vim.keymap.set('n', '<leader>fb', function() fzf.buffers() end, { desc = '[F]ind [B]uffers' })
vim.keymap.set('n', '<leader>fn', function() fzf.commands() end, { desc = '[F]ind Neovim [C]ommands' })
vim.keymap.set('n', '<leader>fg', function() fzf.git_files() end, { desc = '[F]ind [G]it Files' })
vim.keymap.set('n', '<leader>glg', function() fzf.git_commits() end, { desc = '[G]it [L]og Graph' })
vim.keymap.set('n', '<leader>gst', function() fzf.git_status() end, { desc = '[G]it [St]atus' })
vim.keymap.set('n', '<leader>gsw', function() fzf.git_branches() end, { desc = '[G]it [S]witch' })

-- [15/18] Fzf.lua custom pickers
local pickers = 'plugins.fzf.pickers.'

vim.keymap.set('n', '<leader>un', function() require(pickers .. 'notifications').history() end, { desc = 'Notifications: history (fzf-lua)' })

-- [16/18] Git blame
vim.keymap.set('n', '<leader>gb', function() package.loaded.gitsigns.toggle_current_line_blame() end, { desc = 'Toggle [g]it [b]lame' })

-- [17/18] File explorer
local explorer = require('nvim-tree.api').tree

vim.keymap.set('n', '<C-n>', function() explorer.toggle { focus = false } end, { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<leader>e', function() explorer.open() end, { desc = 'Focus file [e]xplorer' })

-- [18/18] Notifications
vim.keymap.set('n', '<leader>nd', function() require('noice').cmd 'dismiss' end, { desc = 'Clear notifications' })
