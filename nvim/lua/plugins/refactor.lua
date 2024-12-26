return {
  -- https://github.com/lukas-reineke/indent-blankline.nvim
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'User FilePost',
    main = 'ibl',
    opts = { indent = { char = '┊' } },
  },

  -- https://github.com/stevearc/conform.nvim
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        -- python = { 'ruff?' },
      },

      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
    },
  },

  -- https://github.com/kylechui/nvim-surround
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    opts = {},
  },

  -- https://github.com/nvim-pack/nvim-spectre
  {
    'nvim-pack/nvim-spectre',
    opts = function()
      -- Force highlighting: spectre.setup() sets highlights after passing opts
      vim.schedule(function() require('colors.highlights').setup(vim.g.colorscheme, 'spectre') end)

      return {
        result_padding = '',
        default = {
          replace = {
            cmd = 'sed',
          },
        },
      }
    end,
  },

  -- https://github.com/HakonHarnes/img-clip.nvim
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = { insert_mode = true },
        use_absolute_path = true,
      },
    },
  },

  -- https://github.com/MeanderingProgrammer/render-markdown.nvim
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = { file_types = { 'markdown', 'Avante' } },
    ft = { 'markdown', 'Avante' },
  },

  -- https://github.com/yetone/avante.nvim
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false,
    build = 'make',

    opts = {
      provider = 'openai',
      openai = { model = 'gpt-4o-mini' },
    },
  },
}
