-- https://github.com/nvim-treesitter/nvim-treesitter
return {
	'nvim-treesitter/nvim-treesitter',
	event = { 'BufReadPost', 'BufNewFile' },
	cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
	build = ':TSUpdate',
	opts = function()
		local b16 = require 'ui.base16'
		b16.highlight {

			-- syntax
			Boolean = { fg = b16.red },
			Character = { fg = b16.base08 },
			Conditional = { fg = b16.magenta },
			Constant = { fg = b16.black },
			Define = { fg = b16.magenta, sp = 'none' },
			Delimiter = { fg = b16.base0F },
			Float = { fg = b16.brightyellow },
			Variable = { fg = b16.base05 },
			Function = { fg = b16.blue },
			Identifier = { fg = b16.base08, sp = 'none' },
			Include = { fg = b16.base0D },
			Keyword = { fg = b16.base0E },
			Label = { fg = b16.base0A },
			Number = { fg = b16.brightyellow },
			Operator = { fg = b16.base05, sp = 'none' },
			PreProc = { fg = b16.base0A },
			Repeat = { fg = b16.base0A },
			Special = { fg = b16.base0C },
			SpecialChar = { fg = b16.base0F },
			Statement = { fg = b16.base08 },
			StorageClass = { fg = b16.base0A },
			String = { fg = b16.green },
			Structure = { fg = b16.base0E },
			Tag = { fg = b16.base0A },
			Todo = { fg = b16.cyan },
			Type = { fg = b16.base0A, sp = 'none' },
			Typedef = { fg = b16.base0A },

			-- treesitter
			['@variable'] = { fg = b16.black },
			['@variable.builtin'] = { fg = b16.yellow },
			['@variable.parameter'] = { fg = b16.white },
			['@variable.member'] = { fg = b16.white },
			['@variable.member.key'] = { fg = b16.white },

			['@module'] = { fg = b16.white },
			-- ["@module.builtin"] = { fg = b16.white },

			['@constant'] = { fg = b16.white },
			['@constant.builtin'] = { fg = b16.yellow },
			['@constant.macro'] = { fg = b16.white },

			['@string'] = { fg = b16.green },
			['@string.regex'] = { fg = b16.cyan },
			['@string.escape'] = { fg = b16.cyan },
			['@character'] = { fg = b16.white },
			-- ["@character.special"] = { fg = b16.white },
			['@number'] = { fg = b16.red },
			['@number.float'] = { fg = b16.red },

			['@annotation'] = { fg = b16.black },
			['@attribute'] = { fg = b16.yellow },
			['@error'] = { fg = b16.white },

			['@keyword.exception'] = { fg = b16.white },
			['@keyword'] = { fg = b16.magenta },
			['@keyword.function'] = { fg = b16.magenta },
			['@keyword.return'] = { fg = b16.magenta },
			['@keyword.operator'] = { fg = b16.magenta },
			['@keyword.import'] = { link = 'Include' },
			['@keyword.conditional'] = { fg = b16.magenta },
			['@keyword.conditional.ternary'] = { fg = b16.magenta },
			['@keyword.repeat'] = { fg = b16.yellow },
			['@keyword.storage'] = { fg = b16.yellow },
			['@keyword.directive.define'] = { fg = b16.magenta },
			['@keyword.directive'] = { fg = b16.yellow },

			['@function'] = { fg = b16.blue },
			['@function.builtin'] = { fg = b16.blue },
			['@function.macro'] = { fg = b16.white },
			['@function.call'] = { fg = b16.blue },
			['@function.method'] = { fg = b16.blue },
			['@function.method.call'] = { fg = b16.blue },
			['@constructor'] = { fg = b16.cyan },

			['@operator'] = { fg = b16.black },
			['@reference'] = { fg = b16.black },
			['@punctuation.bracket'] = { fg = b16.black },
			['@punctuation.delimiter'] = { fg = b16.black },
			['@symbol'] = { fg = b16.green },
			['@tag'] = { fg = b16.yellow },
			['@tag.attribute'] = { fg = b16.white },
			['@tag.delimiter'] = { fg = b16.black },
			['@text'] = { fg = b16.black },
			['@text.emphasis'] = { fg = b16.yellow },
			['@text.strike'] = { fg = b16.black, strikethrough = true },
			['@type.builtin'] = { fg = b16.yellow },
			['@definition'] = { sp = b16.dark_foreground, underline = true },
			['@scope'] = { bold = true },
			['@property'] = { fg = b16.white },

			-- markup
			['@markup.heading'] = { fg = b16.blue },
			['@markup.raw'] = { fg = b16.yellow },
			['@markup.link'] = { fg = b16.white },
			['@markup.link.url'] = { fg = b16.yellow, underline = true },
			['@markup.link.label'] = { fg = b16.cyan },
			['@markup.list'] = { fg = b16.white },
			['@markup.strong'] = { bold = true },
			['@markup.underline'] = { underline = true },
			['@markup.italic'] = { italic = true },
			['@markup.strikethrough'] = { strikethrough = true },
			['@markup.quote'] = { bg = b16.red },

			['@comment'] = { fg = b16.brightblack },
			['@comment.todo'] = { fg = b16.brightmagenta },
			['@comment.warning'] = { fg = b16.brightyellow },
			['@comment.note'] = { fg = b16.brightcyan },
			['@comment.danger'] = { fg = b16.brightred },

			['@diff.plus'] = { fg = b16.green },
			['@diff.minus'] = { fg = b16.red },
			['@diff.delta'] = { fg = b16.black },
		}

		return {
			ensure_installed = {
				'bash',
				'fish',
				'lua',
				'luadoc',
				'markdown',
				'printf',
				'toml',
				'vim',
				'vimdoc',
				'yaml',
			},

			highlight = {
				enable = true,
				use_languagetree = true,
			},

			indent = { enable = true },
		}
	end,
}
