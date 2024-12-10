local b16 = require 'ui.base16'
require('ui.utils').highlight {

	Added = { fg = b16.green },
	Changed = { fg = b16.yellow },
	ColorColumn = { bg = b16.black },
	Comment = { fg = b16.brightblack },
	Conceal = { bg = b16.background },
	Cursor = { fg = b16.black, bg = b16.grey },
	CursorColumn = { bg = b16.black },
	CursorLine = { bg = b16.black },
	CursorLineNr = { fg = b16.black },
	Debug = { fg = b16.white },
	DevIconDefault = { fg = b16.red },
	Directory = { fg = b16.blue },
	Error = { fg = b16.black, bg = b16.white },
	ErrorMsg = { fg = b16.red, bg = b16.background },
	Exception = { fg = b16.brightred },

	FloatBorder = { fg = b16.blue },
	FloatTitle = { fg = b16.magenta },
	FoldColumn = { bg = b16.background },
	Folded = { fg = b16.black, bg = b16.black },
	IncSearch = { fg = b16.black, bg = b16.orange },
	LineNr = { fg = b16.brightblack },
	Macro = { fg = b16.white },
	MatchParen = { link = 'MatchWord' },
	MatchWord = { bg = b16.grey, fg = b16.brightyellow },
	ModeMsg = { fg = b16.green },
	MoreMsg = { fg = b16.green },
	NonText = { fg = b16.black },
	Normal = { fg = b16.white, bg = b16.background },
	NormalFloat = { bg = b16.background },
	NvimInternalError = { fg = b16.red },
	Pmenu = { bg = b16.one_bg },
	PmenuSbar = { bg = b16.one_bg },
	PmenuSel = { bg = b16.white, fg = b16.black },
	PmenuThumb = { bg = b16.black },
	Question = { fg = b16.blue },
	QuickFixLine = { fg = b16.brightred, bg = b16.background },
	Removed = { fg = b16.red },
	Search = { fg = b16.black, bg = b16.yellow },
	SignColumn = { fg = b16.black },
	SpecialKey = { fg = b16.black },
	Substitute = { fg = b16.black, bg = b16.yellow },
	Title = { fg = b16.blue },
	TooLong = { fg = b16.white },
	Visual = { bg = b16.grey },
	VisualNOS = { fg = b16.white },
	WarningMsg = { fg = b16.white, bg = b16.background },
	WildMenu = { fg = b16.white, bg = b16.yellow },
	WinBar = { bg = b16.background },
	WinBarNC = { bg = b16.background },
	WinSeparator = { fg = b16.brightblack },
	healthSuccess = { bg = b16.green, fg = b16.black },
}
