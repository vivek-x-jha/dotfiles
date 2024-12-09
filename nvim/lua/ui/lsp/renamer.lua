return function()
	local api = vim.api
	local var = vim.fn.expand '<cword>'
	local buf = api.nvim_create_buf(false, true)
	local opts = { height = 1, style = 'minimal', border = 'single', row = 1, col = 1 }

	opts.relative, opts.width = 'cursor', #var + 15
	opts.title, opts.title_pos = { { ' Renamer ', '@comment.danger' } }, 'center'

	local win = api.nvim_open_win(buf, true, opts)
	vim.wo[win].winhl = 'Normal:Normal,FloatBorder:Removed'
	api.nvim_set_current_win(win)

	api.nvim_buf_set_lines(buf, 0, -1, true, { ' ' .. var })
	api.nvim_input 'A'

	vim.keymap.set({ 'i', 'n' }, '<Esc>', '<cmd>q<CR>', { buffer = buf })

	vim.keymap.set('i', '<CR>', function()
		local newName = vim.trim(api.nvim_get_current_line())
		api.nvim_win_close(win, true)

		if #newName > 0 and newName ~= var then
			local params = vim.lsp.util.make_position_params()
			params.newName = newName
			vim.lsp.buf_request(0, 'textDocument/rename', params)
		end

		vim.cmd.stopinsert()
	end, { buffer = buf })
end
