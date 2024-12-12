local api = vim.api
local opt_local = api.nvim_set_option_value

return {
	highlight = function(highlights)
		for hlgroup, hlopts in pairs(highlights) do
			api.nvim_set_hl(0, hlgroup, hlopts)
		end
	end,

	set_cleanbuf_opts = function(ft, buf)
		opt_local('buflisted', false, { scope = 'local' })
		opt_local('modifiable', false, { scope = 'local' })
		opt_local('buftype', 'nofile', { buf = buf })
		opt_local('number', false, { scope = 'local' })
		opt_local('list', false, { scope = 'local' })
		opt_local('wrap', false, { scope = 'local' })
		opt_local('relativenumber', false, { scope = 'local' })
		opt_local('cursorline', false, { scope = 'local' })
		opt_local('colorcolumn', '0', { scope = 'local' })
		opt_local('foldcolumn', '0', { scope = 'local' })
		opt_local('ft', ft, { buf = buf })
		vim.g[ft .. '_displayed'] = true
	end,
}
