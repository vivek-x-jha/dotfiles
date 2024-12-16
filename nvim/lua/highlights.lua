local g = vim.g
local b16 = require 'ui.base16'

g.terminal_color_0 = b16.black
g.terminal_color_1 = b16.red
g.terminal_color_2 = b16.green
g.terminal_color_3 = b16.yellow
g.terminal_color_4 = b16.blue
g.terminal_color_5 = b16.magenta
g.terminal_color_6 = b16.cyan
g.terminal_color_7 = b16.white

g.terminal_color_8 = b16.brightblack
g.terminal_color_9 = b16.brightred
g.terminal_color_10 = b16.brightgreen
g.terminal_color_11 = b16.brightyellow
g.terminal_color_12 = b16.brightblue
g.terminal_color_13 = b16.brightmagenta
g.terminal_color_14 = b16.brightcyan
g.terminal_color_15 = b16.brightwhite

b16.highlight {

	-- Defaults
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

	FloatBorder = { fg = b16.brightblack },
	FloatTitle = { fg = b16.magenta },
	FoldColumn = { bg = b16.background },
	Folded = { fg = b16.black, bg = b16.black },
	IncSearch = { fg = b16.brightgreen, bg = b16.grey },
	LineNr = { fg = b16.brightblack },
	Macro = { fg = b16.white },
	MatchParen = { link = 'MatchWord' },
	MatchWord = { bg = b16.grey, fg = b16.brightred },
	ModeMsg = { fg = b16.green },
	MoreMsg = { fg = b16.green },
	NonText = { fg = b16.black },
	Normal = { fg = b16.white, bg = b16.background },
	NormalFloat = { bg = b16.background },
	NvimInternalError = { fg = b16.red },

	Pmenu = { bg = b16.dark },
	PmenuSbar = { bg = b16.dark },
	PmenuSel = { fg = b16.brightgreen, bg = b16.grey },
	PmenuThumb = { bg = b16.background },

	Question = { fg = b16.blue },
	QuickFixLine = { fg = b16.cyan, bg = b16.background },
	Removed = { fg = b16.red },
	Search = { fg = b16.brightred, bg = b16.grey },
	SignColumn = { fg = b16.black },
	SpecialKey = { fg = b16.black },
	Substitute = { fg = b16.brightred, bg = b16.grey },
	Title = { fg = b16.blue },
	TooLong = { fg = b16.white },
	Visual = { bg = b16.grey },
	VisualNOS = { fg = b16.white },
	WarningMsg = { fg = b16.white, bg = b16.background },
	WildMenu = { fg = b16.yellow, bg = b16.grey },
	WinBar = { bg = b16.background },
	WinBarNC = { bg = b16.background },
	WinSeparator = { fg = b16.brightblack },
	healthSuccess = { bg = b16.green, fg = b16.black },

	-- Git
	diffOldFile = { fg = b16.brightred },
	diffNewFile = { fg = b16.brightgreen },
	DiffAdd = { fg = b16.green },
	DiffAdded = { fg = b16.green },
	DiffChange = { fg = b16.yellow },
	DiffChangeDelete = { fg = b16.red },
	DiffModified = { fg = b16.yellow },
	DiffDelete = { fg = b16.red },
	DiffRemoved = { fg = b16.red },
	DiffText = { fg = b16.white, bg = b16.grey },

	gitcommitOverflow = { fg = b16.red },
	gitcommitSummary = { fg = b16.green },
	gitcommitComment = { fg = b16.grey },
	gitcommitUntracked = { fg = b16.grey },
	gitcommitDiscarded = { fg = b16.grey },
	gitcommitSelected = { fg = b16.grey },
	gitcommitHeader = { fg = b16.brightmagenta },
	gitcommitSelectedType = { fg = b16.blue },
	gitcommitUnmergedType = { fg = b16.blue },
	gitcommitDiscardedType = { fg = b16.blue },
	gitcommitBranch = { fg = b16.yellow, bold = true },
	gitcommitUntrackedFile = { fg = b16.yellow },
	gitcommitUnmergedFile = { fg = b16.red, bold = true },
	gitcommitDiscardedFile = { fg = b16.red, bold = true },
	gitcommitSelectedFile = { fg = b16.green, bold = true },

	-- Nvim-Tree
	NvimTreeNormal = { fg = b16.black },
	NvimTreeCursorLine = { bg = b16.dark, bold = true },
	NvimTreeFileName = { fg = b16.black },
	NvimTreeExecFile = { fg = b16.brightgreen },
	NvimTreeSpecialFile = { fg = b16.brightyellow },
	NvimTreeFolderIcon = { fg = b16.blue },
	NvimTreeIndentMarker = { fg = b16.brightmagenta },
	NvimTreeSymlink = { fg = b16.yellow },
	NvimTreeSymlinkFolderName = { fg = b16.yellow },

	NvimTreeGitNew = { fg = b16.red },
	NvimTreeGitDirty = { fg = b16.yellow },
	NvimTreeGitStaged = { fg = b16.green },
	NvimTreeGitRenamed = { link = 'NvimTreeGitStaged' },
}
