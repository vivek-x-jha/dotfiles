-- https://github.com/nvim-telescope/telescope.nvim
return {
	'nvim-telescope/telescope.nvim',
	lazy = false, --TODO figure out why this is needed
	opts = function()
		local actions = require 'telescope.actions'
		local b16 = require 'ui.base16'
		require('ui.utils').highlight {
			TelescopeBorder = { fg = b16.brightblack, bg = 'NONE' },
			TelescopeMatching = { fg = b16.brightred, bg = 'NONE' },
			TelescopeNormal = { fg = b16.brightblack, bg = 'NONE' },
			TelescopeSelection = { fg = b16.black, bg = 'NONE' },

			TelescopePromptBorder = { fg = b16.brightblack, bg = 'NONE' },
			TelescopePromptNormal = { fg = b16.white, bg = 'NONE' },
			TelescopePromptPrefix = { fg = b16.brightyellow, bg = 'NONE' },

			TelescopePromptTitle = { fg = b16.brightgreen, bg = 'NONE' },
			TelescopeResultsTitle = { fg = b16.magenta, bg = 'NONE' },
			TelescopePreviewTitle = { fg = b16.brightblue, bg = 'NONE' },

			TelescopeResultsDiffAdd = { fg = b16.green, bg = 'NONE' },
			TelescopeResultsDiffChange = { fg = b16.yellow, bg = 'NONE' },
			TelescopeResultsDiffDelete = { fg = b16.red, bg = 'NONE' },
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
		}
	end,
}
