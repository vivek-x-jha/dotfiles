local loaders = 'luasnip.loaders'
local g = vim.g
local api = vim.api

-- vscode format
require(loaders .. 'from_vscode').lazy_load { exclude = g.vscode_snippets_exclude or {} }
require(loaders .. 'from_vscode').lazy_load { paths = g.vscode_snippets_path or '' }

-- snipmate format
require(loaders .. 'from_snipmate').load()
require(loaders .. 'from_snipmate').lazy_load { paths = g.snipmate_snippets_path or '' }

-- lua format
require(loaders .. 'from_lua').load()
require(loaders .. 'from_lua').lazy_load { paths = g.lua_snippets_path or '' }

api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    if
      require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require('luasnip').session.jump_active
    then
      require('luasnip').unlink_current()
    end
  end,
})
