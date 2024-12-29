local buf = require 'ui.buffers'
local term = require 'ui.terminal'
local keymap = require('configs.utils').set_keymap

-- Command mode
keymap {
  desc = 'CMD enter command mode',
  mode = 'n',
  keys = ';',
  command = ':',
}

keymap {
  desc = 'Clear highlights',
  mode = 'n',
  keys = '<Esc>',
  command = '<cmd>noh<CR>',
}

-- Save and Copy
keymap {
  desc = '[s]ave file',
  mode = { 'n', 'i', 'v' },
  keys = '<C-s>',
  command = '<cmd>w<CR>',
}

keymap {
  desc = '[C]opy file',
  mode = 'n',
  keys = '<C-c>',
  command = '<cmd>%y+<CR>',
}

-- Toggle line numbers
keymap {
  desc = 'Toggle line number',
  mode = 'n',
  keys = '<leader>n',
  command = '<cmd>set nu!<CR>',
}

keymap {
  desc = 'Toggle relative number',
  mode = 'n',
  keys = '<leader>rn',
  command = '<cmd>set rnu!<CR>',
}

-- Comments
keymap {
  desc = 'Toggle comment',
  mode = 'n',
  keys = '<leader>/',
  command = 'gcc',
  remap = true,
}

keymap {
  desc = 'Toggle comment',
  mode = 'v',
  keys = '<leader>/',
  command = 'gc',
  remap = true,
}

-- Indentation
keymap {
  desc = 'Indent selection',
  mode = 'v',
  keys = '<Tab>',
  command = '>gv',
}

keymap {
  desc = 'Outdent selection',
  mode = 'v',
  keys = '<S-Tab>',
  command = '<gv',
}

-- Insert mode navigation
keymap {
  desc = 'Move [b]eginning of line',
  mode = 'i',
  keys = '<C-b>',
  command = '<ESC>I',
}

keymap {
  desc = 'Move [e]nd of line',
  mode = 'i',
  keys = '<C-e>',
  command = '<End>',
}

keymap {
  desc = 'Move left',
  mode = 'i',
  keys = '<C-h>',
  command = '<Left>',
}

keymap {
  desc = 'Move right',
  mode = 'i',
  keys = '<C-l>',
  command = '<Right>',
}

keymap {
  desc = 'Move down',
  mode = 'i',
  keys = '<C-j>',
  command = '<Down>',
}

keymap {
  desc = 'Move up',
  mode = 'i',
  keys = '<C-k>',
  command = '<Up>',
}

-- Scrolling
keymap {
  desc = 'Page [d]own and center',
  mode = 'n',
  keys = '<C-d>',
  command = '<C-d>zz',
}

keymap {
  desc = 'Page [u]p and center',
  mode = 'n',
  keys = '<C-u>',
  command = '<C-u>zz',
}

-- Moving selections
keymap {
  desc = 'Move selection down',
  mode = 'v',
  keys = 'J',
  command = ":m '>+1<CR>gv=gv",
}

keymap {
  desc = 'Move selection up',
  mode = 'v',
  keys = 'K',
  command = ":m '<-2<CR>gv=gv",
}

-- Sessions
keymap {
  desc = 'Toggle [ob]session',
  mode = 'n',
  keys = '<leader>ob',
  command = '<cmd>Obsession<CR>',
}

keymap {
  desc = 'Save workspace config',
  mode = 'n',
  keys = '<leader>oo',
  command = function()
    vim.cmd 'silent! Obsession'
    vim.cmd 'silent! Obsession'
    vim.notify('Updating workspace state: Session.vim', vim.log.levels.INFO)
  end,
}

-- Buffers
keymap {
  desc = 'Open [b]uffer',
  mode = 'n',
  keys = '<leader>b',
  command = '<cmd>enew<CR>',
}

keymap {
  desc = 'Next buffer',
  mode = 'n',
  keys = '<tab>',
  command = buf.next,
}

keymap {
  desc = 'Prev buffer',
  mode = 'n',
  keys = '<S-tab>',
  command = buf.prev,
}

keymap {
  desc = 'Close buffer',
  mode = 'n',
  keys = '<leader>x',
  command = buf.close,
}

-- NvimTree
keymap {
  desc = 'Toggle file explorer',
  mode = 'n',
  keys = '<C-n>',
  command = function()
    require('nvim-tree.api').tree.toggle { focus = false }
    vim.cmd 'wincmd ='
  end,
}

keymap {
  desc = 'Focus file [e]xplorer',
  mode = 'n',
  keys = '<leader>e',
  command = function()
    require('nvim-tree.api').tree.open()
    vim.cmd 'wincmd ='
  end,
}

