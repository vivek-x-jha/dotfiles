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

local utils = require 'ui.statusline.utils'

return function()
	return utils.generate {
		['%='] = '%=',

		mode = function()
			if not utils.is_activewin() then return '' end

			local modes = utils.modes
			local m = vim.api.nvim_get_mode().mode
			return '%#St_' .. modes[m][2] .. 'mode#' .. ' ' .. modes[m][1] .. ' '
		end,

		cwd = function()
			local name = vim.uv.cwd()
			if not name then return '' end

			name = '%#St_cwd# ' .. (name:match '([^/\\]+)[/\\]*$' or name) .. ' '
			return (vim.o.columns > 85 and name) or ''
		end,

		git = utils.git,
		lsp_msg = utils.lsp_msg,
		diagnostics = utils.diagnostics,

		lsp = function() return '%#St_lsp#' .. utils.lsp() end,

		file = function()
			local icon = utils.file()[1]
			local name = utils.file()[2]
			return '%#St_file#' .. icon .. ' ' .. name .. ' '
		end,

		cursor = function() return '%#St_cursor#󰓾 %l:%c' end,
	}
end
