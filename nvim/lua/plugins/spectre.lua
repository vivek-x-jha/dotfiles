-- https://github.com/nvim-pack/nvim-spectre
return {
	'nvim-pack/nvim-spectre',
	opts = function()
		vim.schedule(function()
			local b16 = require 'ui.base16'

			b16.highlight {
				SpectreHeader = { fg = b16.brightmagenta, bg = b16.background, bold = true },
				SpectreBody = { fg = b16.black, bg = b16.background, bold = true },
				SpectreFile = { fg = b16.yellow, bg = b16.background },
				SpectreDir = { fg = b16.blue, bg = b16.background },
				SpectreSearch = { fg = b16.brightred, bg = b16.grey },
				SpectreBorder = { fg = b16.brightblack, bg = b16.background },
				SpectreReplace = { fg = b16.brightgreen, bg = b16.grey },
			}
		end)

		-- Autocommand to turn off line numbers when Spectre is opened
		vim.api.nvim_create_autocmd('FileType', {
			pattern = 'spectre_panel',
			callback = function()
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false
			end,
		})

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
