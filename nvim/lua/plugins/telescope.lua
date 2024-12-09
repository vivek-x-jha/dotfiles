-- https://github.com/nvim-telescope/telescope.nvim
return {
	'nvim-telescope/telescope.nvim',
	opts = function()
		local actions = require 'telescope.actions'
		local b16 = require 'ui.base16'
		require('ui.utils').highlight {

			TelescopeBorder = b16.brightblack,
			TelescopeMatching = b16.brightred,
			TelescopeNormal = b16.brightblack,
			TelescopeSelection = b16.black,

			TelescopePromptBorder = b16.brightblack,
			TelescopePromptNormal = b16.white,
			TelescopePromptPrefix = b16.brightyellow,

			TelescopePromptTitle = b16.brightgreen,
			TelescopeResultsTitle = b16.magenta,
			TelescopePreviewTitle = b16.brightblue,

			TelescopeResultsDiffAdd = b16.green,
			TelescopeResultsDiffChange = b16.yellow,
			TelescopeResultsDiffDelete = b16.red,
		}

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

			extensions_list = {},
			extensions = {},
		}
	end,
}
