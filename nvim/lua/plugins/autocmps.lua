return {
  -- https://github.com/saghen/blink.cmp
  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    enabled = false,
    version = 'v0.*',
    opts = {
      keymap = { preset = 'default' },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
      signature = { enabled = true },
    },
  },

  -- https://github.com/L3MON4D3/LuaSnip
  {
    'L3MON4D3/LuaSnip',
    dependencies = 'rafamadriz/friendly-snippets',
    opts = function()
      local api = vim.api
      local aucmd = api.nvim_create_autocmd
      local currbuf = api.nvim_get_current_buf
      local g = vim.g
      local luasnip = require 'luasnip'
      local cnf = luasnip.config
      local sess = luasnip.session
      local options = { history = true, updateevents = 'TextChanged,TextChangedI' }

      cnf.set_config(options)

      -- vscode format
      require('luasnip.loaders.from_vscode').lazy_load { exclude = g.vscode_snippets_exclude or {} }
      require('luasnip.loaders.from_vscode').lazy_load { paths = g.vscode_snippets_path or '' }

      -- snipmate format
      require('luasnip.loaders.from_snipmate').load()
      require('luasnip.loaders.from_snipmate').lazy_load { paths = g.snipmate_snippets_path or '' }

      -- lua format
      require('luasnip.loaders.from_lua').load()
      require('luasnip.loaders.from_lua').lazy_load { paths = g.lua_snippets_path or '' }

      aucmd('InsertLeave', {
        callback = function()
          if sess.current_nodes[currbuf()] and not sess.jump_active then luasnip.unlink_current() end
        end,
      })

      return options
    end,
  },

  -- https://github.com/windwp/nvim-autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = function()
      --- @type table setup cmp for autopairs
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'

      require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())

      return {
        fast_wrap = {},
        disable_filetype = { 'TelescopePrompt', 'vim' },
      }
    end,
  },

  -- nvim-cmp dependencies
  { 'saadparwaiz1/cmp_luasnip', event = 'InsertEnter' },
  { 'hrsh7th/cmp-nvim-lua', event = 'InsertEnter' },
  { 'hrsh7th/cmp-nvim-lsp', event = 'InsertEnter' },
  { 'hrsh7th/cmp-buffer', event = 'InsertEnter' },
  { 'hrsh7th/cmp-path', event = 'InsertEnter' },

  -- https://github.com/hrsh7th/nvim-cmp
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    opts = function()
      local cmp = require 'cmp'

      local select_next_item_snippet = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require('luasnip').expand_or_jumpable() then
          require('luasnip').expand_or_jump()
        else
          fallback()
        end
      end

      local select_prev_item_snippet = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require('luasnip').jumpable(-1) then
          require('luasnip').jump(-1)
        else
          fallback()
        end
      end

      return {
        completion = { completeopt = 'menu,menuone' },

        snippet = {
          expand = function(args) require('luasnip').lsp_expand(args.body) end,
        },

        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
          ['<Tab>'] = cmp.mapping(select_next_item_snippet, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(select_prev_item_snippet, { 'i', 's' }),
        },

        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'nvim_lua' },
          { name = 'path' },
        },

        formatting = {
          fields = { 'abbr', 'kind', 'menu' },

          format = function(_, item)
            local icon = require('ui.icons').completions[item.kind] or ''
            local kind = item.kind or ''

            item.kind = ' ' .. icon .. ' ' .. kind
            item.menu_hl_group = 'comment'

            return item
          end,
        },

        window = {
          completion = {
            scrollbar = false,
            side_padding = 1,
            winhighlight = 'Normal:CmpPmenu,CursorLine:CmpSel,Search:None,FloatBorder:CmpBorder',
            border = 'single',
          },

          documentation = {
            border = 'single',
            winhighlight = 'Normal:CmpDoc,FloatBorder:CmpDocBorder',
          },
        },
      }
    end,
  },
}
