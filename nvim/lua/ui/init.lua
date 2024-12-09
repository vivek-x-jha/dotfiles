local api = vim.api
local new_cmd = api.nvim_create_user_command

-- Load UI elements
vim.o.statusline = "%!v:lua.require('ui.statusline')()"
require('ui.statusline.utils').autocmds()
require 'ui.tabufline.lazyload'
require 'ui.defaults'
require 'ui.git'
require 'ui.terminal'

-- Toggle NvDash
new_cmd('Nvdash', function()
	if vim.g.nvdash_displayed then
		require('ui.tabufline').close_buffer()
	else
		require('ui.nvdash').open()
	end
end, {})

-- Toggle NvCheatsheet
new_cmd('NvCheatsheet', function()
	if vim.g.nvcheatsheet_displayed then
		vim.cmd 'bw'
	else
		require 'ui.cheatsheet.grid'()
	end
end, {})

-- Create Window Message
local window_msg = function(lines)
	local map = vim.keymap.set
	local w = 0

	for _, v in ipairs(lines) do
		if #v[1] ~= 0 then v[1] = '  ' .. v[1] .. '   ' end

		local strw = api.nvim_strwidth(v[1])

		if w < strw then w = strw end
	end

	table.insert(lines, 1, { '' })
	table.insert(lines, { '' })

	local buf = api.nvim_create_buf(false, true)

	local win = api.nvim_open_win(buf, true, {
		row = math.floor((vim.o.lines - #lines) / 2),
		col = math.floor((vim.o.columns - w) / 2),
		width = w,
		height = #lines,
		relative = 'editor',
		style = 'minimal',
		border = 'single',
		title = { { '  NvChad News ', 'healthSuccess' } },
		title_pos = 'center',
	})

	vim.wo[win].winhl = 'FloatBorder:Comment'

	for i, line in ipairs(lines) do
		api.nvim_buf_set_lines(buf, i - 1, i, false, { line[1] })
		api.nvim_buf_add_highlight(buf, -1, line[2] or '', i - 1, 0, -1)
	end

	map('n', 'q', '<cmd> q<cr>')
	map('n', '<esc>', '<cmd> q<cr>')
end

-- Setup autocommands
vim.schedule(function()
	local env = vim.env
	local fn = vim.fn
	local create_autocmd = api.nvim_create_autocmd

	-- load nvdash only on empty file
	local buf_lines = api.nvim_buf_get_lines(0, 0, 1, false)
	local no_buf_content = api.nvim_buf_line_count(0) == 1 and buf_lines[1] == ''
	local bufname = api.nvim_buf_get_name(0)

	if bufname == '' and no_buf_content then require('ui.nvdash').open() end

	create_autocmd('LspAttach', {
		callback = function(args)
			vim.schedule(function()
				local client = vim.lsp.get_client_by_id(args.data.client_id)

				if client then
					local signatureProvider = client.server_capabilities.signatureHelpProvider
					if signatureProvider and signatureProvider.triggerCharacters then require('ui.lsp.signature').setup(client, args.buf) end
				end
			end)
		end,
	})

	-- reload the plugin!
	create_autocmd('BufWritePost', {
		pattern = vim.tbl_map(
			function(path) return vim.fs.normalize(vim.uv.fs_realpath(path)) end,
			fn.glob(vim.fn.stdpath 'config' .. '/lua/**/*.lua', true, true, true)
		),
		group = api.nvim_create_augroup('ReloadNvChad', {}),

		callback = function(opts)
			local fp = fn.fnamemodify(vim.fs.normalize(api.nvim_buf_get_name(opts.buf)), ':r') --[[@as string]]
			local app_name = env.NVIM_APPNAME and env.NVIM_APPNAME or 'nvim'
			local module = string.gsub(fp, '^.*/' .. app_name .. '/lua/', ''):gsub('/', '.')

			require('ui.utils').reload(module)
			-- vim.cmd("redraw!")
		end,
	})

	new_cmd('MasonInstallAll', function() require('ui.mason').install_all() end, {})

	require('ui.colorify').run()

	local dir = fn.stdpath 'data' .. '/nvnotify'

	if not vim.uv.fs_stat(dir) then
		fn.mkdir(dir, 'p')
		window_msg {
			{ '* NvChad UI v3.0 has been released! Check https://nvchad.com/news/nvui', 'added' },
			{ "* Docs have been added at :h nvui, don't forget to read them!" },
			{ '* Check the Volt plugin showcase at https://nvchad.com/news/volt' },
		}
	end
end)
