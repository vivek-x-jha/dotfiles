-- https://github.com/nvim-pack/nvim-spectre
return {
	'nvim-pack/nvim-spectre',
	opts = function()
		return {
			result_padding = '',
			default = {
				replace = {
					cmd = 'sed',
				},
			},
		}
	end,
	-- keys = {
	--   { '<leader>sr', '<cmd>lua require("spectre").open()<CR>', desc = 'Open Spectre' },
	--   { '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', desc = 'Search Current Word' },
	--   { '<leader>sp', '<cmd>lua require("spectre").open_file_search()<CR>', desc = 'Search in Current File' },
	-- },
}
