-- https://github.com/rcarriga/nvim-notify
return {
	'rcarriga/nvim-notify',
	module = 'notify',
	opts = function()
		local b16 = require 'ui.base16'
		b16.highlight {

			NotifyERRORBorder = { fg = b16.brightred, bg = b16.background },
			NotifyERRORIcon = { fg = b16.brightred, bg = b16.background },
			NotifyERRORTitle = { fg = b16.brightred, bg = b16.background },

			NotifyWARNBorder = { fg = b16.brightyellow, bg = b16.background },
			NotifyWARNIcon = { fg = b16.brightyellow, bg = b16.background },
			NotifyWARNTitle = { fg = b16.brightyellow, bg = b16.background },

			NotifyINFOBorder = { fg = b16.brightblue, bg = b16.background },
			NotifyINFOIcon = { fg = b16.brightblue, bg = b16.background },
			NotifyINFOTitle = { fg = b16.brightblue, bg = b16.background },

			NotifyDEBUGBorder = { fg = b16.brightmagenta, bg = b16.background },
			NotifyDEBUGIcon = { fg = b16.brightmagenta, bg = b16.background },
			NotifyDEBUGTitle = { fg = b16.brightmagenta, bg = b16.background },

			NotifyTRACEBorder = { fg = b16.brightcyan, bg = b16.background },
			NotifyTRACEIcon = { fg = b16.brightcyan, bg = b16.background },
			NotifyTRACETitle = { fg = b16.brightcyan, bg = b16.background },
		}

		return {
			background_colour = '#000000',
			fps = 60,
			stages = 'fade',
		}
	end,
}
