-- https://github.com/williamboman/mason.nvim
return {
	'williamboman/mason.nvim',
	cmd = {
		'Mason',
		'MasonInstall',
		'MasonInstallAll',
		'MasonUpdate',
	},

	opts = function()
		local b16 = require 'ui.base16'
		b16.highlight {
			MasonHeader = { fg = b16.brightmagenta },
			MasonHighlight = { fg = b16.blue },
			MasonHighlightBlock = { fg = b16.brightgreen },
			MasonHighlightBlockBold = { link = 'MasonHighlightBlock' },
			MasonHeaderSecondary = { link = 'MasonHighlightBlock' },
			MasonMuted = { fg = b16.grey },
			MasonMutedBlock = { fg = b16.black },
		}

		return {
			PATH = 'skip',
			ui = {
				icons = {
					package_pending = ' ',
					package_installed = ' ',
					package_uninstalled = ' ',
				},
			},
			max_concurrent_installers = 10,
			ensure_installed = {
				'lua-language-server',
				'stylua',
				'html-lsp',
				'css-lsp',
				'prettier',
				'pyre',
			},
		}
	end,
}
