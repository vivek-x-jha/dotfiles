local M = {}
local utl = {}
local g = vim.g
local theme_exists, theme = pcall(require, g.theme)

if not theme_exists then
	local err_msg = 'Highlights not loaded! "~/.config/nvim/lua/themes/' .. g.theme .. '.lua" not found'
	vim.notify(err_msg, vim.log.levels.ERROR)
	return
end

utl.highlight = function(highlight_groups)
	for hlgroup, hlopts in pairs(highlight_groups) do
		vim.api.nvim_set_hl(0, hlgroup, hlopts)
	end
end

M.setup = function(plugin)
	---------------------------- Spectre ----------------------------------

	if plugin == 'spectre' then
		utl.highlight {
			SpectreHeader = { fg = theme.brightmagenta, bg = theme.background, bold = true },
			SpectreBody = { fg = theme.black, bg = theme.background, bold = true },
			SpectreFile = { fg = theme.yellow, bg = theme.background },
			SpectreDir = { fg = theme.blue, bg = theme.background },
			SpectreSearch = { fg = theme.brightred, bg = theme.grey },
			SpectreBorder = { fg = theme.brightblack, bg = theme.background },
			SpectreReplace = { fg = theme.brightgreen, bg = theme.grey },
		}
		return
	end

	---------------------------- Terminal ----------------------------------

	g.terminal_color_0 = theme.black
	g.terminal_color_1 = theme.red
	g.terminal_color_2 = theme.green
	g.terminal_color_3 = theme.yellow
	g.terminal_color_4 = theme.blue
	g.terminal_color_5 = theme.magenta
	g.terminal_color_6 = theme.cyan
	g.terminal_color_7 = theme.white

	g.terminal_color_8 = theme.brightblack
	g.terminal_color_9 = theme.brightred
	g.terminal_color_10 = theme.brightgreen
	g.terminal_color_11 = theme.brightyellow
	g.terminal_color_12 = theme.brightblue
	g.terminal_color_13 = theme.brightmagenta
	g.terminal_color_14 = theme.brightcyan
	g.terminal_color_15 = theme.brightwhite

	utl.highlight {
		---------------------------- Defaults ----------------------------------

		Added = { fg = theme.green },
		Changed = { fg = theme.yellow },
		ColorColumn = { bg = theme.black },
		Comment = { fg = theme.brightblack },
		Conceal = { bg = theme.background },
		Cursor = { fg = theme.black, bg = theme.grey },
		CursorColumn = { bg = theme.black },
		CursorLine = { bg = theme.black },
		CursorLineNr = { fg = theme.black },
		Debug = { fg = theme.white },
		DevIconDefault = { fg = theme.red },
		Directory = { fg = theme.blue },
		Error = { fg = theme.black, bg = theme.white },
		ErrorMsg = { fg = theme.red, bg = theme.background },
		Exception = { fg = theme.brightred },

		FloatBorder = { fg = theme.brightblack },
		FloatTitle = { fg = theme.magenta },
		FoldColumn = { bg = theme.background },
		Folded = { fg = theme.black, bg = theme.black },
		IncSearch = { fg = theme.brightgreen, bg = theme.grey },
		LineNr = { fg = theme.brightblack },
		Macro = { fg = theme.white },
		MatchParen = { link = 'MatchWord' },
		MatchWord = { bg = theme.grey, fg = theme.brightred },
		ModeMsg = { fg = theme.green },
		MoreMsg = { fg = theme.green },
		NonText = { fg = theme.black },
		Normal = { fg = theme.white, bg = theme.background },
		NormalFloat = { bg = theme.background },
		NvimInternalError = { fg = theme.red },

		Pmenu = { bg = theme.dark },
		PmenuSbar = { bg = theme.dark },
		PmenuSel = { fg = theme.brightgreen, bg = theme.grey },
		PmenuThumb = { bg = theme.background },

		Question = { fg = theme.blue },
		QuickFixLine = { fg = theme.cyan, bg = theme.background },
		Removed = { fg = theme.red },
		Search = { fg = theme.brightred, bg = theme.grey },
		SignColumn = { fg = theme.black },
		SpecialKey = { fg = theme.black },
		Substitute = { fg = theme.brightred, bg = theme.grey },
		Title = { fg = theme.blue },
		TooLong = { fg = theme.white },
		Visual = { bg = theme.grey },
		VisualNOS = { fg = theme.white },
		WarningMsg = { fg = theme.white, bg = theme.background },
		WildMenu = { fg = theme.yellow, bg = theme.grey },
		WinBar = { bg = theme.background },
		WinBarNC = { bg = theme.background },
		WinSeparator = { fg = theme.brightblack },
		healthSuccess = { bg = theme.green, fg = theme.black },

		---------------------------- Syntax ----------------------------------

		Boolean = { fg = theme.red },
		Character = { fg = theme.base08 },
		Conditional = { fg = theme.magenta },
		Constant = { fg = theme.black },
		Define = { fg = theme.magenta, sp = 'none' },
		Delimiter = { fg = theme.base0F },
		Float = { fg = theme.brightyellow },
		Variable = { fg = theme.base05 },
		Function = { fg = theme.blue },
		Identifier = { fg = theme.base08, sp = 'none' },
		Include = { fg = theme.base0D },
		Keyword = { fg = theme.magenta },
		Label = { fg = theme.base0A },
		Number = { fg = theme.brightyellow },
		Operator = { fg = theme.base05, sp = 'none' },
		PreProc = { fg = theme.base0A },
		Repeat = { fg = theme.base0A },
		Special = { fg = theme.base0C },
		SpecialChar = { fg = theme.base0F },
		Statement = { fg = theme.base08 },
		StorageClass = { fg = theme.base0A },
		String = { fg = theme.green },
		Structure = { fg = theme.base0E },
		Tag = { fg = theme.base0A },
		Todo = { fg = theme.cyan },
		Type = { fg = theme.base0A, sp = 'none' },
		Typedef = { fg = theme.base0A },

		-- Treesitter
		['@variable'] = { fg = theme.black },
		['@variable.builtin'] = { fg = theme.yellow },
		['@variable.parameter'] = { fg = theme.white },
		['@variable.member'] = { fg = theme.white },
		['@variable.member.key'] = { fg = theme.white },

		['@module'] = { fg = theme.white },
		-- ["@module.builtin"] = { fg = theme.white },

		['@constant'] = { fg = theme.white },
		['@constant.builtin'] = { fg = theme.yellow },
		['@constant.macro'] = { fg = theme.white },

		['@string'] = { fg = theme.green },
		['@string.regex'] = { fg = theme.cyan },
		['@string.escape'] = { fg = theme.cyan },
		['@character'] = { fg = theme.white },
		-- ["@character.special"] = { fg = theme.white },
		['@number'] = { fg = theme.red },
		['@number.float'] = { fg = theme.red },

		['@annotation'] = { fg = theme.black },
		['@attribute'] = { fg = theme.yellow },
		['@error'] = { fg = theme.white },

		['@keyword.exception'] = { fg = theme.white },
		['@keyword'] = { fg = theme.magenta },
		['@keyword.function'] = { fg = theme.magenta },
		['@keyword.return'] = { fg = theme.magenta },
		['@keyword.operator'] = { fg = theme.magenta },
		['@keyword.import'] = { link = 'Include' },
		['@keyword.conditional'] = { fg = theme.magenta },
		['@keyword.conditional.ternary'] = { fg = theme.magenta },
		['@keyword.repeat'] = { fg = theme.yellow },
		['@keyword.storage'] = { fg = theme.yellow },
		['@keyword.directive.define'] = { fg = theme.magenta },
		['@keyword.directive'] = { fg = theme.yellow },

		['@function'] = { fg = theme.blue },
		['@function.builtin'] = { fg = theme.blue },
		['@function.macro'] = { fg = theme.white },
		['@function.call'] = { fg = theme.blue },
		['@function.method'] = { fg = theme.blue },
		['@function.method.call'] = { fg = theme.blue },
		['@constructor'] = { fg = theme.cyan },

		['@operator'] = { fg = theme.black },
		['@reference'] = { fg = theme.black },
		['@punctuation.bracket'] = { fg = theme.black },
		['@punctuation.delimiter'] = { fg = theme.black },
		['@symbol'] = { fg = theme.green },
		['@tag'] = { fg = theme.yellow },
		['@tag.attribute'] = { fg = theme.white },
		['@tag.delimiter'] = { fg = theme.black },
		['@text'] = { fg = theme.black },
		['@text.emphasis'] = { fg = theme.yellow },
		['@text.strike'] = { fg = theme.black, strikethrough = true },
		['@type.builtin'] = { fg = theme.yellow },
		['@definition'] = { sp = theme.dark_foreground, underline = true },
		['@scope'] = { bold = true },
		['@property'] = { fg = theme.white },

		['@markup.heading'] = { fg = theme.blue },
		['@markup.raw'] = { fg = theme.yellow },
		['@markup.link'] = { fg = theme.white },
		['@markup.link.url'] = { fg = theme.yellow, underline = true },
		['@markup.link.label'] = { fg = theme.cyan },
		['@markup.list'] = { fg = theme.white },
		['@markup.strong'] = { bold = true },
		['@markup.underline'] = { underline = true },
		['@markup.italic'] = { italic = true },
		['@markup.strikethrough'] = { strikethrough = true },
		['@markup.quote'] = { bg = theme.red },

		['@comment'] = { fg = theme.brightblack },
		['@comment.todo'] = { fg = theme.brightmagenta },
		['@comment.warning'] = { fg = theme.brightyellow },
		['@comment.note'] = { fg = theme.brightcyan },
		['@comment.danger'] = { fg = theme.brightred },

		['@diff.plus'] = { fg = theme.green },
		['@diff.minus'] = { fg = theme.red },
		['@diff.delta'] = { fg = theme.black },

		---------------------------- LSP ----------------------------------

		-- Completions
		CmpBorder = { fg = theme.brightblack },
		CmpItemAbbr = { fg = theme.black },
		CmpItemAbbrMatch = { fg = theme.brightred },
		CmpDoc = { bg = theme.background },
		CmpDocBorder = { fg = theme.brightblack },
		CmpPmenu = { bg = theme.background },
		CmpSel = { link = 'PmenuSel' },

		-- CmpItemKindConstant = { fg = theme.base09 },
		CmpItemKindFunction = { fg = theme.brightblue },
		-- CmpItemKindIdentifier = { fg = theme.base08 },
		CmpItemKindField = { fg = theme.red },
		CmpItemKindVariable = { fg = theme.black },
		CmpItemKindSnippet = { fg = theme.brightmagenta },
		CmpItemKindText = { fg = theme.white },
		-- CmpItemKindStructure = { fg = theme.base0E },
		-- CmpItemKindType = { fg = theme.base0A },
		CmpItemKindKeyword = { fg = theme.magenta },
		CmpItemKindMethod = { fg = theme.brightblue },
		CmpItemKindConstructor = { fg = theme.brightyellow },
		CmpItemKindFolder = { fg = theme.blue },
		-- CmpItemKindModule = { fg = theme.base0A },
		CmpItemKindProperty = { fg = theme.red },
		CmpItemKindEnum = { fg = theme.blue },
		-- CmpItemKindUnit = { fg = theme.base0E },
		CmpItemKindClass = { fg = theme.yellow },
		CmpItemKindFile = { fg = theme.brightmagenta },
		CmpItemKindInterface = { fg = theme.green },
		CmpItemKindColor = { fg = theme.white },
		CmpItemKindReference = { fg = theme.cyan },
		CmpItemKindEnumMember = { fg = theme.yellow },
		-- CmpItemKindStruct = { fg = theme.base0E },
		CmpItemKindValue = { fg = theme.white },
		CmpItemKindEvent = { fg = theme.yellow },
		CmpItemKindOperator = { fg = theme.cyan },
		CmpItemKindTypeParameter = { fg = theme.red },
		-- CmpItemKindCopilot = { fg = theme.green },
		-- CmpItemKindCodeium = { fg = theme.brightgreen },
		-- CmpItemKindTabNine = { fg = theme.magenta },
		-- CmpItemKindSuperMaven = { fg = theme.yellow },

		-- Mason
		MasonHeader = { fg = theme.brightmagenta },
		MasonHighlight = { fg = theme.blue },
		MasonHighlightBlock = { fg = theme.brightgreen },
		MasonHighlightBlockBold = { link = 'MasonHighlightBlock' },
		MasonHeaderSecondary = { link = 'MasonHighlightBlock' },
		MasonMuted = { fg = theme.grey },
		MasonMutedBlock = { fg = theme.black },

		-- Lspconfig
		LspReferenceText = { bg = theme.one_bg3 },
		LspReferenceRead = { bg = theme.one_bg3 },
		LspReferenceWrite = { bg = theme.one_bg3 },

		DiagnosticError = { fg = theme.brightred },
		DiagnosticWarn = { fg = theme.brightyellow },
		DiagnosticHint = { fg = theme.brightmagenta },
		DiagnosticInfo = { fg = theme.brightblue },

		LspSignatureActiveParameter = { fg = theme.black, bg = theme.green },
		LspInlayHint = { fg = theme.grey },

		---------------------------- Search and Refactor ----------------------------------

		-- Dashboard
		DashAscii = { fg = theme.magenta },
		DashFindFile = { fg = theme.brightyellow },
		DashFindWord = { fg = theme.brightred },
		DashRecentFiles = { fg = theme.blue },
		DashPlugins = { fg = theme.brightgreen },
		DashLine = { fg = theme.black },
		DashSettings = { fg = theme.brightmagenta },

		-- Nvim-Tree
		NvimTreeNormal = { fg = theme.black },
		NvimTreeCursorLine = { bg = theme.dark, bold = true },
		NvimTreeFileName = { fg = theme.black },
		NvimTreeExecFile = { fg = theme.brightgreen },
		NvimTreeSpecialFile = { fg = theme.brightyellow },
		NvimTreeFolderIcon = { fg = theme.blue },
		NvimTreeIndentMarker = { fg = theme.brightmagenta },
		NvimTreeSymlink = { fg = theme.yellow },
		NvimTreeSymlinkFolderName = { fg = theme.yellow },

		NvimTreeGitNew = { fg = theme.red },
		NvimTreeGitDirty = { fg = theme.yellow },
		NvimTreeGitStaged = { fg = theme.green },
		NvimTreeGitRenamed = { link = 'NvimTreeGitStaged' },

		-- Telescope
		TelescopeBorder = { fg = theme.brightblack, bg = 'NONE' },
		TelescopeMatching = { fg = theme.brightred, bg = 'NONE' },
		TelescopeNormal = { fg = theme.brightblack, bg = 'NONE' },
		TelescopeSelection = { fg = theme.black, bg = 'NONE' },

		TelescopePromptBorder = { fg = theme.brightblack, bg = 'NONE' },
		TelescopePromptNormal = { fg = theme.white, bg = 'NONE' },
		TelescopePromptPrefix = { fg = theme.brightyellow, bg = 'NONE' },

		TelescopePromptTitle = { fg = theme.brightgreen, bg = 'NONE' },
		TelescopeResultsTitle = { fg = theme.magenta, bg = 'NONE' },
		TelescopePreviewTitle = { fg = theme.brightblue, bg = 'NONE' },

		TelescopeResultsDiffAdd = { fg = theme.green, bg = 'NONE' },
		TelescopeResultsDiffChange = { fg = theme.yellow, bg = 'NONE' },
		TelescopeResultsDiffDelete = { fg = theme.red, bg = 'NONE' },

		---------------------------- Notifications ----------------------------------

		-- Noice
		NoiceCmdlinePopupBorder = { fg = theme.brightgreen, bg = 'NONE' },
		NoiceCmdlinePopupTitle = { fg = theme.brightgreen, bg = 'NONE' },
		-- NoicePop = { fg = theme.black },
		NoicePopupmenuSelected = { fg = theme.green, bg = theme.grey },
		NoiceCmdlineIcon = { fg = theme.blue, bg = 'NONE' },

		-- Notify
		NotifyERRORBorder = { fg = theme.brightred, bg = theme.background },
		NotifyERRORIcon = { fg = theme.brightred, bg = theme.background },
		NotifyERRORTitle = { fg = theme.brightred, bg = theme.background },

		NotifyWARNBorder = { fg = theme.brightyellow, bg = theme.background },
		NotifyWARNIcon = { fg = theme.brightyellow, bg = theme.background },
		NotifyWARNTitle = { fg = theme.brightyellow, bg = theme.background },

		NotifyINFOBorder = { fg = theme.brightblue, bg = theme.background },
		NotifyINFOIcon = { fg = theme.brightblue, bg = theme.background },
		NotifyINFOTitle = { fg = theme.brightblue, bg = theme.background },

		NotifyDEBUGBorder = { fg = theme.brightmagenta, bg = theme.background },
		NotifyDEBUGIcon = { fg = theme.brightmagenta, bg = theme.background },
		NotifyDEBUGTitle = { fg = theme.brightmagenta, bg = theme.background },

		NotifyTRACEBorder = { fg = theme.brightcyan, bg = theme.background },
		NotifyTRACEIcon = { fg = theme.brightcyan, bg = theme.background },
		NotifyTRACETitle = { fg = theme.brightcyan, bg = theme.background },

		---------------------------- Meta Assistance ----------------------------------

		-- WhichKey
		WhichKey = { fg = theme.yellow },
		WhichKeySeparator = { fg = theme.black },
		WhichKeyDesc = { fg = theme.blue },
		WhichKeyGroup = { fg = theme.yellow },
		WhichKeyValue = { fg = theme.brightmagenta },

		-- Avante
		AvanteTitle = { fg = theme.black2, bg = theme.vibrant_green },
		AvanteReversedTitle = { fg = theme.vibrant_green, bg = theme.black2 },
		AvanteSubtitle = { fg = theme.black2, bg = theme.nord_blue },
		AvanteReversedSubtitle = { fg = theme.nord_blue, bg = theme.black2 },
		AvanteThirdTitle = { bg = theme.white, fg = theme.black2 },
		AvanteReversedThirdTitle = { fg = theme.white },

		-- NOTE should be set automatically by other color groups
		-- AvanteConflictCurrent = {fg = '', bg = ''},
		-- AvanteConflictCurrentLabel = {fg = '', bg = ''},
		-- AvanteConflictIncoming = {fg = '', bg = ''},
		-- AvanteConflictIncomingLabel = {fg = '', bg = ''},
		-- AvantePopupHint = {fg = '', bg = ''},
		-- AvanteInlineHint = {fg = '', bg = ''}

		---------------------------- Productivity ----------------------------------

		-- Git
		diffOldFile = { fg = theme.brightred },
		diffNewFile = { fg = theme.brightgreen },
		DiffAdd = { fg = theme.green },
		DiffAdded = { fg = theme.green },
		DiffChange = { fg = theme.yellow },
		DiffChangeDelete = { fg = theme.red },
		DiffModified = { fg = theme.yellow },
		DiffDelete = { fg = theme.red },
		DiffRemoved = { fg = theme.red },
		DiffText = { fg = theme.white, bg = theme.grey },

		gitcommitOverflow = { fg = theme.red },
		gitcommitSummary = { fg = theme.green },
		gitcommitComment = { fg = theme.grey },
		gitcommitUntracked = { fg = theme.grey },
		gitcommitDiscarded = { fg = theme.grey },
		gitcommitSelected = { fg = theme.grey },
		gitcommitHeader = { fg = theme.brightmagenta },
		gitcommitSelectedType = { fg = theme.blue },
		gitcommitUnmergedType = { fg = theme.blue },
		gitcommitDiscardedType = { fg = theme.blue },
		gitcommitBranch = { fg = theme.yellow, bold = true },
		gitcommitUntrackedFile = { fg = theme.yellow },
		gitcommitUnmergedFile = { fg = theme.red, bold = true },
		gitcommitDiscardedFile = { fg = theme.red, bold = true },
		gitcommitSelectedFile = { fg = theme.green, bold = true },

		-- Lazy
		LazyH1 = { fg = theme.brightgreen },
		LazyBorder = { fg = theme.brightblack },
		LazyButton = { fg = theme.black },
		LazyH2 = { fg = theme.magenta, bold = true },
		LazyReasonPlugin = { fg = theme.red },
		LazyValue = { fg = theme.cyan },
		LazyDir = { fg = theme.blue },
		LazyUrl = { fg = theme.red },
		LazyCommit = { fg = theme.green },
		LazyNoCond = { fg = theme.red },
		LazySpecial = { fg = theme.blue },
		LazyReasonFt = { fg = theme.brightmagenta },
		LazyOperator = { fg = theme.white },
		LazyReasonKeys = { fg = theme.cyan },
		LazyTaskOutput = { fg = theme.white },
		LazyCommitIssue = { fg = theme.magenta },
		LazyReasonEvent = { fg = theme.yellow },
		LazyReasonStart = { fg = theme.white },
		LazyReasonRuntime = { fg = theme.brightyellow },
		LazyReasonCmd = { fg = theme.yellow },
		LazyReasonSource = { fg = theme.cyan },
		LazyReasonImport = { fg = theme.white },
		LazyProgressDone = { fg = theme.green },

		-- Indent Blankline
		IblIndent = { fg = theme.brightblack },
		IblWhitespace = { fg = theme.grey },
		IblScope = { fg = theme.brightmagenta },

		-- Todo
		TodoBgFix = { fg = theme.black2, bg = theme.red, bold = true },
		TodoBgHack = { fg = theme.black2, bg = theme.orange, bold = true },
		TodoBgNote = { fg = theme.black2, bg = theme.white, bold = true },
		TodoBgPerf = { fg = theme.black2, bg = theme.purple, bold = true },
		TodoBgTest = { fg = theme.black2, bg = theme.purple, bold = true },
		TodoBgTodo = { fg = theme.black2, bg = theme.yellow, bold = true },
		TodoBgWarn = { fg = theme.orange, bold = true },
		TodoFgFix = { fg = theme.red },
		TodoFgHack = { fg = theme.orange },
		TodoFgNote = { fg = theme.white },
		TodoFgPerf = { fg = theme.purple },
		TodoFgTest = { fg = theme.purple },
		TodoFgTodo = { fg = theme.yellow },
		TodoFgWarn = { fg = theme.orange },
		TodoSignFix = { link = 'TodoFgFix' },
		TodoSignHack = { link = 'TodoFgHack' },
		TodoSignNote = { link = 'TodoFgNote' },
		TodoSignPerf = { link = 'TodoFgPerf' },
		TodoSignTest = { link = 'TodoFgTest' },
		TodoSignTodo = { link = 'TodoFgTodo' },
		TodoSignWarn = { link = 'TodoFgWarn' },

		---------------------------- UI and Status ----------------------------------

		-- StatusLine
		StatusLine = { fg = theme.brightred, bg = theme.statusline_bg },
		StText = { fg = theme.brightred, bg = theme.statusline_bg },

		St_file = { fg = theme.black, bg = theme.statusline_bg },
		St_filemod = { fg = theme.brightred, bg = theme.statusline_bg },
		St_cursor = { fg = theme.black, bg = theme.statusline_bg },
		St_cwd = { fg = theme.blue, bg = theme.statusline_bg },
		St_ft = { fg = theme.brightblue, bg = theme.statusline_bg },

		St_lspMsg = { fg = theme.brightmagenta, bg = theme.background },
		St_lspError = { fg = theme.brightred, bg = theme.statusline_bg },
		St_lspWarning = { fg = theme.brightyellow, bg = theme.statusline_bg },
		St_lspHints = { fg = theme.brightmagenta, bg = theme.statusline_bg },
		St_lspInfo = { fg = theme.brightblue, bg = theme.statusline_bg },
		St_lsp = { fg = theme.cyan, bg = theme.background },

		St_GitAdded = { fg = theme.green, bg = theme.statusline_bg },
		St_GitChanged = { fg = theme.yellow, bg = theme.statusline_bg },
		St_GitRemoved = { fg = theme.red, bg = theme.statusline_bg },
		St_GitBranch = { fg = theme.magenta, bg = theme.statusline_bg },

		St_NormalMode = { fg = theme.brightblue, bg = theme.statusline_bg },
		St_VisualMode = { fg = theme.brightcyan, bg = theme.statusline_bg },
		St_InsertMode = { fg = theme.brightred, bg = theme.statusline_bg },
		St_TerminalMode = { fg = theme.brightgreen, bg = theme.statusline_bg },
		St_NTerminalMode = { fg = theme.yellow, bg = theme.statusline_bg },
		St_ReplaceMode = { fg = theme.brightyellow, bg = theme.statusline_bg },
		St_ConfirmMode = { fg = theme.cyan, bg = theme.statusline_bg },
		St_CommandMode = { fg = theme.brightgreen, bg = theme.statusline_bg },
		St_SelectMode = { fg = theme.blue, bg = theme.statusline_bg },

		-- Tabs + Bufferline
		TbFill = { bg = 'NONE' },
		TbBufOn = { fg = theme.brightyellow, bg = 'NONE' },
		TbBufOff = { fg = theme.brightblack, bg = 'NONE' },
		TbBufOnClose = { fg = theme.white, bg = 'NONE' },
		TbBufOffClose = { fg = theme.brightblack, bg = 'NONE' },
		TbBufOnModified = { fg = theme.brightred, bg = 'NONE' },
		TbBufOffModified = { fg = theme.red, bg = 'NONE' },
		TbTabOn = { fg = theme.red, bg = 'NONE' },
		TbTabOff = { fg = theme.white, bg = 'NONE' },
		TbTabNewBtn = { fg = theme.white, bg = 'NONE' },
		TbTabCloseBtn = { fg = theme.black, bg = 'NONE' },
		TBTabTitle = { fg = theme.black, bg = 'NONE' },
		TbThemeToggleBtn = { fg = theme.white, bg = 'NONE' },
		TbCloseAllBufsBtn = { fg = theme.brightred, bg = 'NONE' },

		-- Devicons
		DevIconc = { fg = theme.blue },
		DevIconcss = { fg = theme.blue },
		DevIcondeb = { fg = theme.cyan },
		DevIconDockerfile = { fg = theme.cyan },
		DevIconhtml = { fg = theme.brightred },
		DevIconjpeg = { fg = theme.magenta },
		DevIconjpg = { fg = theme.magenta },
		DevIconjs = { fg = theme.yellow },
		DevIconkt = { fg = theme.brightyellow },
		DevIconlock = { fg = theme.red },
		DevIconlua = { fg = theme.blue },
		DevIconmp3 = { fg = theme.white },
		DevIconmp4 = { fg = theme.white },
		DevIconout = { fg = theme.white },
		DevIconpng = { fg = theme.magenta },
		DevIconpy = { fg = theme.cyan },
		DevIcontoml = { fg = theme.blue },
		DevIconts = { fg = theme.brightcyan },
		DevIconttf = { fg = theme.white },
		DevIconrb = { fg = theme.magenta },
		DevIconrpm = { fg = theme.brightyellow },
		DevIconvue = { fg = theme.brightgreen },
		DevIconwoff = { fg = theme.white },
		DevIconwoff2 = { fg = theme.white },
		DevIconxz = { fg = theme.yellow },
		DevIconzip = { fg = theme.yellow },
		DevIconZig = { fg = theme.brightyellow },
		DevIconMd = { fg = theme.blue },
		DevIconTSX = { fg = theme.blue },
		DevIconJSX = { fg = theme.blue },
		DevIconSvelte = { fg = theme.red },
		DevIconJava = { fg = theme.brightyellow },
		DevIconDart = { fg = theme.cyan },
	}
end

return M
