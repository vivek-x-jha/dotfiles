return {
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = 'openai',
      openai = {
        model = 'gpt-4o-mini',
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
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
        opts = {
          fast_wrap = {},
          disable_filetype = { 'TelescopePrompt', 'vim' },
        },
        config = function(_, opts)
          require('nvim-autopairs').setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
          require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
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
    opts = require 'configs.conform',
  },

  {
    'neovim/nvim-lspconfig',
    config = function()
      require 'configs.lspconfig'
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter',
        event = { 'BufReadPost', 'BufNewFile' },
        cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
        build = ':TSUpdate',
        opts = function()
          return require 'configs.treesitter'
        end,
        config = function(_, opts)
          require('nvim-treesitter.configs').setup(opts)
        end,
      },
    },
    opts = function()
      return require 'configs.telescope'
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
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonInstallAll', 'MasonUpdate' },
    opts = function()
      return require 'configs.mason'
    end,
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
      dofile(vim.g.base46_cache .. 'whichkey')
      return {}
    end,
  },

  'nvim-lua/plenary.nvim',
  'nvzone/volt',
  'nvzone/menu',
  { 'nvzone/minty', cmd = { 'Huefy', 'Shades' } },

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
      dofile(vim.g.base46_cache .. 'devicons')
      return { override = require 'nvchad.icons.devicons' }
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'User FilePost',
    opts = {
      indent = { char = '│', highlight = 'IblChar' },
      scope = { char = '│', highlight = 'IblScopeChar' },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. 'blankline')

      local hooks = require 'ibl.hooks'
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require('ibl').setup(opts)

      dofile(vim.g.base46_cache .. 'blankline')
    end,
  },
}
