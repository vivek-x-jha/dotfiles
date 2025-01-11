local fn = vim.fn

return {
  Lua = {
    diagnostics = {
      globals = { 'vim', 'hs' }, -- Add 'hs' to recognized globals
    },
    workspace = {
      library = {
        fn.expand '$VIMRUNTIME/lua',
        fn.expand '$VIMRUNTIME/lua/vim/lsp',
        fn.stdpath 'data' .. '/lazy/lazy.nvim/lua/lazy',
        '${3rd}/luv/library',
        fn.expand '~/.hammerspoon/Spoons/EmmyLua.spoon/annotations', -- Add EmmyLua annotations
      },
      maxPreload = 100000,
      preloadFileSize = 10000,
    },
  },
}
