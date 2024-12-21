-- https://github.com/hrsh7th/nvim-cmp
-- TODO refactor and simplify

return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
  },

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
}
