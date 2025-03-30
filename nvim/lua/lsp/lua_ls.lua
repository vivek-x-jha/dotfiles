return {
  Lua = {
    diagnostics = {
      globals = { 'vim', 'hs' }, -- Add 'hs' to recognized globals
    },
    workspace = {
      library = {
        vim.fn.expand '$VIMRUNTIME/lua',
        vim.fn.expand '$VIMRUNTIME/lua/vim/lsp',
        vim.fn.stdpath 'data' .. '/lazy/lazy.nvim/lua/lazy',
        '${3rd}/luv/library',
        vim.fn.expand(vim.fn.stdpath 'config' .. '/hammerspoon/Spoons/EmmyLua.spoon/annotations'),
      },
      maxPreload = 100000,
      preloadFileSize = 10000,
    },
  },
}
