-- https://github.com/nvim-tree/nvim-web-devicons
return {
	'nvim-tree/nvim-web-devicons',
	opts = {
		override = {
			default_icon = { icon = '󰈚', name = 'Default' },
			js = { icon = '󰌞', name = 'js' },
			ts = { icon = '󰛦', name = 'ts' },
			lock = { icon = '󰌾', name = 'lock' },
			['robots.txt'] = { icon = '󰚩', name = 'robots' },
		},
	},
}
