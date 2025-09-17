local lua_paths = vim.api.nvim_get_runtime_file('', true)
table.insert(lua_paths, vim.fs.joinpath(vim.fn.stdpath 'config', 'lua'))

return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },

  settings = {
    Lua = {
      workspace = {
        library = lua_paths,
      },
    },
  },
}
