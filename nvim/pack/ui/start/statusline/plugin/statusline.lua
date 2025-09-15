vim.o.statusline = "%!v:lua.require('statusline').setup()"

-- optional: a tiny refresh command if you tweak code and want to redraw
vim.api.nvim_create_user_command('StatuslineRedraw', function() vim.cmd 'redrawstatus!' end, {})