-- Terminal
keymap {
  desc = 'Escape terminal mode',
  mode = 't',
  keys = '<C-x>',
  command = '<C-\\><C-N>',
}

keymap {
  desc = 'Open [h]orizontal terminal',
  mode = 'n',
  keys = '<leader>h',
  command = function() term.open { pos = 'sp' } end,
}

keymap {
  desc = 'Open [v]ertical terminal',
  mode = 'n',
  keys = '<leader>v',
  command = function() term.open { pos = 'vsp' } end,
}

keymap {
  desc = 'Toggle [v]ertical terminal',
  mode = { 'n', 't' },
  keys = '<A-v>',
  command = function() term.toggle { pos = 'vsp', id = 'vtoggleTerm' } end,
}

keymap {
  desc = 'Toggle [h]orizontal terminal',
  mode = { 'n', 't' },
  keys = '<A-h>',
  command = function() term.toggle { pos = 'sp', id = 'htoggleTerm' } end,
}

keymap {
  desc = 'Toggle [f]loating terminal',
  mode = { 'n', 't' },
  keys = '<A-i>',
  command = function() term.toggle { pos = 'float', id = 'floatTerm' } end,
}

-- Telescope
keymap {
  desc = 'Telescope git [c]o[m]mits',
  mode = 'n',
  keys = '<leader>cm',
  command = '<cmd>Telescope git_commits<CR>',
}

keymap {
  desc = 'Telescope [f]ind [a]ll files',
  mode = 'n',
  keys = '<leader>fa',
  command = '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>',
}

keymap {
  desc = 'Telescope [f]ind [b]uffers',
  mode = 'n',
  keys = '<leader>fb',
  command = '<cmd>Telescope buffers<CR>',
}

keymap {
  desc = 'Telescope [f]ind [f]iles',
  mode = 'n',
  keys = '<leader>ff',
  command = '<cmd>Telescope find_files<CR>',
}

keymap {
  desc = 'Telescope [h]elp page',
  mode = 'n',
  keys = '<leader>fh',
  command = '<cmd>Telescope help_tags<CR>',
}

keymap {
  desc = 'Telescope [f]ind [o]ldfiles',
  mode = 'n',
  keys = '<leader>fo',
  command = '<cmd>Telescope oldfiles<CR>',
}

keymap {
  desc = 'Telescope [f]ind [w]ord',
  mode = 'n',
  keys = '<leader>fw',
  command = '<cmd>Telescope live_grep<CR>',
}

keymap {
  desc = 'Telescope [f]u[z]zy find in current buffer',
  mode = 'n',
  keys = '<leader>fz',
  command = '<cmd>Telescope current_buffer_fuzzy_find<CR>',
}

keymap {
  desc = 'Telescope [g]it s[t]atus',
  mode = 'n',
  keys = '<leader>gt',
  command = '<cmd>Telescope git_status<CR>',
}

keymap {
  desc = 'Telescope [m]arks',
  mode = 'n',
  keys = '<leader>ma',
  command = '<cmd>Telescope marks<CR>',
}

keymap {
  desc = 'Telescope [p]ick [t]erm',
  mode = 'n',
  keys = '<leader>pt',
  command = '<cmd>Telescope terms<CR>',
}

-- LSP
keymap {
  desc = 'LSP diagnostic loclist',
  mode = 'n',
  keys = '<leader>ds',
  command = vim.diagnostic.setloclist,
}

-- WhichKey
keymap {
  desc = 'Toggle all [w]hichkey [K]eymaps',
  mode = 'n',
  keys = '<leader>wK',
  command = '<cmd>WhichKey <CR>',
}

keymap {
  desc = 'Search [w]hich[k]ey',
  mode = 'n',
  keys = '<leader>wk',
  command = function() vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ') end,
}

-- Showkeys
keymap {
  desc = 'Toggle [s]how[k]eys',
  mode = 'n',
  keys = '<leader>sk',
  command = '<cmd>ShowkeysToggle<CR>',
}

-- Conform
keymap {
  desc = '[f]or[m]at file with linter',
  mode = 'n',
  keys = '<leader>fm',
  command = function() require('conform').format { lsp_fallback = true } end,
}

-- Spectre
keymap {
  desc = 'Toggle [S]earch & Replace',
  mode = 'n',
  keys = '<leader>S',
  command = '<cmd>SpectreToggle<CR>',
}

keymap {
  desc = '[s]earch current [w]ord',
  mode = { 'n', 'v' },
  keys = '<leader>sw',
  command = '<cmd>SpectreCurrWord<CR>',
}

keymap {
  desc = '[s]earch current word & [f]ile',
  mode = 'n',
  keys = '<leader>sf',
  command = '<cmd>SpectreCurrFile<CR>',
}
