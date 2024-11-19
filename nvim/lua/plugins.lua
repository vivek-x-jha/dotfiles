return {
  'stevearc/dressing.nvim',
  'nvim-lua/plenary.nvim',
  'MunifTanjim/nui.nvim',
  'nvzone/menu',
  'nvzone/volt',
  {
    'nvzone/minty',
    cmd = { 'Huefy', 'Shades' },
  },

  {
    'nvzone/showkeys',
    cmd = { 'ShowkeysToggle' },
    opts = require 'configs.showkeys',
  },

  {
    'vivek-x-jha/base46',
    build = function()
      require('base46').load_all_highlights()
    end,
  },

  {
    'vivek-x-jha/ui',
    lazy = false,
    config = function()
      require 'nvchad'
    end,
  },

  {
    'nvim-tree/nvim-web-devicons',
    opts = function()
      return require 'configs.webdevicons'
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
    build = ':TSUpdate',
    opts = function()
      return require 'configs.treesitter'
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    opts = function()
      return require 'configs.telescope'
    end,
  },

  {
    -- support for image pasting
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = function()
      return require 'configs.imgclip'
    end,
  },

  {
    -- Make sure to set this up properly if you have lazy=true
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'Avante' },
    opts = function()
      return require 'configs.markdown'
    end,
  },

  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    build = 'make',
    opts = function()
      return require 'configs.avante'
    end,
  },

  -- load luasnips + cmp related in insert mode only
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        -- snippet plugin
        'L3MON4D3/LuaSnip',
        dependencies = 'rafamadriz/friendly-snippets',
        opts = { history = true, updateevents = 'TextChanged,TextChangedI' },
        config = function(_, opts)
          require('luasnip').config.set_config(opts)
          require 'configs.lua_snip'
        end,
      },

      -- autopairing of (){}[] etc
      {
        'windwp/nvim-autopairs',
        opts = function()
          return require 'configs.autopairs'
        end,
      },

      -- cmp sources plugins
      {
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
      },
    },
    opts = function()
      return require 'configs.nvimcmp'
    end,
  },

  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    opts = function()
      return require 'configs.conform'
    end,
  },

  {
    'neovim/nvim-lspconfig',
    event = 'User FilePost',
    config = function()
      require 'configs.lspconfig'
    end,
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
  },

  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonInstallAll', 'MasonUpdate' },
    opts = function()
      return require 'configs.mason'
    end,
  },

  {
    'rcarriga/nvim-notify',
    module = 'notify',
    opts = function()
      return require 'configs.notify'
    end,
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = function()
      return require 'configs.noice'
    end,
  },

  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    opts = function()
      return require 'configs.surround'
    end,
  },

  {
    'christoomey/vim-tmux-navigator',
    cmd = { 'TmuxNavigateLeft', 'TmuxNavigateDown', 'TmuxNavigateUp', 'TmuxNavigateRight', 'TmuxNavigatePrevious' },
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

  {
    'lewis6991/gitsigns.nvim',
    event = 'User FilePost',
    opts = function()
      return require 'configs.gitsigns'
    end,
  },

  {
    'folke/which-key.nvim',
    keys = { '<leader>', '<c-w>', '"', "'", '`', 'c', 'v', 'g' },
    cmd = 'WhichKey',
    opts = function()
      return require 'configs.whichkey'
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'User FilePost',
    opts = function()
      return require 'configs.indentblankline'
    end,
    config = function(_, opts)
      require('ibl').setup(opts)

      dofile(vim.g.base46_cache .. 'blankline')
    end,
  },
}
