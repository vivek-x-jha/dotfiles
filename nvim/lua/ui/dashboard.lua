local api = vim.api
local fn = vim.fn
local g = vim.g
local v = vim.v
local strw = api.nvim_strwidth

local b16 = require 'ui.base16'
require('ui.utils').highlight {
	DashAscii = { fg = b16.magenta },
	DashFindFile = { fg = b16.brightyellow },
	DashFindWord = { fg = b16.brightred },
	DashRecentFiles = { fg = b16.blue },
	DashPlugins = { fg = b16.brightgreen },
	DashLine = { fg = b16.black },
	DashSettings = { fg = b16.brightmagenta },
}

local opts = {
	load_on_startup = false,
	header = {
		'                                                       ',
		' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
		' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
		' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
		' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
		' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
		' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
		'                                                       ',
		'                  󰛩  Time to Build! 󰛩                  ',
		'                                                       ',
	},

	buttons = {
		{ txt = '─', hl = 'DashLine', no_gap = true, rep = true },
		{
			txt = function()
				local stats = require('lazy').stats()
				local ms = math.floor(stats.startuptime) .. ' ms'
				return '  Loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms
			end,
			hl = 'DashPlugins',
			no_gap = true,
		},

		{ txt = '─', hl = 'DashLine', no_gap = true, rep = true },
		{ txt = '  Find File', hl = 'DashFindFile', keys = 'ff', cmd = 'Telescope find_files' },
		{ txt = '  Find Word', hl = 'DashFindWord', keys = 'fw', cmd = 'Telescope live_grep' },
		{ txt = '  Recent Files', hl = 'DashRecentFiles', keys = 'fo', cmd = 'Telescope oldfiles' },
		{ txt = '  Settings', hl = 'DashSettings', keys = 's', cmd = 'edit ~/.config/nvim/init.lua' },
	},
}

local map = function(keys, action, buf)
	for _, val in ipairs(keys) do
		vim.keymap.set('n', val, action, { buffer = buf })
	end
end

local txt_pad = function(str, max_str_w)
	local av = (max_str_w - strw(str)) / 2
	av = math.floor(av)
	return string.rep(' ', av) .. str .. string.rep(' ', av)
end

local btn_gap = function(txt1, txt2, max_str_w)
	local btn_len = strw(txt1) + #txt2
	local spacing = max_str_w - btn_len
	return txt1 .. string.rep(' ', spacing) .. txt2
end

return {
	open = function(buf, win, action)
		buf = buf or api.nvim_create_buf(false, true)
		win = win or api.nvim_get_current_win()
		action = action or 'open'

		local ns = api.nvim_create_namespace 'nvdash'
		local winh = api.nvim_win_get_height(win)
		local winw = api.nvim_win_get_width(win)

		g.dashboard_buf = buf
		g.dashboard_win = win

		local dashboard_w = 0

		if action == 'open' then api.nvim_win_set_buf(0, buf) end

		local header = type(opts.header) == 'function' and opts.header() or opts.header

		------------------------ find largest string's width -----------------------------
		for _, val in ipairs(header) do
			local headerw = strw(val)
			if headerw > dashboard_w then dashboard_w = headerw end
		end

		if #opts.buttons[1] == 3 then
			vim.schedule(function() vim.notify 'nvdash buttons: each item must have a txt, and cmd' end)
			return
		end

		for _, val in ipairs(opts.buttons) do
			local str = type(val.txt) == 'string' and val.txt or val.txt()
			str = val.keys and str .. val.keys or str
			local w = strw(str)

			if dashboard_w < w then dashboard_w = w end

			if val.keys then map({ val.keys }, '<cmd>' .. val.cmd .. '<cr>', buf) end
		end
		----------------------- save display txt -----------------------------------------
		local dashboard = {}

		for _, line in ipairs(header) do
			table.insert(dashboard, { txt = txt_pad(line, dashboard_w), hl = 'DashAscii' })
		end

		for _, item in ipairs(opts.buttons) do
			local txt

			if not item.keys then
				local str = type(item.txt) == 'string' and item.txt or item.txt()
				txt = item.rep and string.rep(str, dashboard_w) or txt_pad(str, dashboard_w)
			else
				txt = btn_gap(item.txt, item.keys, dashboard_w)
			end

			table.insert(dashboard, { txt = txt, hl = item.hl, cmd = item.cmd })

			if not item.no_gap then table.insert(dashboard, { txt = string.rep(' ', dashboard_w) }) end
		end

		-- if screen height is small
		if #dashboard > winh then winh = #dashboard + 10 end

		local row_i = math.floor((winh / 2) - (#dashboard / 2))
		local col_i = math.floor((winw / 2) - math.floor(dashboard_w / 2)) - 6 -- (5 is textoff)

		-- make all lines available
		local empty_str = {}

		for i = 1, winh do
			empty_str[i] = string.rep('', winw)
		end

		-- set text + highlight
		api.nvim_buf_set_lines(buf, 0, -1, false, empty_str)
		local key_lines = {}

		for i, item in ipairs(dashboard) do
			item.txt = '  ' .. item.txt .. '  '
			local opt = { virt_text_win_col = col_i, virt_text = { { item.txt, item.hl } } }
			api.nvim_buf_set_extmark(buf, ns, row_i + i, 0, opt)

			if item.cmd then table.insert(key_lines, { i = row_i + i + 1, cmd = item.cmd }) end
		end

		------------------------------------ keybinds ------------------------------------------
		vim.wo[win].virtualedit = 'all'
		local btn_start_i = row_i + #header + 2
		api.nvim_win_set_cursor(win, { btn_start_i, col_i + 5 })

		map({ 'k', '<up>' }, function()
			local cur = fn.line '.'
			local target_line = cur == key_lines[1].i and key_lines[#key_lines].i or cur - 2
			api.nvim_win_set_cursor(win, { target_line, col_i + 5 })
		end, buf)

		map({ 'j', '<down>' }, function()
			local cur = fn.line '.'
			local target_line = cur == key_lines[#key_lines].i and key_lines[1].i or cur + 2
			api.nvim_win_set_cursor(win, { target_line, col_i + 5 })
		end, buf)

		map({ '<cr>' }, function()
			local key = vim.tbl_filter(function(item) return item.i == fn.line '.' end, key_lines)

			if key[1] and key[1].cmd then vim.cmd(key[1].cmd) end
		end, buf)

		require('ui.utils').set_cleanbuf_opts('nvdash', buf)

		if action == 'redraw' then return end

		----------------------- autocmds -----------------------------
		local group_id = api.nvim_create_augroup('NvdashAu', { clear = true })

		api.nvim_create_autocmd('BufWinLeave', {
			group = group_id,
			buffer = buf,
			callback = function()
				g.dashboard_displayed = false
				api.nvim_del_augroup_by_name 'NvdashAu'
			end,
		})

		api.nvim_create_autocmd({ 'WinResized', 'VimResized' }, {
			group = group_id,
			callback = function()
				vim.bo[g.dashboard_buf].ma = true
				require('ui.dashboard').open(g.dashboard_buf, g.dashboard_win, 'redraw')
			end,
		})
	end,
}
