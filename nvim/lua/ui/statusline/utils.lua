local api = vim.api
local M = {}

M.stbufnr = function() return api.nvim_win_get_buf(vim.g.statusline_winid or 0) end

M.is_activewin = function() return api.nvim_get_current_win() == vim.g.statusline_winid end

local orders = { 'mode', 'git', 'file', '%=', 'lsp_msg', '%=', 'diagnostics', 'lsp', 'cwd', 'cursor' }

M.generate = function(modules)
	local result = {}

	for _, v in ipairs(orders) do
		local module = modules[v]
		module = type(module) == 'string' and module or module()
		table.insert(result, module)
	end

	return table.concat(result)
end

-- 2nd item is highlight groupname St_NormalMode
M.modes = {
	['n'] = { 'NORMAL', 'Normal' },
	['no'] = { 'NORMAL (no)', 'Normal' },
	['nov'] = { 'NORMAL (nov)', 'Normal' },
	['noV'] = { 'NORMAL (noV)', 'Normal' },
	['noCTRL-V'] = { 'NORMAL', 'Normal' },
	['niI'] = { 'NORMAL i', 'Normal' },
	['niR'] = { 'NORMAL r', 'Normal' },
	['niV'] = { 'NORMAL v', 'Normal' },
	['nt'] = { 'NTERMINAL', 'NTerminal' },
	['ntT'] = { 'NTERMINAL (ntT)', 'NTerminal' },

	['v'] = { 'VISUAL', 'Visual' },
	['vs'] = { 'V-CHAR (Ctrl O)', 'Visual' },
	['V'] = { 'V-LINE', 'Visual' },
	['Vs'] = { 'V-LINE', 'Visual' },
	[''] = { 'V-BLOCK', 'Visual' },

	['i'] = { 'INSERT', 'Insert' },
	['ic'] = { 'INSERT (completion)', 'Insert' },
	['ix'] = { 'INSERT completion', 'Insert' },

	['t'] = { 'TERMINAL', 'Terminal' },

	['R'] = { 'REPLACE', 'Replace' },
	['Rc'] = { 'REPLACE (Rc)', 'Replace' },
	['Rx'] = { 'REPLACEa (Rx)', 'Replace' },
	['Rv'] = { 'V-REPLACE', 'Replace' },
	['Rvc'] = { 'V-REPLACE (Rvc)', 'Replace' },
	['Rvx'] = { 'V-REPLACE (Rvx)', 'Replace' },

	['s'] = { 'SELECT', 'Select' },
	['S'] = { 'S-LINE', 'Select' },
	[''] = { 'S-BLOCK', 'Select' },
	['c'] = { 'COMMAND', 'Command' },
	['cv'] = { 'COMMAND', 'Command' },
	['ce'] = { 'COMMAND', 'Command' },
	['cr'] = { 'COMMAND', 'Command' },
	['r'] = { 'PROMPT', 'Confirm' },
	['rm'] = { 'MORE', 'Confirm' },
	['r?'] = { 'CONFIRM', 'Confirm' },
	['x'] = { 'CONFIRM', 'Confirm' },
	['!'] = { 'SHELL', 'Terminal' },
}

-- credits to ii14 for str:match func
M.file = function()
	local icon = '󰈚'
	local path = api.nvim_buf_get_name(M.stbufnr())
	local name = (path == '' and 'Empty') or path:match '([^/\\]+)[/\\]*$'

	if name ~= 'Empty' then
		local devicons_present, devicons = pcall(require, 'nvim-web-devicons')

		if devicons_present then
			local ft_icon = devicons.get_icon(name)
			icon = (ft_icon ~= nil and ft_icon) or icon
		end
	end

	return { icon, name }
end

M.git = function()
	if not vim.b[M.stbufnr()].gitsigns_head or vim.b[M.stbufnr()].gitsigns_git_status then return '' end

	local git_status = vim.b[M.stbufnr()].gitsigns_status_dict

	local added = (git_status.added and git_status.added ~= 0) and ('%#St_GitAdded#' .. ' +' .. git_status.added) or ''
	local changed = (git_status.changed and git_status.changed ~= 0) and ('%#St_GitChanged#' .. ' ~' .. git_status.changed) or ''
	local removed = (git_status.removed and git_status.removed ~= 0) and ('%#St_GitRemoved#' .. ' -' .. git_status.removed) or ''
	local branch_name = '%#St_GitBranch#' .. ' ' .. git_status.head

	return branch_name .. added .. changed .. removed .. ' '
end

M.lsp_msg = function() return vim.o.columns < 120 and '' or M.state.lsp_msg end

M.lsp = function()
	if rawget(vim, 'lsp') then
		for _, client in ipairs(vim.lsp.get_clients()) do
			if client.attached_buffers[M.stbufnr()] then return (vim.o.columns > 100 and '  ' .. client.name .. ' ') or '  LSP ' end
		end
	end

	return ''
end

M.diagnostics = function()
	if not rawget(vim, 'lsp') then return '' end

	local diag = vim.diagnostic
	local sev = diag.severity

	local err_cnt = #diag.get(M.stbufnr(), { severity = sev.ERROR })
	local warn_cnt = #diag.get(M.stbufnr(), { severity = sev.WARN })
	local hints_cnt = #diag.get(M.stbufnr(), { severity = sev.HINT })
	local info_cnt = #diag.get(M.stbufnr(), { severity = sev.INFO })

	local err = (err_cnt and err_cnt > 0) and ('%#St_lspError#' .. '󰯈 ' .. tostring(err_cnt) .. ' ') or ''
	local warn = (warn_cnt and warn_cnt > 0) and ('%#St_lspWarning#' .. ' ' .. tostring(warn_cnt) .. ' ') or ''
	local hints = (hints_cnt and hints_cnt > 0) and ('%#St_lspHints#' .. ' ' .. tostring(hints_cnt) .. ' ') or ''
	local info = (info_cnt and info_cnt > 0) and ('%#St_lspInfo#' .. ' ' .. tostring(info_cnt) .. ' ') or ''

	return ' ' .. err .. warn .. hints .. info
end

M.separators = {
	default = { left = '', right = '' },
	round = { left = '', right = '' },
	block = { left = '█', right = '█' },
	arrow = { left = '', right = '' },
}

M.state = { lsp_msg = '' }

M.autocmds = function()
	api.nvim_create_autocmd('LspProgress', {
		pattern = { 'begin', 'end' },
		callback = function(args)
			local data = args.data.params.value
			local progress = ''

			if data.percentage then
				local spinners = { '', '', '', '󰪞', '󰪟', '󰪠', '󰪢', '󰪣', '󰪤', '󰪥' }
				local idx = math.max(1, math.floor(data.percentage / 10))
				local icon = spinners[idx]
				progress = icon .. ' ' .. data.percentage .. '%% '
			end

			local str = progress .. (data.message or '') .. ' ' .. (data.title or '')
			M.state.lsp_msg = data.kind == 'end' and '' or str
			vim.cmd.redrawstatus()
		end,
	})
end

return M
