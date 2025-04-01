return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc' },

  -- https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'hs' },
      },

      runtime = {
        version = 'LuaJIT',
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
  },
}
