-- https://cmp.saghen.dev/installation.html
return {
  'saghen/blink.cmp',
  version = '1.*',
  dependencies = {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    opts = function()
      for _, style in ipairs { 'vscode', 'snipmate', 'lua' } do
        require('luasnip.loaders.from_' .. style).lazy_load()
      end

      return { history = true, updateevents = 'TextChanged,TextChangedI' }
    end,
  },

  opts = {
    keymap = { preset = 'default' },
    appearance = { nerd_font_variant = 'mono' },
    completion = { documentation = { auto_show = false } },
    snippets = { preset = 'luasnip' },
    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },

  opts_extend = {
    'sources.default',
  },
}
