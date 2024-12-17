-- https://github.com/nvim-telescope/telescope.nvim
return {
	'nvim-telescope/telescope.nvim',
	lazy = false, --TODO figure out why this is needed
	opts = function()
		local actions = require 'telescope.actions'

		return {
			defaults = {
				prompt_prefix = '   ',
				selection_caret = ' ',
				entry_prefix = ' ',
				sorting_strategy = 'ascending',
				layout_config = {
					horizontal = {
						prompt_position = 'top',
						preview_width = 0.55,
					},
					width = 0.87,
					height = 0.80,
				},
				mappings = {
					n = { ['q'] = actions.close },
				},
			},
		}
	end,
}
