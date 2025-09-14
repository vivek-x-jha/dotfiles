vim.pack.add {
  'https://github.com/saghen/blink.cmp',
  'https://github.com/L3MON4D3/LuaSnip',
}

-- LuaSnip: loaders + basic setup (mirrors the Lazy `dependencies.opts`)
for _, style in ipairs { 'vscode', 'snipmate', 'lua' } do
  require('luasnip.loaders.from_' .. style).lazy_load()
end

require('luasnip').setup { history = true, updateevents = 'TextChanged,TextChangedI' }

-- https://cmp.saghen.dev/installation
require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },

  completion = {
    documentation = { auto_show = false },
    menu = {
      draw = {
        components = {
          kind_icon = {
            text = function(ctx)
              -- default kind icon
              local icon = ctx.kind_icon
              -- colorized kind for LSP items via nvim-highlight-colors (if present)
              if ctx.item.source_name == 'LSP' then
                local ok, nhc = pcall(require, 'nvim-highlight-colors')
                if ok then
                  local color_item = nhc.format(ctx.item.documentation, { kind = ctx.kind })
                  if color_item and color_item.abbr ~= '' then icon = color_item.abbr end
                end
              end
              return icon .. ctx.icon_gap
            end,
            highlight = function(ctx)
              -- default highlight group
              local hl = 'BlinkCmpKind' .. ctx.kind
              -- colorized highlight (if available)
              if ctx.item.source_name == 'LSP' then
                local ok, nhc = pcall(require, 'nvim-highlight-colors')
                if ok then
                  local color_item = nhc.format(ctx.item.documentation, { kind = ctx.kind })
                  if color_item and color_item.abbr_hl_group then hl = color_item.abbr_hl_group end
                end
              end
              return hl
            end,
          },
        },
      },
    },
  },

  snippets = { preset = 'luasnip' },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  fuzzy = {
    implementation = 'prefer_rust_with_warning',
    prebuilt_binaries = {
      force_version = 'v1.6.0', -- TODO find way to make this dynamic
    },
  },
}
