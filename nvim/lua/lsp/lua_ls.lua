local fn = vim.fn

return {
  Lua = {
    diagnostics = {
      globals = { 'vim' },
    },
    workspace = {
      library = {
        fn.expand '$VIMRUNTIME/lua',
        fn.expand '$VIMRUNTIME/lua/vim/lsp',
        fn.stdpath 'data' .. '/lazy/lazy.nvim/lua/lazy',
        '${3rd}/luv/library',
      },
      maxPreload = 100000,
      preloadFileSize = 10000,
    },
  },
}
