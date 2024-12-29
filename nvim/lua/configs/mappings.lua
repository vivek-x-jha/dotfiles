local buf = require 'ui.buffers'
local term = require 'ui.terminal'
local utl = require 'configs.utils'
local nvtree = require('nvim-tree.api').tree

-- Command mode
utl.set_keymap {
  desc = 'CMD enter command mode',
  mode = 'n',
  keys = ';',
  command = ':',
}

utl.set_keymap {
  desc = 'Clear highlights',
  mode = 'n',
  keys = '<Esc>',
  command = '<cmd>noh<CR>',
}

-- Save and Copy
utl.set_keymap {
  desc = '[s]ave file',
  mode = { 'n', 'i', 'v' },
  keys = '<C-s>',
  command = '<cmd>w<CR>',
}

utl.set_keymap {
  desc = '[C]opy file',
  mode = 'n',
  keys = '<C-c>',
  command = '<cmd>%y+<CR>',
}

-- Toggle line numbers
utl.set_keymap {
  desc = 'Toggle line number',
  mode = 'n',
  keys = '<leader>n',
  command = '<cmd>set nu!<CR>',
}

utl.set_keymap {
  desc = 'Toggle relative number',
  mode = 'n',
  keys = '<leader>rn',
  command = '<cmd>set rnu!<CR>',
}

-- Comments
utl.set_keymap {
  desc = 'Toggle comment',
  mode = 'n',
  keys = '<leader>/',
  command = 'gcc',
  remap = true,
}

utl.set_keymap {
  desc = 'Toggle comment',
  mode = 'v',
  keys = '<leader>/',
  command = 'gc',
  remap = true,
}

-- Indentation
utl.set_keymap {
  desc = 'Indent selection',
  mode = 'v',
  keys = '<Tab>',
  command = '>gv',
}

utl.set_keymap {
  desc = 'Outdent selection',
  mode = 'v',
  keys = '<S-Tab>',
  command = '<gv',
}

-- Insert mode navigation
utl.set_keymap {
  desc = 'Move [b]eginning of line',
  mode = 'i',
  keys = '<C-b>',
  command = '<ESC>I',
}

utl.set_keymap {
  desc = 'Move [e]nd of line',
  mode = 'i',
  keys = '<C-e>',
  command = '<End>',
}

utl.set_keymap {
  desc = 'Move left',
  mode = 'i',
  keys = '<C-h>',
  command = '<Left>',
}

utl.set_keymap {
  desc = 'Move right',
  mode = 'i',
  keys = '<C-l>',
  command = '<Right>',
}

utl.set_keymap {
  desc = 'Move down',
  mode = 'i',
  keys = '<C-j>',
  command = '<Down>',
}

utl.set_keymap {
  desc = 'Move up',
  mode = 'i',
  keys = '<C-k>',
  command = '<Up>',
}

-- Scrolling
utl.set_keymap {
  desc = 'Page [d]own and center',
  mode = 'n',
  keys = '<C-d>',
  command = '<C-d>zz',
}

utl.set_keymap {
  desc = 'Page [u]p and center',
  mode = 'n',
  keys = '<C-u>',
  command = '<C-u>zz',
}

-- Moving selections
utl.set_keymap {
  desc = 'Move selection down',
  mode = 'v',
  keys = 'J',
  command = ":m '>+1<CR>gv=gv",
}

utl.set_keymap {
  desc = 'Move selection up',
  mode = 'v',
  keys = 'K',
  command = ":m '<-2<CR>gv=gv",
}

-- Sessions
utl.set_keymap {
  desc = 'Toggle [ob]session',
  mode = 'n',
  keys = '<leader>ob',
  command = '<cmd>Obsession<CR>',
}

