local term = require 'ui.terminal'

local mappings = {
  -- General mappings
  { 'n', ';', ':', { desc = 'Enter CMD mode w/o <Shift>' } },
  { 'n', '<Esc>', '<cmd>noh<CR>', { desc = 'Clear highlights' } },
  { 'n', '<leader>nd', '<cmd>NoiceDismiss<CR>', { desc = 'Clear notifications' } },
  { { 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>', { desc = '[S]ave file' } },
  { 'n', '<C-c>', '<cmd>%y+<CR>', { desc = '[C]opy file' } },

  -- Toggle line numbers
  { 'n', '<leader>n', '<cmd>set nu!<CR>', { desc = 'Toggle line number' } },
  { 'n', '<leader>rn', '<cmd>set rnu!<CR>', { desc = 'Toggle relative number' } },

  -- Comments
  { 'n', '<leader>/', 'gcc', { desc = 'Toggle comment', remap = true } },
  { 'v', '<leader>/', 'gc', { desc = 'Toggle comment', remap = true } },

  -- Indentation
  { 'v', '<Tab>', '>gv', { desc = 'Indent selection' } },
  { 'v', '<S-Tab>', '<gv', { desc = 'Outdent selection' } },

  -- Insert mode navigation
  { 'i', '<C-b>', '<ESC>I', { desc = 'Move [b]eginning of line' } },
  { 'i', '<C-e>', '<End>', { desc = 'Move [e]nd of line' } },
  { 'i', '<C-h>', '<Left>', { desc = 'Move left' } },
  { 'i', '<C-l>', '<Right>', { desc = 'Move right' } },
  { 'i', '<C-j>', '<Down>', { desc = 'Move down' } },
  { 'i', '<C-k>', '<Up>', { desc = 'Move up' } },

  -- Scrolling
  { 'n', '<C-d>', '<C-d>zz', { desc = 'Page [d]own and center' } },
  { 'n', '<C-u>', '<C-u>zz', { desc = 'Page [u]p and center' } },
  { 'n', 'n', 'nzz', { desc = 'Next search result and center' } },
  { 'n', 'N', 'Nzz', { desc = 'Previous search result and center' } },

  -- Moving selections
  { 'v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' } },
  { 'v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' } },

  -- Sessions
  { 'n', '<leader>ob', '<cmd>Obsession<CR>', { desc = 'Toggle [ob]session' } },
  {
    'n',
    '<leader>oo',
    function()
      vim.cmd 'silent! Obsession'
      vim.cmd 'silent! Obsession'
      vim.notify('Updating workspace state: Session.vim', vim.log.levels.INFO)
    end,
    { desc = 'Save workspace config' },
  },

  -- Buffers
  { 'n', '<leader>b', '<cmd>enew<CR>', { desc = 'Open [b]uffer' } },
  { 'n', '<tab>', require('ui.buffers').next, { desc = 'Next buffer' } },
  { 'n', '<S-tab>', require('ui.buffers').prev, { desc = 'Prev buffer' } },
  { 'n', '<leader>x', require('ui.buffers').close, { desc = 'Close buffer' } },

  -- NvimTree
  {
    'n',
    '<C-n>',
    function()
      require('nvim-tree.api').tree.toggle { focus = false }
      vim.cmd 'wincmd ='
    end,
    { desc = 'Toggle file explorer' },
  },
  {
    'n',
    '<leader>e',
    function()
      require('nvim-tree.api').tree.open()
      vim.cmd 'wincmd ='
    end,
    { desc = 'Focus file [e]xplorer' },
  },

  -- Terminal
  { 't', '<C-x>', '<C-\\><C-N>', { desc = 'Escape terminal mode' } },
  { 'n', '<leader>h', function() term.open { pos = 'sp' } end, { desc = 'Open [h]orizontal terminal' } },
  { 'n', '<leader>v', function() term.open { pos = 'vsp' } end, { desc = 'Open [v]ertical terminal' } },
  { { 'n', 't' }, '<A-v>', function() term.toggle { pos = 'vsp', id = 'vtoggleTerm' } end, { desc = 'Toggle [v]ertical terminal' } },
  { { 'n', 't' }, '<A-h>', function() term.toggle { pos = 'sp', id = 'htoggleTerm' } end, { desc = 'Toggle [h]orizontal terminal' } },
  { { 'n', 't' }, '<A-i>', function() term.toggle { pos = 'float', id = 'floatTerm' } end, { desc = 'Toggle [f]loating terminal' } },

  -- Gitsigns
  { 'n', '<leader>gb', '<cmd>Gitsigns toggle_current_line_blame<CR>', { desc = 'Toggle [g]itsigns current line [b]lame' } },

  -- LSP
  { 'n', '<leader>ds', vim.diagnostic.setloclist, { desc = 'LSP diagnostic loclist' } },

  -- WhichKey
  { 'n', '<leader>wK', '<cmd>WhichKey <CR>', { desc = 'Toggle all [w]hichkey [K]eymaps' } },
  { 'n', '<leader>wk', function() vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ') end, { desc = 'Search [w]hich[k]ey' } },

  -- Showkeys
  { 'n', '<leader>sk', '<cmd>ShowkeysToggle<CR>', { desc = 'Toggle [s]how[k]eys' } },

  -- Conform
  { 'n', '<leader>fm', function() require('conform').format { lsp_fallback = true } end, { desc = '[f]or[m]at file with linter' } },

  -- Spectre
  { 'n', '<leader>S', function() require('spectre').toggle() end, { desc = 'Toggle [S]earch & Replace' } },
  {
    { 'n', 'v' },
    '<leader>sw',
    function()
      if vim.fn.mode() == 'v' then
        require('spectre').open_visual()
      else
        require('spectre').open_visual { select_word = true }
      end
    end,
    { desc = '[s]earch current [w]ord' },
  },

  -- Dashboard
  {
    'n',
    '<leader>da',
    function()
      if vim.g.dashboard_displayed then
        require('ui.buffers').close()
      else
        require('ui.dashboard').setup()
      end
    end,
    { desc = 'Toggle Dashboard' },
  },
}

for _, keymap in ipairs(mappings) do
  vim.keymap.set(unpack(keymap))
end
