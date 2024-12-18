local M = {}
local diag = vim.diagnostic
local sev = diag.severity
local icn = require 'ui.icons'

M.diagnostic_config = function()
	diag.config {
		virtual_text = { prefix = '' },
		signs = {
			text = {
				[sev.ERROR] = icn.error,
				[sev.WARN] = icn.warn,
				[sev.HINT] = icn.hint,
				[sev.INFO] = icn.info,
			},
		},
		underline = true,
		float = { border = 'single' },
	}

	-- Default border style
	local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = 'rounded'
		return orig_util_open_floating_preview(contents, syntax, opts, ...)
	end
end

return M
