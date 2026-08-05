local plugin = vim.pack.get({ 'vim-herdr-navigation' })[1]
assert(plugin, 'vim-herdr-navigation is not installed')

dofile(vim.fs.joinpath(plugin.path, 'editor', 'nvim.lua'))
