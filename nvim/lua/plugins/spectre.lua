-- https://github.com/nvim-pack/nvim-spectre
return {
	'nvim-pack/nvim-spectre',
	opts = function()
		-- Force highlighting: spectre.setup() sets highlights after passing opts
		vim.schedule(require('ui.highlights').color_spectre)

		return {
			result_padding = '',
			default = {
				replace = {
					cmd = 'sed',
				},
			},
		}
	end,
}
