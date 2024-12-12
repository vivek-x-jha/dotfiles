-- https://github.com/folke/which-key.nvim
return {
	'folke/which-key.nvim',
	keys = { '<leader>', '<c-w>', '"', "'", '`', 'c', 'v', 'g' },
	cmd = 'WhichKey',
	opts = function()
		local b16 = require 'ui.base16'
		require('ui.utils').highlight {
			WhichKey = { fg = b16.yellow },
			WhichKeySeparator = { fg = b16.black },
			WhichKeyDesc = { fg = b16.blue },
			WhichKeyGroup = { fg = b16.yellow },
			WhichKeyValue = { fg = b16.brightmagenta },
		}
		return {}
	end,
}
