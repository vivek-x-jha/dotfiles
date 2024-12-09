-- https://github.com/lukas-reineke/indent-blankline.nvim
return {
	'lukas-reineke/indent-blankline.nvim',
	event = 'User FilePost',
	main = 'ibl',
	opts = function()
		local b16 = require 'ui.base16'
		require('ui.utils').highlight {
			IblIndent = { fg = b16.brightblack },
			IblWhitespace = { fg = b16.grey },
			IblScope = { fg = b16.brightmagenta },
		}

		return { indent = { char = '┊' } }
	end,
}
