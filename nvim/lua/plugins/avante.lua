-- https://github.com/yetone/avante.nvim
return {
	'yetone/avante.nvim',
	event = 'VeryLazy',
	lazy = false,
	version = false,
	build = 'make',

	opts = {
		provider = 'openai',
		openai = { model = 'gpt-4o-mini' },
	},
}
