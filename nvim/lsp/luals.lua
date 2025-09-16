local lua_paths = vim.api.nvim_get_runtime_file('', true)
local xdg_config = os.getenv 'XDG_CONFIG_HOME' or vim.fs.joinpath(os.getenv 'HOME', '.config')

-- Always include Neovim config's lua/
table.insert(lua_paths, vim.fs.joinpath(vim.fn.stdpath 'config', 'lua'))

-- Hammerspoon configs (if present)
local hs_config = vim.fs.joinpath(xdg_config, 'hammerspoon', 'lua')
if vim.uv.fs_stat(hs_config) then table.insert(lua_paths, hs_config) end

-- WezTerm config folder (if present)
local wez_config = vim.fs.joinpath(xdg_config, 'wezterm')
if vim.uv.fs_stat(wez_config) then table.insert(lua_paths, wez_config) end

return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },

  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        library = lua_paths,
        checkThirdParty = false,
        maxPreload = 2000,
        preloadFileSize = 150,
      },
      format = { enable = false },
      telemetry = { enable = false },
    },
  },
}
