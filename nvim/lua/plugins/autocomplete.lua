local colors = require 'nvim-highlight-colors'
local ls = require 'luasnip' ---@type any

require('nvim-autopairs').setup { fast_wrap = {}, disable_filetype = { 'vim' } }
require('nvim-surround').setup()
colors.setup { render = 'virtual' }

require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_snipmate').lazy_load()
require('luasnip.loaders.from_lua').lazy_load()

ls.setup { history = true, updateevents = 'TextChanged,TextChangedI' }

require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  snippets = { preset = 'luasnip' },
  sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
  fuzzy = { implementation = 'prefer_rust_with_warning', prebuilt_binaries = { force_version = 'v1.6.0' } },
  signature = { enabled = true },

  completion = {
    documentation = { auto_show = true },
    menu = {
      auto_show = true,
      draw = {
        components = {
          kind_icon = {
            text = function(ctx)
              local color_item = ctx.item.source_name == 'LSP' and colors.format(ctx.item.documentation, { kind = ctx.kind })
              local icon = color_item and color_item.abbr ~= '' and color_item.abbr or ctx.kind_icon
              return icon .. ctx.icon_gap
            end,

            highlight = function(ctx)
              local color_item = ctx.item.source_name == 'LSP' and colors.format(ctx.item.documentation, { kind = ctx.kind })
              local hl = color_item and color_item.abbr_hl_group or 'BlinkCmpKind' .. ctx.kind
              return hl
            end,
          },
        },
      },
    },
  },
}
