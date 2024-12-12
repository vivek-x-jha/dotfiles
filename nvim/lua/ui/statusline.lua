local api = vim.api
local g = vim.g

local orders = { 'mode', 'git', 'file', '%=', 'lsp_msg', '%=', 'diagnostics', 'lsp', 'cwd', 'cursor' }

---------------------------- Highlight Groups ----------------------------------
local b16 = require 'ui.base16'

require('ui.utils').highlight {
	-- StatusLine Highlights
	StatusLine = { fg = b16.brightred, bg = 'NONE' },
	StText = { fg = b16.brightred, bg = 'NONE' },

	St_file = { fg = b16.black, bg = 'NONE' },
	St_cursor = { fg = b16.black, bg = 'NONE' },
	St_cwd = { fg = b16.blue, bg = 'NONE' },
	St_ft = { fg = b16.brightblue, bg = 'NONE' },

	-- LSP Highlights
	St_lspMsg = { fg = b16.brightmagenta, bg = 'NONE' },
	St_lspError = { fg = b16.brightred, bg = 'NONE' },
	St_lspWarning = { fg = b16.brightyellow, bg = 'NONE' },
	St_lspHints = { fg = b16.brightmagenta, bg = 'NONE' },
	St_lspInfo = { fg = b16.brightblue, bg = 'NONE' },
	St_lsp = { fg = b16.cyan, bg = 'NONE' },

	-- Git Highlights
	St_GitAdded = { fg = b16.green, bg = 'NONE' },
	St_GitChanged = { fg = b16.yellow, bg = 'NONE' },
	St_GitRemoved = { fg = b16.red, bg = 'NONE' },
	St_GitBranch = { fg = b16.magenta, bg = 'NONE' },

	-- Mode Highlights
	St_NormalMode = { fg = b16.brightblue, bg = 'NONE' },
	St_VisualMode = { fg = b16.brightcyan, bg = 'NONE' },
	St_InsertMode = { fg = b16.brightred, bg = 'NONE' },
	St_TerminalMode = { fg = b16.brightgreen, bg = 'NONE' },
	St_NTerminalMode = { fg = b16.yellow, bg = 'NONE' },
	St_ReplaceMode = { fg = b16.brightyellow, bg = 'NONE' },
	St_ConfirmMode = { fg = b16.cyan, bg = 'NONE' },
	St_CommandMode = { fg = b16.brightgreen, bg = 'NONE' },
	St_SelectMode = { fg = b16.blue, bg = 'NONE' },
}

---------------------------- Helper Functions ----------------------------------
local utl = {
	state = { lsp_msg = '' },

	stbufnr = function() return api.nvim_win_get_buf(g.statusline_winid or 0) end,

	is_activewin = function() return api.nvim_get_current_win() == g.statusline_winid end,

	generate = function(modules)
		local result = {}

		for _, v in ipairs(orders) do
			local module = modules[v]
			module = type(module) == 'string' and module or module()
			table.insert(result, module)
		end

		return table.concat(result)
	end,

	-- 2nd item is highlight groupname St_NormalMode
	modes = {
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
	},
}

local stl = {
	file = function()
		local icon = '󰈚'
		local path = api.nvim_buf_get_name(utl.stbufnr())
		local name = (path == '' and 'Empty') or path:match '([^/\\]+)[/\\]*$'

		if name ~= 'Empty' then
			local devicons_present, devicons = pcall(require, 'nvim-web-devicons')

			if devicons_present then
				local ft_icon = devicons.get_icon(name)
				icon = (ft_icon ~= nil and ft_icon) or icon
			end
		end

		return { icon, name }
	end,

	git = function()
		if not vim.b[utl.stbufnr()].gitsigns_head or vim.b[utl.stbufnr()].gitsigns_git_status then return '' end

		local git_status = vim.b[utl.stbufnr()].gitsigns_status_dict

		local added = (git_status.added and git_status.added ~= 0) and ('%#St_GitAdded#' .. ' +' .. git_status.added) or ''
		local changed = (git_status.changed and git_status.changed ~= 0) and ('%#St_GitChanged#' .. ' ~' .. git_status.changed) or ''
		local removed = (git_status.removed and git_status.removed ~= 0) and ('%#St_GitRemoved#' .. ' -' .. git_status.removed) or ''
		local branch_name = '%#St_GitBranch#' .. ' ' .. git_status.head

		return branch_name .. added .. changed .. removed .. ' '
	end,

	lsp_msg = function() return vim.o.columns < 120 and '' or utl.state.lsp_msg end,

	lsp = function()
		if rawget(vim, 'lsp') then
			for _, client in ipairs(vim.lsp.get_clients()) do
				if client.attached_buffers[utl.stbufnr()] then return (vim.o.columns > 100 and '  ' .. client.name .. ' ') or '  LSP ' end
			end
		end

		return ''
	end,

	diagnostics = function()
		if not rawget(vim, 'lsp') then return '' end

		local bufnum = utl.stbufnr()
		local diag = vim.diagnostic
		local sev = diag.severity

		local err_cnt = #diag.get(bufnum, { severity = sev.ERROR })
		local warn_cnt = #diag.get(bufnum, { severity = sev.WARN })
		local hints_cnt = #diag.get(bufnum, { severity = sev.HINT })
		local info_cnt = #diag.get(bufnum, { severity = sev.INFO })

		local err = (err_cnt and err_cnt > 0) and ('%#St_lspError#' .. '󰯈 ' .. tostring(err_cnt) .. ' ') or ''
		local warn = (warn_cnt and warn_cnt > 0) and ('%#St_lspWarning#' .. ' ' .. tostring(warn_cnt) .. ' ') or ''
		local hints = (hints_cnt and hints_cnt > 0) and ('%#St_lspHints#' .. ' ' .. tostring(hints_cnt) .. ' ') or ''
		local info = (info_cnt and info_cnt > 0) and ('%#St_lspInfo#' .. ' ' .. tostring(info_cnt) .. ' ') or ''

		return ' ' .. err .. warn .. hints .. info
	end,
}

------------------------ Output Statusline Elements -----------------------------
return {
	autocmds = function()
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
				utl.state.lsp_msg = data.kind == 'end' and '' or str
				vim.cmd.redrawstatus()
			end,
		})
	end,

	init = function()
		return utl.generate {
			['%='] = '%=',

			mode = function()
				if not utl.is_activewin() then return '' end

				local modes = utl.modes
				local m = api.nvim_get_mode().mode
				return '%#St_' .. modes[m][2] .. 'mode#' .. ' ' .. modes[m][1] .. ' '
			end,

			cwd = function()
				local name = vim.uv.cwd()
				if not name then return '' end

				name = '%#St_cwd# ' .. (name:match '([^/\\]+)[/\\]*$' or name) .. ' '
				return (vim.o.columns > 85 and name) or ''
			end,

			git = stl.git,
			lsp_msg = stl.lsp_msg,
			diagnostics = stl.diagnostics,

			lsp = function() return '%#St_lsp#' .. stl.lsp() end,

			file = function()
				local icon = stl.file()[1]
				local name = stl.file()[2]
				return '%#St_file#' .. icon .. ' ' .. name .. ' '
			end,

			cursor = function() return '%#St_cursor#󰓾 %l:%c' end,
		}
	end,
}
