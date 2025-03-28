return {
  'MunifTanjim/nui.nvim',
  'nvim-lua/plenary.nvim',
  'nvzone/menu',
  { 'nvzone/minty', cmd = { 'Huefy', 'Shades' } },
  'nvzone/volt',
  { 'tpope/vim-obsession', cmd = 'Obsession' },
  'stevearc/dressing.nvim',
  'zbirenbaum/copilot.lua',

  -- LuaSnip/Blink dependencies
  { 'rafamadriz/friendly-snippets' },

  -- nvim-cmp dependencies
  { 'saadparwaiz1/cmp_luasnip', event = 'InsertEnter' },
  { 'hrsh7th/cmp-nvim-lua', event = 'InsertEnter' },
  { 'hrsh7th/cmp-nvim-lsp', event = 'InsertEnter' },
  { 'hrsh7th/cmp-buffer', event = 'InsertEnter' },
  { 'hrsh7th/cmp-path', event = 'InsertEnter' },
}
