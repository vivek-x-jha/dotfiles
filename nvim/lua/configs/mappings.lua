local buf = require 'ui.buffers'
local term = require 'ui.terminal'
local nvtree = require('nvim-tree.api').tree

--- Keymaps Table to be scheduled for remappings:
---
--- - To remap over old commands set `remap`to `true`
--- @type KeyMap[]
return {
  {
    desc = 'Enter CMD mode w/o <Shift>',
    mode = 'n',
    keys = ';',
    command = ':',
  },

  {
    desc = 'Clear highlights',
    mode = 'n',
    keys = '<Esc>',
    command = '<cmd>noh<CR>',
  },

  {
    desc = '[s]ave file',
    mode = { 'n', 'i', 'v' },
    keys = '<C-s>',
    command = '<cmd>w<CR>',
  },

  {
    desc = '[C]opy file',
    mode = 'n',
    keys = '<C-c>',
    command = '<cmd>%y+<CR>',
  },

  -- Toggle line numbers
  {
    desc = 'Toggle line number',
    mode = 'n',
    keys = '<leader>n',
    command = '<cmd>set nu!<CR>',
  },

  {
    desc = 'Toggle relative number',
    mode = 'n',
    keys = '<leader>rn',
    command = '<cmd>set rnu!<CR>',
  },

  -- Comments
  {
    desc = 'Toggle comment',
    mode = 'n',
    keys = '<leader>/',
    command = 'gcc',
    remap = true,
  },

  {
    desc = 'Toggle comment',
    mode = 'v',
    keys = '<leader>/',
    command = 'gc',
    remap = true,
  },

  -- Indentation
  {
    desc = 'Indent selection',
    mode = 'v',
    keys = '<Tab>',
    command = '>gv',
  },

  {
    desc = 'Outdent selection',
    mode = 'v',
    keys = '<S-Tab>',
    command = '<gv',
  },

  -- Insert mode navigation
  {
    desc = 'Move [b]eginning of line',
    mode = 'i',
    keys = '<C-b>',
    command = '<ESC>I',
  },

  {
    desc = 'Move [e]nd of line',
    mode = 'i',
    keys = '<C-e>',
    command = '<End>',
  },

  {
    desc = 'Move left',
    mode = 'i',
    keys = '<C-h>',
    command = '<Left>',
  },

  {
    desc = 'Move right',
    mode = 'i',
    keys = '<C-l>',
    command = '<Right>',
  },

  {
    desc = 'Move down',
    mode = 'i',
    keys = '<C-j>',
    command = '<Down>',
  },

  {
    desc = 'Move up',
    mode = 'i',
    keys = '<C-k>',
    command = '<Up>',
  },

  -- Scrolling
  {
    desc = 'Page [d]own and center',
    mode = 'n',
    keys = '<C-d>',
    command = '<C-d>zz',
  },

  {
    desc = 'Page [u]p and center',
    mode = 'n',
    keys = '<C-u>',
    command = '<C-u>zz',
  },

  -- Moving selections
  {
    desc = 'Move selection down',
    mode = 'v',
    keys = 'J',
    command = ":m '>+1<CR>gv=gv",
  },

  {
    desc = 'Move selection up',
    mode = 'v',
    keys = 'K',
    command = ":m '<-2<CR>gv=gv",
  },

  -- Sessions
  {
    desc = 'Toggle [ob]session',
    mode = 'n',
    keys = '<leader>ob',
    command = '<cmd>Obsession<CR>',
  },

  {
    desc = 'Save workspace config',
    mode = 'n',
    keys = '<leader>oo',
    command = function()
      vim.cmd 'silent! Obsession'
      vim.cmd 'silent! Obsession'
      vim.notify('Updating workspace state: Session.vim', vim.log.levels.INFO)
    end,
  },

  -- Buffers
  {
    desc = 'Open [b]uffer',
    mode = 'n',
    keys = '<leader>b',
    command = '<cmd>enew<CR>',
  },

  {
    desc = 'Next buffer',
    mode = 'n',
    keys = '<tab>',
    command = buf.next,
  },

  {
    desc = 'Prev buffer',
    mode = 'n',
    keys = '<S-tab>',
    command = buf.prev,
  },

  {
    desc = 'Close buffer',
    mode = 'n',
    keys = '<leader>x',
    command = buf.close,
  },

  -- NvimTree
  {
    desc = 'Toggle file explorer',
    mode = 'n',
    keys = '<C-n>',
    command = function()
      nvtree.toggle { focus = false }
      vim.cmd 'wincmd ='
    end,
  },

  {
    desc = 'Focus file [e]xplorer',
    mode = 'n',
    keys = '<leader>e',
    command = function()
      nvtree.open()
      vim.cmd 'wincmd ='
    end,
  },

  -- Terminal
  {
    desc = 'Escape terminal mode',
    mode = 't',
    keys = '<C-x>',
    command = '<C-\\><C-N>',
  },

  {
    desc = 'Open [h]orizontal terminal',
    mode = 'n',
    keys = '<leader>h',
    command = function() term.open { pos = 'sp' } end,
  },

  {
    desc = 'Open [v]ertical terminal',
    mode = 'n',
    keys = '<leader>v',
    command = function() term.open { pos = 'vsp' } end,
  },

  {
    desc = 'Toggle [v]ertical terminal',
    mode = { 'n', 't' },
    keys = '<A-v>',
    command = function() term.toggle { pos = 'vsp', id = 'vtoggleTerm' } end,
  },

  {
    desc = 'Toggle [h]orizontal terminal',
    mode = { 'n', 't' },
    keys = '<A-h>',
    command = function() term.toggle { pos = 'sp', id = 'htoggleTerm' } end,
  },

  {
    desc = 'Toggle [f]loating terminal',
    mode = { 'n', 't' },
    keys = '<A-i>',
    command = function() term.toggle { pos = 'float', id = 'floatTerm' } end,
  },

  -- Telescope
  {
    desc = 'Telescope git [c]o[m]mits',
    mode = 'n',
    keys = '<leader>cm',
    command = '<cmd>Telescope git_commits<CR>',
  },

  {
    desc = 'Telescope [f]ind [a]ll files',
    mode = 'n',
    keys = '<leader>fa',
    command = '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>',
  },

  {
    desc = 'Telescope [f]ind [b]uffers',
    mode = 'n',
    keys = '<leader>fb',
    command = '<cmd>Telescope buffers<CR>',
  },

  {
    desc = 'Telescope [f]ind [f]iles',
    mode = 'n',
    keys = '<leader>ff',
    command = '<cmd>Telescope find_files<CR>',
  },

  {
    desc = 'Telescope [h]elp page',
    mode = 'n',
    keys = '<leader>fh',
    command = '<cmd>Telescope help_tags<CR>',
  },

  {
    desc = 'Telescope [f]ind [o]ldfiles',
    mode = 'n',
    keys = '<leader>fo',
    command = '<cmd>Telescope oldfiles<CR>',
  },

  {
    desc = 'Telescope [f]ind [w]ord',
    mode = 'n',
    keys = '<leader>fw',
    command = '<cmd>Telescope live_grep<CR>',
  },

  {
    desc = 'Telescope [f]u[z]zy find in current buffer',
    mode = 'n',
    keys = '<leader>fz',
    command = '<cmd>Telescope current_buffer_fuzzy_find<CR>',
  },

  {
    desc = 'Telescope [g]it s[t]atus',
    mode = 'n',
    keys = '<leader>gt',
    command = '<cmd>Telescope git_status<CR>',
  },

  {
    desc = 'Telescope [m]arks',
    mode = 'n',
    keys = '<leader>ma',
    command = '<cmd>Telescope marks<CR>',
  },

  {
    desc = 'Telescope [p]ick [t]erm',
    mode = 'n',
    keys = '<leader>pt',
    command = '<cmd>Telescope terms<CR>',
  },

  -- LSP
  {
    desc = 'LSP diagnostic loclist',
    mode = 'n',
    keys = '<leader>ds',
    command = vim.diagnostic.setloclist,
  },

  -- WhichKey
  {
    desc = 'Toggle all [w]hichkey [K]eymaps',
    mode = 'n',
    keys = '<leader>wK',
    command = '<cmd>WhichKey <CR>',
  },

  {
    desc = 'Search [w]hich[k]ey',
    mode = 'n',
    keys = '<leader>wk',
    command = function() vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ') end,
  },

  -- Showkeys
  {
    desc = 'Toggle [s]how[k]eys',
    mode = 'n',
    keys = '<leader>sk',
    command = '<cmd>ShowkeysToggle<CR>',
  },

  -- Conform
  {
    desc = '[f]or[m]at file with linter',
    mode = 'n',
    keys = '<leader>fm',
    command = function() require('conform').format { lsp_fallback = true } end,
  },

  -- Spectre
  {
    desc = 'Toggle [S]earch & Replace',
    mode = 'n',
    keys = '<leader>S',
    command = '<cmd>SpectreToggle<CR>',
  },

  {
    desc = '[s]earch current [w]ord',
    mode = { 'n', 'v' },
    keys = '<leader>sw',
    command = '<cmd>SpectreCurrWord<CR>',
  },

  {
    desc = '[s]earch current word & [f]ile',
    mode = 'n',
    keys = '<leader>sf',
    command = '<cmd>SpectreCurrFile<CR>',
  },
}
