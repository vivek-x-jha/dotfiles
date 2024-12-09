-- https://github.com/lewis6991/gitsigns.nvim
return {
	'lewis6991/gitsigns.nvim',
	event = 'User FilePost',
	opts = {
		signs = {
			add = { text = '+' },
			change = { text = '~' },
			delete = { text = '-' },
			topdelete = { text = '‾' },
			changedelete = { text = '/' },
			untracked = { text = '?' },
		},
	},
}
