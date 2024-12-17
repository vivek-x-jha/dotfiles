-- https://github.com/nvim-pack/nvim-spectre
return {
	'nvim-pack/nvim-spectre',
	opts = function()
		-- Force highlighting: spectre.setup() sets highlights after passing opts
		vim.schedule(function()
			local theme = require('themes.' .. vim.g.theme)

			local set_highlight_groups = function(highlights)
				for hlgroup, hlopts in pairs(highlights) do
					vim.api.nvim_set_hl(0, hlgroup, hlopts)
				end
			end

			set_highlight_groups {
				SpectreHeader = { fg = theme.brightmagenta, bg = theme.background, bold = true },
				SpectreBody = { fg = theme.black, bg = theme.background, bold = true },
				SpectreFile = { fg = theme.yellow, bg = theme.background },
				SpectreDir = { fg = theme.blue, bg = theme.background },
				SpectreSearch = { fg = theme.brightred, bg = theme.grey },
				SpectreBorder = { fg = theme.brightblack, bg = theme.background },
				SpectreReplace = { fg = theme.brightgreen, bg = theme.grey },
			}
		end)

		-- Turn off line numbers for (and only for) Spectre buffers
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
