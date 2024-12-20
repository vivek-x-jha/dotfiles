-- https://github.com/hrsh7th/nvim-cmp
-- TODO refactor and siplify this-

return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- https://github.com/L3MON4D3/LuaSnip
    {
      -- snippet plugin
      'L3MON4D3/LuaSnip',
      dependencies = 'rafamadriz/friendly-snippets',
      opts = { history = true, updateevents = 'TextChanged,TextChangedI' },
      config = function(_, opts)
        require('luasnip').config.set_config(opts)

        -- vscode format
        require('luasnip.loaders.from_vscode').lazy_load { exclude = vim.g.vscode_snippets_exclude or {} }
        require('luasnip.loaders.from_vscode').lazy_load { paths = vim.g.vscode_snippets_path or '' }

        -- snipmate format
        require('luasnip.loaders.from_snipmate').load()
        require('luasnip.loaders.from_snipmate').lazy_load { paths = vim.g.snipmate_snippets_path or '' }

        -- lua format
        require('luasnip.loaders.from_lua').load()
        require('luasnip.loaders.from_lua').lazy_load { paths = vim.g.lua_snippets_path or '' }

        vim.api.nvim_create_autocmd('InsertLeave', {
          callback = function()
            if require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()] and not require('luasnip').session.jump_active then
              require('luasnip').unlink_current()
            end
          end,
        })
      end,
    },

    -- https://github.com/windwp/nvim-autopairs
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
    local cmp = require 'cmp'
    local api = vim.api

    local cmp_ui = {
      icons_left = false, -- only for non-atom styles!
      style = 'default', -- default/flat_light/flat_dark/atom/atom_colored
      format_colors = {
        tailwind = false, -- will work for css lsp too
        icon = '󱓻',
      },
    }
    local cmp_style = cmp_ui.style
    local icn = cmp_ui.format_colors.icon .. ' '

    local format_color = {
      tailwind = function(entry, item, kind_txt)
        local entryItem = entry:get_completion_item()
        local color = entryItem.documentation

        if color and type(color) == 'string' and color:match '^#%x%x%x%x%x%x$' then
          local hl = 'hex-' .. color:sub(2)

          if #api.nvim_get_hl(0, { name = hl }) == 0 then api.nvim_set_hl(0, hl, { fg = color }) end

          item.kind = ((cmp_ui.icons_left and icn) or (' ' .. icn)) .. kind_txt
          item.kind_hl_group = hl
          item.menu_hl_group = hl
        end
      end,
    }

    local atom_styled = cmp_style == 'atom' or cmp_style == 'atom_colored'
    local fields = (atom_styled or cmp_ui.icons_left) and { 'kind', 'abbr', 'menu' } or { 'abbr', 'kind', 'menu' }

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

        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },

        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require('luasnip').expand_or_jumpable() then
            require('luasnip').expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require('luasnip').jumpable(-1) then
            require('luasnip').jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },

      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'nvim_lua' },
        { name = 'path' },
      },

      formatting = {
        format = function(entry, item)
          local icons = {
            Namespace = '󰌗',
            Text = '󰉿',
            Method = '󰆧',
            Function = '󰆧',
            Constructor = '',
            Field = '󰜢',
            Variable = '󰀫',
            Class = '󰠱',
            Interface = '',
            Module = '',
            Property = '󰜢',
            Unit = '󰑭',
            Value = '󰎠',
            Enum = '',
            Keyword = '󰌋',
            Snippet = '',
            Color = '󰏘',
            File = '󰈚',
            Reference = '󰈇',
            Folder = '󰉋',
            EnumMember = '',
            Constant = '󰏿',
            Struct = '󰙅',
            Event = '',
            Operator = '󰆕',
            TypeParameter = '󰊄',
            Table = '',
            Object = '󰅩',
            Tag = '',
            Array = '[]',
            Boolean = '',
            Number = '',
            Null = '󰟢',
            Supermaven = '',
            String = '󰉿',
            Calendar = '',
            Watch = '󰥔',
            Package = '',
            Copilot = '',
            Codeium = '',
            TabNine = '',
            BladeNav = '',
          }

          local icon = icons[item.kind] or ''
          local kind = item.kind or ''

          if atom_styled then
            item.menu = kind
            item.menu_hl_group = 'LineNr'
            item.kind = ' ' .. icon .. ' '
          elseif cmp_ui.icons_left then
            item.menu = kind
            item.menu_hl_group = 'CmpItemKind' .. kind
            item.kind = icon
          else
            item.kind = ' ' .. icon .. ' ' .. kind
            item.menu_hl_group = 'comment'
          end

          if kind == 'Color' and cmp_ui.format_colors.tailwind then
            format_color.tailwind(entry, item, (not (atom_styled or cmp_ui.icons_left) and kind) or '')
          end

          return item
        end,

        fields = fields,
      },

      window = {
        completion = {
          scrollbar = false,
          side_padding = atom_styled and 0 or 1,
          winhighlight = 'Normal:CmpPmenu,CursorLine:CmpSel,Search:None,FloatBorder:CmpBorder',
          border = atom_styled and 'none' or 'single',
        },

        documentation = {
          border = 'single',
          winhighlight = 'Normal:CmpDoc,FloatBorder:CmpDocBorder',
        },
      },
    }
  end,
}
