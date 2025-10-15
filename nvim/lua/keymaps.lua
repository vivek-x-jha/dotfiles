local keymap = vim.keymap.set

local fzf = require 'fzf-lua'
local fzf_notify = require 'plugins.fzf.pickers.notify'
local gitsigns = require 'gitsigns'
local noice = require 'noice'
local tree = require('nvim-tree.api').tree
local spectre = require 'spectre'

keymap('n', '<leader>ff', function() fzf.files() end, { desc = '[F]ind [F]iles' })
keymap('n', '<leader>fo', function() fzf.oldfiles() end, { desc = '[R]ecent [B]uffers' })
keymap('n', '<leader>fa', function() fzf.autocmds() end, { desc = '[F]ind Neovim [A]uto-commands' })
keymap('n', '<leader>fw', function() fzf.live_grep() end, { desc = '[F]ind [W]ord' })
keymap('n', '<leader>fc', function() fzf.command_history() end, { desc = '[F]ind [C]ommands' })
keymap('n', '<leader>fb', function() fzf.buffers() end, { desc = '[F]ind [B]uffers' })
keymap('n', '<leader>fn', function() fzf.commands() end, { desc = '[F]ind Neovim [C]ommands' })
keymap('n', '<leader>fg', function() fzf.git_files() end, { desc = '[F]ind [G]it Files' })
keymap('n', '<leader>glg', function() fzf.git_commits() end, { desc = '[G]it [L]og Graph' })
keymap('n', '<leader>gst', function() fzf.git_status() end, { desc = '[G]it [St]atus' })
keymap('n', '<leader>gsw', function() fzf.git_branches() end, { desc = '[G]it [S]witch' })
keymap('n', '<leader>un', function() fzf_notify.history() end, { desc = 'Notifications: history (fzf-lua)' })

-- Toggle git blame
keymap('n', '<leader>gb', function() gitsigns.toggle_current_line_blame() end, { desc = 'Toggle [g]it [b]lame' })

-- Toggle search and replace
keymap('n', '<leader>S', function() spectre.toggle() end, { desc = 'Toggle [S]pectre' })
keymap('n', '<leader>sw', function() spectre.open_visual { select_word = true } end, { desc = '[S]earch current [w]ord' })
keymap('v', '<leader>sw', function() spectre.open_visual() end, { desc = '[S]earch current [w]ord' })

-- Toggle File Explorer
keymap('n', '<C-n>', function()
  tree.toggle { focus = false }
  vim.cmd 'wincmd ='
end, { desc = 'Toggle file explorer' })

keymap('n', '<leader>e', function()
  tree.open()
  vim.cmd 'wincmd ='
end, { desc = 'Focus file [e]xplorer' })

-- Dismiss notifications
keymap('n', '<leader>nd', function() noice.cmd 'dismiss' end, { desc = 'Clear notifications' })

------------------------------------ Local Hotkeys ------------------------------------

-- Open command line
keymap('n', ';', ':', { desc = 'Enter CMD mode w/o <Shift>' })

-- Toggle line numbers
keymap('n', '<leader>n', '<cmd>set nu!<CR>', { desc = 'Toggle line number' })
keymap('n', '<leader>rn', '<cmd>set rnu!<CR>', { desc = 'Toggle relative number' })

-- Comments
keymap('n', '<leader>/', 'gcc', { desc = 'Toggle comment', remap = true })
keymap('v', '<leader>/', 'gc', { desc = 'Toggle comment', remap = true })

-- Indentation
keymap('v', '<Tab>', '>gv', { desc = 'Indent selection' })
keymap('v', '<S-Tab>', '<gv', { desc = 'Outdent selection' })

-- Insert mode navigation
keymap('i', '<C-b>', '<ESC>I', { desc = 'Move [b]eginning of line' })
keymap('i', '<C-e>', '<End>', { desc = 'Move [e]nd of line' })
keymap('i', '<C-h>', '<Left>', { desc = 'Move left' })
keymap('i', '<C-l>', '<Right>', { desc = 'Move right' })
keymap('i', '<C-j>', '<Down>', { desc = 'Move down' })
keymap('i', '<C-k>', '<Up>', { desc = 'Move up' })

-- Scrolling
keymap('n', '<C-d>', '<C-d>zz', { desc = 'Page [d]own and center' })
keymap('n', '<C-u>', '<C-u>zz', { desc = 'Page [u]p and center' })
keymap('n', 'n', 'nzz', { desc = 'Next search result and center' })
keymap('n', 'N', 'Nzz', { desc = 'Previous search result and center' })

-- Moving selections
keymap('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
keymap('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Sessions
keymap({ 'n', 'i', 'v' }, '<C-s>', '<cmd>write<CR>', { desc = '[S]ave file' })
keymap('n', '<leader>rr', '<cmd>restart<CR>', { desc = 'Reinitialize Neovim' })
keymap('n', '<leader>oo', function()
  vim.cmd 'silent! mksession! Session.vim'
  vim.notify('Updating workspace state: Session.vim', vim.log.levels.INFO)
end, { desc = 'Save workspace config' })

-- Buffers
keymap('n', '<leader>b', '<cmd>enew<CR>', { desc = 'Open [b]uffer' })
keymap('n', '<leader>x', '<cmd>bdelete<CR>', { desc = 'Close buffer' })
keymap('n', '<C-c>', '<cmd>%y+<CR>', { desc = '[C]opy file' })
keymap('n', '<Esc>', '<cmd>noh<CR>', { desc = 'Clear highlights' })

-- Tabs
keymap('n', '<Tab>', '<cmd>tabnext<CR>', { desc = 'Open next tab' })
keymap('n', '<S-Tab>', '<cmd>tabprevious<CR>', { desc = 'Open previous tab' })

-- Path
keymap('n', '<leader>pp', function()
  for _, path in ipairs(vim.opt.runtimepath:get()) do
    print(path)
  end
end, { desc = 'List all packages in PATH' })

-- Terminal
---@type NvTerminal -- terminal buffer
local terminal = require 'nvim-terminal'

keymap('t', '<C-x>', '<C-\\><C-N>', { desc = 'Escape terminal mode' })
keymap('n', '<leader>h', function() terminal.open { pos = 'sp' } end, { desc = 'Open [h]orizontal terminal' })
keymap('n', '<leader>v', function() terminal.open { pos = 'vsp' } end, { desc = 'Open [v]ertical terminal' })
keymap({ 'n', 't' }, '<A-v>', function() terminal.toggle { pos = 'vsp', id = 'vtoggleTerm' } end, { desc = 'Toggle [v]ertical terminal' })
keymap({ 'n', 't' }, '<A-h>', function() terminal.toggle { pos = 'sp', id = 'htoggleTerm' } end, { desc = 'Toggle [h]orizontal terminal' })
keymap({ 'n', 't' }, '<A-i>', function() terminal.toggle { pos = 'float', id = 'floatTerm' } end, { desc = 'Toggle [f]loating terminal' })

-- LSP
keymap('n', '<leader>ds', vim.diagnostic.setloclist, { desc = 'LSP diagnostic loclist' })

-- Dashboard
keymap('n', '<leader>da', function() require('nvim-dashboard').setup() end, { desc = 'Toggle Dashboard' })
