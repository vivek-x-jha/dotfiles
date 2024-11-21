local map = vim.keymap.set
local diag = vim.diagnostic
local tabufline = require 'nvchad.tabufline'
local term = require 'nvchad.term'

-- user mapping functions
local funcs = {
  restart_session = function()
    vim.cmd 'silent! Obsession'
    vim.cmd 'silent! Obsession'
    vim.notify('Restarting session in Session.vim', vim.log.levels.INFO)
  end,

  nextbuffer = function()
    tabufline.next()
  end,

  prevbuffer = function()
    tabufline.prev()
  end,

  closebuffer = function()
    tabufline.close_buffer()
  end,

  hsplitTerm = function()
    term.new { pos = 'sp' }
  end,

  vsplitTerm = function()
    term.new { pos = 'vsp' }
  end,

  htoggleTerm = function()
    term.toggle { pos = 'sp', id = 'htoggleTerm' }
  end,

  vtoggleTerm = function()
    term.toggle { pos = 'vsp', id = 'vtoggleTerm' }
  end,

  floatTerm = function()
    term.toggle { pos = 'float', id = 'floatTerm' }
  end,

  view_themes = function()
    require('nvchad.themes').open()
  end,

  queryWhichKey = function()
    vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ')
  end,

  generalFormat = function()
    require('conform').format { lsp_fallback = true }
  end,
}

-- general

-- command line with ;
map('n', ';', ':', { desc = 'CMD enter command mode' })

-- clear highlights
map('n', '<Esc>', '<cmd>noh<CR>', { desc = 'general clear highlights' })

-- save in any mode
map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>', { desc = 'general save file' })

-- copy file
map('n', '<C-c>', '<cmd>%y+<CR>', { desc = 'general copy whole file' })

-- line numbers
map('n', '<leader>n', '<cmd>set nu!<CR>', { desc = 'toggle line number' })
map('n', '<leader>rn', '<cmd>set rnu!<CR>', { desc = 'toggle relative number' })

-- comment
map('n', '<leader>/', 'gcc', { desc = 'toggle comment', remap = true })
map('v', '<leader>/', 'gc', { desc = 'toggle comment', remap = true })

-- workspace

-- obsession
map('n', '<leader>ob', '<cmd>Obsession<CR>', { desc = 'Toggle Obsession session' })
map('n', '<leader>oo', funcs.restart_session, { desc = 'Restart Obsession session' })

-- tabufline
map('n', '<leader>b', '<cmd>enew<CR>', { desc = 'buffer new' })
map('n', '<tab>', funcs.nextbuffer, { desc = 'buffer goto next' })
map('n', '<S-tab>', funcs.prevbuffer, { desc = 'buffer goto prev' })
map('n', '<leader>x', funcs.closebuffer, { desc = 'buffer close' })

-- nvimtree
map('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', { desc = 'nvimtree toggle window' })
map('n', '<leader>e', '<cmd>NvimTreeFocus<CR>', { desc = 'nvimtree focus window' })

-- terminal
map('t', '<C-x>', '<C-\\><C-N>', { desc = 'terminal escape terminal mode' })

map('n', '<leader>h', funcs.hsplitTerm, { desc = 'terminal new horizontal term' })
map('n', '<leader>v', funcs.vtoggleTerm, { desc = 'terminal new vertical term' })

map({ 'n', 't' }, '<A-v>', funcs.vtoggleTerm, { desc = 'terminal toggleable vertical term' })
map({ 'n', 't' }, '<A-h>', funcs.htoggleTerm, { desc = 'terminal toggleable horizontal term' })
map({ 'n', 't' }, '<A-i>', funcs.floatTerm, { desc = 'terminal toggle floating term' })

-- search

-- telescope
map('n', '<leader>fw', '<cmd>Telescope live_grep<CR>', { desc = 'telescope live grep' })
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'telescope find buffers' })
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = 'telescope help page' })
map('n', '<leader>ma', '<cmd>Telescope marks<CR>', { desc = 'telescope find marks' })
map('n', '<leader>fo', '<cmd>Telescope oldfiles<CR>', { desc = 'telescope find oldfiles' })
map('n', '<leader>fz', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { desc = 'telescope find in current buffer' })
map('n', '<leader>cm', '<cmd>Telescope git_commits<CR>', { desc = 'telescope git commits' })
map('n', '<leader>gt', '<cmd>Telescope git_status<CR>', { desc = 'telescope git status' })
map('n', '<leader>pt', '<cmd>Telescope terms<CR>', { desc = 'telescope pick hidden term' })

map('n', '<leader>th', funcs.view_themes, { desc = 'telescope nvchad themes' })

map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'telescope find files' })
map(
  'n',
  '<leader>fa',
  '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>',
  { desc = 'telescope find all files' }
)

-- navigation

-- insert mode
map('i', '<C-b>', '<ESC>^i', { desc = 'move beginning of line' })
map('i', '<C-e>', '<End>', { desc = 'move end of line' })
map('i', '<C-h>', '<Left>', { desc = 'move left' })
map('i', '<C-l>', '<Right>', { desc = 'move right' })
map('i', '<C-j>', '<Down>', { desc = 'move down' })
map('i', '<C-k>', '<Up>', { desc = 'move up' })

-- lsp

-- global lsp mappings
map('n', '<leader>ds', diag.setloclist, { desc = 'LSP diagnostic loclist' })

-- keymeta

-- cheatsheet
map('n', '<leader>ch', '<cmd>NvCheatsheet<CR>', { desc = 'toggle nvcheatsheet' })

-- whichkey
map('n', '<leader>wK', '<cmd>WhichKey <CR>', { desc = 'whichkey all keymaps' })
map('n', '<leader>wk', funcs.queryWhichKey, { desc = 'whichkey query lookup' })

-- showkey
map('n', '<leader>sk', '<cmd>ShowkeysToggle<CR>', { desc = 'Toggle Showkeys' })

-- format

-- conform
map('n', '<leader>fm', funcs.generalFormat, { desc = 'general format file' })
