-- https://github.com/yetone/avante.nvim
return {
	'yetone/avante.nvim',
	event = 'VeryLazy',
	lazy = false,
	version = false,
	build = 'make',

	opts = function()
		local b16 = require 'ui.base16'
		require('ui.utils').highlight {
			AvanteTitle = { fg = b16.black2, bg = b16.vibrant_green },
			AvanteReversedTitle = { fg = b16.vibrant_green, bg = b16.black2 },
			AvanteSubtitle = { fg = b16.black2, bg = b16.nord_blue },
			AvanteReversedSubtitle = { fg = b16.nord_blue, bg = b16.black2 },
			AvanteThirdTitle = { bg = b16.white, fg = b16.black2 },
			AvanteReversedThirdTitle = { fg = b16.white },

			-- should be set automatically by other color groups

			-- AvanteConflictCurrent = {fg = '', bg = ''},
			-- AvanteConflictCurrentLabel = {fg = '', bg = ''},
			-- AvanteConflictIncoming = {fg = '', bg = ''},
			-- AvanteConflictIncomingLabel = {fg = '', bg = ''},
			-- AvantePopupHint = {fg = '', bg = ''},
			-- AvanteInlineHint = {fg = '', bg = ''}
		}

		return {
			provider = 'openai',
			openai = { model = 'gpt-4o-mini' },
		}
	end,
}
