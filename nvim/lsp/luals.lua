local rtp = vim.api.nvim_get_runtime_file('', true)
local nvim_lua = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua')

table.insert(rtp, nvim_lua)

return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },

  settings = {
    Lua = {
      workspace = {
        library = rtp,
      },
    },
  },
}