utl.set_keymap {
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
utl.set_keymap {
  desc = 'Open [b]uffer',
  mode = 'n',
  keys = '<leader>b',
  command = '<cmd>enew<CR>',
}

utl.set_keymap {
  desc = 'Next buffer',
  mode = 'n',
  keys = '<tab>',
  command = buf.next,
}

utl.set_keymap {
  desc = 'Prev buffer',
  mode = 'n',
  keys = '<S-tab>',
  command = buf.prev,
}

utl.set_keymap {
  desc = 'Close buffer',
  mode = 'n',
  keys = '<leader>x',
  command = buf.close,
}

-- NvimTree
utl.set_keymap {
  desc = 'Toggle file explorer',
  mode = 'n',
  keys = '<C-n>',
  command = function()
    nvtree.toggle { focus = false }
    vim.cmd 'wincmd ='
  end,
}

utl.set_keymap {
  desc = 'Focus file [e]xplorer',
  mode = 'n',
  keys = '<leader>e',
  command = function()
    nvtree.open()
    vim.cmd 'wincmd ='
  end,
}

-- Terminal
utl.set_keymap {
  desc = 'Escape terminal mode',
  mode = 't',
  keys = '<C-x>',
  command = '<C-\\><C-N>',
}

utl.set_keymap {
  desc = 'Open [h]orizontal terminal',
  mode = 'n',
  keys = '<leader>h',
  command = function() term.open { pos = 'sp' } end,
}

utl.set_keymap {
  desc = 'Open [v]ertical terminal',
  mode = 'n',
  keys = '<leader>v',
  command = function() term.open { pos = 'vsp' } end,
}

utl.set_keymap {
  desc = 'Toggle [v]ertical terminal',
  mode = { 'n', 't' },
  keys = '<A-v>',
  command = function() term.toggle { pos = 'vsp', id = 'vtoggleTerm' } end,
}

utl.set_keymap {
  desc = 'Toggle [h]orizontal terminal',
  mode = { 'n', 't' },
  keys = '<A-h>',
  command = function() term.toggle { pos = 'sp', id = 'htoggleTerm' } end,
}

utl.set_keymap {
  desc = 'Toggle [f]loating terminal',
  mode = { 'n', 't' },
  keys = '<A-i>',
  command = function() term.toggle { pos = 'float', id = 'floatTerm' } end,
}

-- Telescope
utl.set_keymap {
  desc = 'Telescope git [c]o[m]mits',
  mode = 'n',
  keys = '<leader>cm',
  command = '<cmd>Telescope git_commits<CR>',
}

utl.set_keymap {
  desc = 'Telescope [f]ind [a]ll files',
  mode = 'n',
  keys = '<leader>fa',
  command = '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>',
}

utl.set_keymap {
  desc = 'Telescope [f]ind [b]uffers',
  mode = 'n',
  keys = '<leader>fb',
  command = '<cmd>Telescope buffers<CR>',
}

utl.set_keymap {
  desc = 'Telescope [f]ind [f]iles',
  mode = 'n',
  keys = '<leader>ff',
  command = '<cmd>Telescope find_files<CR>',
}

utl.set_keymap {
  desc = 'Telescope [h]elp page',
  mode = 'n',
  keys = '<leader>fh',
  command = '<cmd>Telescope help_tags<CR>',
}

utl.set_keymap {
  desc = 'Telescope [f]ind [o]ldfiles',
  mode = 'n',
  keys = '<leader>fo',
  command = '<cmd>Telescope oldfiles<CR>',
}

utl.set_keymap {
  desc = 'Telescope [f]ind [w]ord',
  mode = 'n',
  keys = '<leader>fw',
  command = '<cmd>Telescope live_grep<CR>',
}

utl.set_keymap {
  desc = 'Telescope [f]u[z]zy find in current buffer',
  mode = 'n',
  keys = '<leader>fz',
  command = '<cmd>Telescope current_buffer_fuzzy_find<CR>',
}

utl.set_keymap {
  desc = 'Telescope [g]it s[t]atus',
  mode = 'n',
  keys = '<leader>gt',
  command = '<cmd>Telescope git_status<CR>',
}

utl.set_keymap {
  desc = 'Telescope [m]arks',
  mode = 'n',
  keys = '<leader>ma',
  command = '<cmd>Telescope marks<CR>',
}

utl.set_keymap {
  desc = 'Telescope [p]ick [t]erm',
  mode = 'n',
  keys = '<leader>pt',
  command = '<cmd>Telescope terms<CR>',
}

-- LSP
utl.set_keymap {
  desc = 'LSP diagnostic loclist',
  mode = 'n',
  keys = '<leader>ds',
  command = vim.diagnostic.setloclist,
}

-- WhichKey
utl.set_keymap {
  desc = 'Toggle all [w]hichkey [K]eymaps',
  mode = 'n',
  keys = '<leader>wK',
  command = '<cmd>WhichKey <CR>',
}

utl.set_keymap {
  desc = 'Search [w]hich[k]ey',
  mode = 'n',
  keys = '<leader>wk',
  command = function() vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ') end,
}

-- Showkeys
utl.set_keymap {
  desc = 'Toggle [s]how[k]eys',
  mode = 'n',
  keys = '<leader>sk',
  command = '<cmd>ShowkeysToggle<CR>',
}

-- Conform
utl.set_keymap {
  desc = '[f]or[m]at file with linter',
  mode = 'n',
  keys = '<leader>fm',
  command = function() require('conform').format { lsp_fallback = true } end,
}

-- Spectre
utl.set_keymap {
  desc = 'Toggle [S]earch & Replace',
  mode = 'n',
  keys = '<leader>S',
  command = '<cmd>SpectreToggle<CR>',
}

utl.set_keymap {
  desc = '[s]earch current [w]ord',
  mode = { 'n', 'v' },
  keys = '<leader>sw',
  command = '<cmd>SpectreCurrWord<CR>',
}

utl.set_keymap {
  desc = '[s]earch current word & [f]ile',
  mode = 'n',
  keys = '<leader>sf',
  command = '<cmd>SpectreCurrFile<CR>',
}
