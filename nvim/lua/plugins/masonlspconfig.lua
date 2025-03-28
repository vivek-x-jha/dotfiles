local lspservers = {
  'basedpyright',
  'bashls',
  'lua_ls',
}

-- https://github.com/williamboman/mason-lspconfig.nvim
return {
  'williamboman/mason-lspconfig.nvim',
  opts = {
    ensure_installed = lspservers,
  },
}
