-- https://github.com/nvim-tree/nvim-web-devicons
return {
	'nvim-tree/nvim-web-devicons',
	opts = function()
		local b16 = require 'ui.base16'
		b16.highlight {

			DevIconc = { fg = b16.blue },
			DevIconcss = { fg = b16.blue },
			DevIcondeb = { fg = b16.cyan },
			DevIconDockerfile = { fg = b16.cyan },
			DevIconhtml = { fg = b16.brightred },
			DevIconjpeg = { fg = b16.magenta },
			DevIconjpg = { fg = b16.magenta },
			DevIconjs = { fg = b16.yellow },
			DevIconkt = { fg = b16.brightyellow },
			DevIconlock = { fg = b16.red },
			DevIconlua = { fg = b16.blue },
			DevIconmp3 = { fg = b16.white },
			DevIconmp4 = { fg = b16.white },
			DevIconout = { fg = b16.white },
			DevIconpng = { fg = b16.magenta },
			DevIconpy = { fg = b16.cyan },
			DevIcontoml = { fg = b16.blue },
			DevIconts = { fg = b16.brightcyan },
			DevIconttf = { fg = b16.white },
			DevIconrb = { fg = b16.magenta },
			DevIconrpm = { fg = b16.brightyellow },
			DevIconvue = { fg = b16.brightgreen },
			DevIconwoff = { fg = b16.white },
			DevIconwoff2 = { fg = b16.white },
			DevIconxz = { fg = b16.yellow },
			DevIconzip = { fg = b16.yellow },
			DevIconZig = { fg = b16.brightyellow },
			DevIconMd = { fg = b16.blue },
			DevIconTSX = { fg = b16.blue },
			DevIconJSX = { fg = b16.blue },
			DevIconSvelte = { fg = b16.red },
			DevIconJava = { fg = b16.brightyellow },
			DevIconDart = { fg = b16.cyan },
		}

		return {
			override = {
				default_icon = { icon = '󰈚', name = 'Default' },
				js = { icon = '󰌞', name = 'js' },
				ts = { icon = '󰛦', name = 'ts' },
				lock = { icon = '󰌾', name = 'lock' },
				['robots.txt'] = { icon = '󰚩', name = 'robots' },
			},
		}
	end,
}
