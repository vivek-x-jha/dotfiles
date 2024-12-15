-- https://github.com/folke/noice.nvim
-- TODO update colorscheme

return {
	'folke/noice.nvim',
	event = 'VeryLazy',
	opts = function()
		local b16 = require 'ui.base16'
		b16.highlight {
			NoiceCmdlinePopupBorder = { fg = b16.brightgreen, bg = 'NONE' },
			NoiceCmdlinePopupTitle = { fg = b16.brightgreen, bg = 'NONE' },
			-- NoicePop = { fg = b16.black },
			NoicePopupmenuSelected = { fg = b16.green, bg = b16.grey },
			NoiceCmdlineIcon = { fg = b16.blue, bg = 'NONE' },
		}

		return {
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					['vim.lsp.util.convert_input_to_markdown_lines'] = true,
					['vim.lsp.util.stylize_markdown'] = true,
					['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
				},
				signature = { enabled = false },
			},
			presets = {
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
			},
		}
	end,
}
