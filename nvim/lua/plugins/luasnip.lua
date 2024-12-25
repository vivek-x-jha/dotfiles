-- https://github.com/L3MON4D3/LuaSnip
return {
  'L3MON4D3/LuaSnip',
  dependencies = 'rafamadriz/friendly-snippets',
  opts = function()
    local api = vim.api
    local aucmd = api.nvim_create_autocmd
    local currbuf = api.nvim_get_current_buf
    local g = vim.g
    local luasnip = require 'luasnip'
    local cnf = luasnip.config
    local sess = luasnip.session
    local options = { history = true, updateevents = 'TextChanged,TextChangedI' }

    cnf.set_config(options)

    -- vscode format
    require('luasnip.loaders.from_vscode').lazy_load { exclude = g.vscode_snippets_exclude or {} }
    require('luasnip.loaders.from_vscode').lazy_load { paths = g.vscode_snippets_path or '' }

    -- snipmate format
    require('luasnip.loaders.from_snipmate').load()
    require('luasnip.loaders.from_snipmate').lazy_load { paths = g.snipmate_snippets_path or '' }

    -- lua format
    require('luasnip.loaders.from_lua').load()
    require('luasnip.loaders.from_lua').lazy_load { paths = g.lua_snippets_path or '' }

    aucmd('InsertLeave', {
      callback = function()
        if sess.current_nodes[currbuf()] and not sess.jump_active then luasnip.unlink_current() end
      end,
    })

    return options
  end,
}
