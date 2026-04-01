local dedup_paths = function(paths)
  local out, seen = {}, {}
  for _, p in ipairs(paths) do
    local rp = (vim.uv or vim.loop).fs_realpath(p) or p
    if not seen[rp] then
      seen[rp] = true
      table.insert(out, rp)
    end
  end
  return out
end

local plugin_libraries = function()
  local libs = {}

  -- 1) Always include Neovim's stdlib
  if vim.env.VIMRUNTIME then table.insert(libs, vim.env.VIMRUNTIME) end

  -- 2) Add every runtimepath entry that has a `lua/` dir (i.e., plugins)
  local cfg_root = vim.fn.stdpath 'config' -- avoid re-adding your config root
  for _, rtp in ipairs(vim.opt.rtp:get()) do
    if rtp ~= cfg_root then
      local lua_dir = rtp .. '/lua'
      local st = (vim.uv or vim.loop).fs_stat(lua_dir)
      if st and st.type == 'directory' then table.insert(libs, lua_dir) end
    end
  end

  return dedup_paths(libs)
end

return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },

  settings = { Lua = { workspace = { library = plugin_libraries() } } },
}
