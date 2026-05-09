local remap = vim.keymap.set

-- [1/18] Open command line
remap('n', ';', ':', { desc = 'Enter CMD mode w/o <Shift>' })

-- [2/18] Toggle line numbers
remap('n', '<leader>n', '<cmd>set nu!<CR>', { desc = 'Toggle line number' })
remap('n', '<leader>rn', '<cmd>set rnu!<CR>', { desc = 'Toggle relative number' })

-- [3/18] Indentation
remap('v', '<Tab>', '>gv', { desc = 'Indent selection' })
remap('v', '<S-Tab>', '<gv', { desc = 'Outdent selection' })

-- [4/18] Insert mode navigation
remap('i', '<C-b>', '<ESC>I', { desc = 'Move [b]eginning of line' })
remap('i', '<C-e>', '<End>', { desc = 'Move [e]nd of line' })
remap('i', '<C-h>', '<Left>', { desc = 'Move left' })
remap('i', '<C-l>', '<Right>', { desc = 'Move right' })
remap('i', '<C-j>', '<Down>', { desc = 'Move down' })
remap('i', '<C-k>', '<Up>', { desc = 'Move up' })

-- [5/18] Scrolling
remap('n', '<C-d>', '<C-d>zz', { desc = 'Page [d]own and center' })
remap('n', '<C-u>', '<C-u>zz', { desc = 'Page [u]p and center' })
remap('n', 'n', 'nzz', { desc = 'Next search result and center' })
remap('n', 'N', 'Nzz', { desc = 'Previous search result and center' })

-- [6/18] Moving selections
remap('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
remap('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- [7/18] Sessions
remap({ 'n', 'i', 'v' }, '<C-s>', '<cmd>write<CR>', { desc = '[S]ave file' })
remap('n', '<leader>oo', function()
  vim.cmd 'silent! mksession! Session.vim'
  vim.notify('Updating workspace state: Session.vim', vim.log.levels.INFO)
end, { desc = 'Save workspace config' })

-- [8/18] Buffers
remap('n', '<leader>b', '<cmd>enew<CR>', { desc = 'Open [b]uffer' })
remap('n', '<leader>x', '<cmd>bdelete<CR>', { desc = 'Close buffer' })
remap('n', '<C-c>', '<cmd>%y+<CR>', { desc = '[C]opy file' })
remap('n', '<Esc>', '<cmd>noh<CR>', { desc = 'Clear highlights' })

-- [9/18] Tabs
remap('n', '<Tab>', '<cmd>tabnext<CR>', { desc = 'Open next tab' })
remap('n', '<S-Tab>', '<cmd>tabprevious<CR>', { desc = 'Open previous tab' })

-- [10/18] Path
remap('n', '<leader>pp', function()
  for _, path in ipairs(vim.opt.runtimepath:get()) do
    print(path)
  end
end, { desc = 'List all packages in PATH' })

-- [11/18] Terminal
local term = require 'ui.terminal'

remap('t', '<C-x>', '<C-\\><C-N>', { desc = 'Escape terminal mode' })
remap('n', '<leader>h', function() term.open { pos = 'sp' } end, { desc = 'Open [h]orizontal terminal' })
remap('n', '<leader>v', function() term.open { pos = 'vsp' } end, { desc = 'Open [v]ertical terminal' })
remap({ 'n', 't' }, '<A-v>', function() term.toggle { pos = 'vsp', id = 'vtoggleTerm' } end, { desc = 'Toggle [v]ertical terminal' })
remap({ 'n', 't' }, '<A-h>', function() term.toggle { pos = 'sp', id = 'htoggleTerm' } end, { desc = 'Toggle [h]orizontal terminal' })
remap({ 'n', 't' }, '<A-i>', function() term.toggle { pos = 'float', id = 'floatTerm' } end, { desc = 'Toggle [f]loating terminal' })

-- [12/18] LSP
remap('n', '<leader>ds', vim.diagnostic.setloclist, { desc = 'LSP diagnostic loclist' })

-- [13/18] Dashboard
remap('n', '<leader>da', function() require('ui.dashboard').setup() end, { desc = 'Toggle Dashboard' })

-- [14/18] Fzf.lua pickers
local fzf = require 'fzf-lua'

remap('n', '<leader>ff', function() fzf.files() end, { desc = '[F]ind [F]iles' })
remap('n', '<leader>fo', function() fzf.oldfiles() end, { desc = '[R]ecent [B]uffers' })
remap('n', '<leader>fa', function() fzf.autocmds() end, { desc = '[F]ind Neovim [A]uto-commands' })
remap('n', '<leader>fw', function() fzf.live_grep() end, { desc = '[F]ind [W]ord' })
remap('n', '<leader>fc', function() fzf.command_history() end, { desc = '[F]ind [C]ommands' })
remap('n', '<leader>fb', function() fzf.buffers() end, { desc = '[F]ind [B]uffers' })
remap('n', '<leader>fn', function() fzf.commands() end, { desc = '[F]ind Neovim [C]ommands' })
remap('n', '<leader>fg', function() fzf.git_files() end, { desc = '[F]ind [G]it Files' })
remap('n', '<leader>glg', function() fzf.git_commits() end, { desc = '[G]it [L]og Graph' })
remap('n', '<leader>gst', function() fzf.git_status() end, { desc = '[G]it [St]atus' })
remap('n', '<leader>gsw', function() fzf.git_branches() end, { desc = '[G]it [S]witch' })

-- [15/18] Fzf.lua custom pickers
local pickers = 'plugins.fzf.pickers.'

remap('n', '<leader>un', function() require(pickers .. 'notifications').history() end, { desc = 'Notifications: history (fzf-lua)' })

-- [16/18] Git blame
remap('n', '<leader>gb', function() package.loaded.gitsigns.toggle_current_line_blame() end, { desc = 'Toggle [g]it [b]lame' })

-- [17/18] File explorer
local explorer = require('nvim-tree.api').tree

remap('n', '<C-n>', function() explorer.toggle { focus = false } end, { desc = 'Toggle file explorer' })
remap('n', '<leader>e', function() explorer.open() end, { desc = 'Focus file [e]xplorer' })

-- [18/18] Notifications
remap('n', '<leader>nd', function() require('noice').cmd 'dismiss' end, { desc = 'Clear notifications' })
