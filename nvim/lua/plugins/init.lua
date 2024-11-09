return {
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    opts = require 'configs.conform',
  },

  {
    'neovim/nvim-lspconfig',
    config = function()
      require 'configs.lspconfig'
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = {
        'bash',
        'fish',
        'markdown',
        'toml',
        'yaml',
      },
    },
  },

  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
    opts = function()
      return require 'configs.nvimtree'
    end,
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  {
    'williamboman/mason.nvim',
    opts = {
      ensure_installed = {
        'lua-language-server',
        'stylua',
        'html-lsp',
        'css-lsp',
        'prettier',
        'pyre',
      },
    },
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      {
        'rcarriga/nvim-notify',
        module = 'notify',
        config = function()
          require 'configs.notify'
        end,
      },
    }, -- if lazy-loaded, add proper `module='...'` entries
    config = function()
      require 'configs.noice'
    end,
  },

  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require 'configs.surround'
    end,
  },

  {
    'vivek-x-jha/tmux-vim-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
    keys = {
      { '<c-h>', '<cmd>TmuxNavigateLeft<CR>', { desc = 'switch window left' } },
      { '<c-j>', '<cmd>TmuxNavigateDown<CR>', { desc = 'switch window down' } },
      { '<c-k>', '<cmd>TmuxNavigateUp<CR>', { desc = 'switch window up' } },
      { '<c-l>', '<cmd>TmuxNavigateRight<CR>', { desc = 'switch window right' } },
      { '<c-\\>', '<cmd>TmuxNavigatePrevious<CR>', { desc = 'switch last window' } },
    },
  },

  {
    'tpope/vim-obsession',
    cmd = 'Obsession',
  },
}
