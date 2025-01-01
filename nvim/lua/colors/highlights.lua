--- @type Utils
local utl = require 'configs.utils'

--- @type Highlight Configuration of highlight groups and colorscheme
return {
  setup = function(opts)
    --- @type boolean, Colorscheme Check if given colorscheme exists
    local theme_exists, theme = pcall(require, opts.colorscheme)

    if not theme_exists then
      --- @type string Errror message when colorscheme unavailable
      local err_msg = table.concat {
        'Highlights not loaded! Cannot load "~/.config/nvim/lua/',
        string.gsub(opts.colorscheme, '%.', '/'),
        '.lua"',
      }

      vim.notify(err_msg, vim.log.levels.ERROR)
      return
    end

    ---------------------------- Spectre ----------------------------------
    if opts.plugin == 'spectre' then
      utl.set_hlgroups {
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

    vim.g.terminal_color_0 = theme.black
    vim.g.terminal_color_1 = theme.red
    vim.g.terminal_color_2 = theme.green
    vim.g.terminal_color_3 = theme.yellow
    vim.g.terminal_color_4 = theme.blue
    vim.g.terminal_color_5 = theme.magenta
    vim.g.terminal_color_6 = theme.cyan
    vim.g.terminal_color_7 = theme.white

    vim.g.terminal_color_8 = theme.brightblack
    vim.g.terminal_color_9 = theme.brightred
    vim.g.terminal_color_10 = theme.brightgreen
    vim.g.terminal_color_11 = theme.brightyellow
    vim.g.terminal_color_12 = theme.brightblue
    vim.g.terminal_color_13 = theme.brightmagenta
    vim.g.terminal_color_14 = theme.brightcyan
    vim.g.terminal_color_15 = theme.brightwhite

    utl.set_hlgroups {
      ---------------------------- Defaults ----------------------------------

      Added = { fg = theme.green },
      Changed = { fg = theme.yellow },
      ColorColumn = { bg = theme.black },
      Comment = { fg = theme.brightblack, italic = true },
      Conceal = { bg = theme.background },
      Debug = { fg = theme.white },
      DevIconDefault = { fg = theme.red },
      Directory = { fg = theme.blue },
      Error = { fg = theme.black, bg = theme.background },
      ErrorMsg = { fg = theme.red, bg = theme.background },
      Exception = { fg = theme.magenta },

      -- Cursor
      Cursor = { fg = theme.black, bg = theme.grey },
      CursorColumn = { bg = theme.grey },
      CursorLine = { bg = theme.grey },
      CursorLineNr = { fg = theme.brightmagenta },

      -- QuickFix
      qfLineNr = { fg = theme.brightyellow, bg = theme.background },
      qfFileName = { fg = theme.black, bg = theme.background },
      QuickFixLine = { bold = true, bg = theme.grey },

      -- Folds
      Folded = { fg = theme.black, bg = theme.background, italic = true },
      FoldColumn = { fg = theme.brightblue, bg = theme.background },
      CursorLineFold = { fg = theme.brightmagenta, bg = theme.background },

      LineNr = { fg = theme.brightblack },
      FloatBorder = { fg = theme.brightmagenta },
      FloatTitle = { fg = theme.magenta },
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
      Removed = { fg = theme.red },
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
      YankFlash = { fg = theme.brightyellow, bg = theme.grey },

      ---------------------------- Syntax ----------------------------------

      Boolean = { fg = theme.red },
      Character = { fg = theme.cyan },
      Conditional = { fg = theme.magenta },
      Constant = { fg = theme.black },
      Define = { fg = theme.magenta, sp = 'none' },
      Delimiter = { fg = theme.cyan },
      Float = { fg = theme.brightyellow },
      Variable = { fg = theme.black },
      Function = { fg = theme.blue },
      Identifier = { fg = theme.red, sp = 'none' },
      Include = { fg = theme.brightmagenta },
      Keyword = { fg = theme.magenta },
      Label = { fg = theme.yellow },
      Number = { fg = theme.brightyellow },
      Operator = { fg = theme.black, sp = 'none' },
      PreProc = { fg = theme.yellow },
      Repeat = { fg = theme.yellow },
      Special = { fg = theme.blue },
      SpecialChar = { fg = theme.cyan },
      Statement = { fg = theme.magenta },
      StorageClass = { fg = theme.yellow },
      String = { fg = theme.green },
      Structure = { fg = theme.red },
      Tag = { fg = theme.brightyellow },
      Todo = { fg = theme.cyan },
      Type = { fg = theme.yellow, sp = 'none' },
      Typedef = { fg = theme.yellow },

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
      ['@definition'] = { sp = theme.grey, underline = true },
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

      ['@comment'] = { fg = theme.brightblack, italic = true },
      ['@comment.todo'] = { fg = theme.brightblue },
      ['@comment.warning'] = { fg = theme.brightyellow },
      ['@comment.note'] = { fg = theme.brightcyan },
      ['@comment.danger'] = { fg = theme.brightred },

      ['@diff.plus'] = { fg = theme.green },
      ['@diff.minus'] = { fg = theme.red },
      ['@diff.delta'] = { fg = theme.black },

      ---------------------------- LSP ----------------------------------

      -- Completions
      CmpBorder = { fg = theme.brightmagenta },
      CmpItemAbbr = { fg = theme.black },
      CmpItemAbbrMatch = { fg = theme.brightred },
      CmpDoc = { bg = theme.background },
      CmpDocBorder = { fg = theme.brightmagenta },

      CmpPmenu = { bg = theme.background },
      CmpSel = { bg = theme.grey },

      CmpItemKindConstant = { fg = theme.brightyellow },
      CmpItemKindFunction = { fg = theme.blue },
      CmpItemKindIdentifier = { fg = theme.red },
      CmpItemKindField = { fg = theme.red },
      CmpItemKindVariable = { fg = theme.black },
      CmpItemKindSnippet = { fg = theme.brightmagenta },
      CmpItemKindText = { fg = theme.white },
      CmpItemKindStructure = { fg = theme.brightmagenta },
      CmpItemKindType = { fg = theme.yellow },
      CmpItemKindKeyword = { fg = theme.magenta },
      CmpItemKindMethod = { fg = theme.blue },
      CmpItemKindConstructor = { fg = theme.brightyellow },
      CmpItemKindFolder = { fg = theme.blue },
      CmpItemKindModule = { fg = theme.yellow },
      CmpItemKindProperty = { fg = theme.red },
      CmpItemKindEnum = { fg = theme.blue },
      CmpItemKindUnit = { fg = theme.brightmagenta },
      CmpItemKindClass = { fg = theme.yellow },
      CmpItemKindFile = { fg = theme.brightmagenta },
      CmpItemKindInterface = { fg = theme.green },
      CmpItemKindColor = { fg = theme.white },
      CmpItemKindReference = { fg = theme.cyan },
      CmpItemKindEnumMember = { fg = theme.yellow },
      CmpItemKindStruct = { fg = theme.brightmagenta },
      CmpItemKindValue = { fg = theme.white },
      CmpItemKindEvent = { fg = theme.yellow },
      CmpItemKindOperator = { fg = theme.cyan },
      CmpItemKindTypeParameter = { fg = theme.red },
      CmpItemKindCopilot = { fg = theme.green },
      CmpItemKindCodeium = { fg = theme.brightgreen },
      CmpItemKindTabNine = { fg = theme.magenta },
      CmpItemKindSuperMaven = { fg = theme.yellow },

      -- Mason
      MasonHeader = { fg = theme.brightmagenta },
      MasonHighlight = { fg = theme.blue },
      MasonHighlightBlock = { fg = theme.brightgreen },
      MasonHighlightBlockBold = { link = 'MasonHighlightBlock' },
      MasonHeaderSecondary = { link = 'MasonHighlightBlock' },
      MasonMuted = { fg = theme.grey },
      MasonMutedBlock = { fg = theme.black },

      -- Lspconfig
      LspReferenceText = { bg = theme.grey },
      LspReferenceRead = { bg = theme.grey },
      LspReferenceWrite = { bg = theme.grey },

      DiagnosticError = { fg = theme.brightred },
      DiagnosticWarn = { fg = theme.brightyellow },
      DiagnosticHint = { fg = theme.brightmagenta },
      DiagnosticInfo = { fg = theme.brightblue },

      LspSignatureActiveParameter = { fg = theme.black, bg = theme.green },
      LspInlayHint = { fg = theme.grey },

      ---------------------------- Search and Refactor ----------------------------------

      Search = { fg = theme.brightred, bg = theme.grey, bold = true },
      CurSearch = { fg = theme.brightcyan, bg = theme.grey, bold = true },
      IncSearch = { fg = theme.brightyellow, bg = theme.grey, bold = true },

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
      NvimTreeCursorLine = { bg = theme.grey, bold = true },
      NvimTreeFileName = { fg = theme.black },
      NvimTreeExecFile = { fg = theme.brightgreen },
      NvimTreeSpecialFile = { fg = theme.brightyellow },
      NvimTreeFolderIcon = { fg = theme.blue },
      NvimTreeIndentMarker = { fg = theme.brightmagenta },
      NvimTreeSymlink = { fg = theme.yellow },
      NvimTreeSymlinkFolderName = { fg = theme.yellow },
      NvimTreeModifiedIcon = { fg = theme.red },
      NvimTreeGitNew = { fg = theme.red },
      NvimTreeGitDirty = { fg = theme.yellow },
      NvimTreeGitStaged = { fg = theme.green },
      NvimTreeGitRenamed = { link = 'NvimTreeGitStaged' },

      -- Telescope
      TelescopeBorder = { fg = theme.brightblack, bg = theme.background },
      TelescopeMatching = { fg = theme.brightred, bg = theme.background },
      TelescopeNormal = { fg = theme.brightblack, bg = theme.background },
      TelescopeSelection = { fg = theme.black, bg = theme.background },

      TelescopePromptTitle = { fg = theme.brightyellow, bg = theme.background },
      -- TelescopePromptBorder = { fg = theme.yellow, bg = theme.background },
      TelescopePromptNormal = { fg = theme.white, bg = theme.background },
      TelescopePromptPrefix = { fg = theme.brightyellow, bg = theme.background },

      TelescopeResultsTitle = { fg = theme.brightred, bg = theme.background },
      -- TelescopeResultsBorder = { fg = theme.magenta, bg = theme.background },

      TelescopePreviewTitle = { fg = theme.brightmagenta, bg = theme.background },
      -- TelescopePreviewBorder = { fg = theme.blue, bg = theme.background },

      TelescopeResultsDiffAdd = { fg = theme.green, bg = theme.background },
      TelescopeResultsDiffChange = { fg = theme.yellow, bg = theme.background },
      TelescopeResultsDiffDelete = { fg = theme.red, bg = theme.background },

      ---------------------------- Notifications ----------------------------------

      -- Noice
      NoiceCmdlinePopupBorder = { fg = theme.brightgreen, bg = theme.background },
      NoiceCmdlinePopupTitle = { fg = theme.brightgreen, bg = theme.background },
      -- NoicePop = { fg = theme.black },
      NoicePopupmenuSelected = { fg = theme.green, bg = theme.grey },
      NoiceCmdlineIcon = { fg = theme.blue, bg = theme.background },

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
      WhichKey = { fg = theme.magenta },
      WhichKeyBorder = { fg = theme.brightblack },
      WhichKeySeparator = { fg = theme.black },
      WhichKeyDesc = { fg = theme.blue },
      WhichKeyGroup = { fg = theme.yellow },
      WhichKeyValue = { fg = theme.brightmagenta },

      -- Avante
      AvanteTitle = { fg = theme.brightgreen, bg = theme.background },
      AvanteReversedTitle = { fg = theme.background, bg = theme.background },
      AvanteSubtitle = { fg = theme.brightblue, bg = theme.background },
      AvanteReversedSubtitle = { fg = theme.background, bg = theme.brightblue },
      AvanteThirdTitle = { fg = theme.brightyellow, bg = theme.background },
      AvanteReversedThirdTitle = { fg = theme.background, bg = theme.brightyellow },
      AvanteConflictCurrent = { fg = theme.brightred, bg = theme.background },
      AvanteConflictIncoming = { fg = theme.brightcyan, bg = theme.background },
      AvanteConflictCurrentLabel = { fg = theme.brightred, bg = theme.brightblack },
      AvanteConflictIncomingLabel = { fg = theme.brightcyan, bg = theme.brightblack },
      AvantePopupHint = { fg = theme.brightgreen, bg = theme.background },
      AvanteInlineHint = { fg = theme.brightgreen, bg = theme.grey },

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
      TodoBgFix = { fg = theme.grey, bg = theme.red, bold = true },
      TodoBgHack = { fg = theme.grey, bg = theme.brightyellow, bold = true },
      TodoBgNote = { fg = theme.grey, bg = theme.white, bold = true },
      TodoBgPerf = { fg = theme.grey, bg = theme.brightmagenta, bold = true },
      TodoBgTest = { fg = theme.grey, bg = theme.brightmagenta, bold = true },
      TodoBgTodo = { fg = theme.grey, bg = theme.yellow, bold = true },
      TodoBgWarn = { fg = theme.brightyellow, bold = true },
      TodoFgFix = { fg = theme.red },
      TodoFgHack = { fg = theme.brightyellow },
      TodoFgNote = { fg = theme.white },
      TodoFgPerf = { fg = theme.brightmagenta },
      TodoFgTest = { fg = theme.brightmagenta },
      TodoFgTodo = { fg = theme.yellow },
      TodoFgWarn = { fg = theme.brightyellow },
      TodoSignFix = { link = 'TodoFgFix' },
      TodoSignHack = { link = 'TodoFgHack' },
      TodoSignNote = { link = 'TodoFgNote' },
      TodoSignPerf = { link = 'TodoFgPerf' },
      TodoSignTest = { link = 'TodoFgTest' },
      TodoSignTodo = { link = 'TodoFgTodo' },
      TodoSignWarn = { link = 'TodoFgWarn' },

      ---------------------------- UI and Status ----------------------------------

      -- StatusLine
      StatusLine = { fg = theme.yellow, bg = theme.background },

      StText = { fg = theme.brightgreen, bg = theme.background },

      St_file = { fg = theme.black, bg = theme.background },
      St_filemod = { fg = theme.red, bold = true, underline = true },
      St_cursor = { fg = theme.black, bg = theme.background },
      St_cwd = { fg = theme.blue, bg = theme.background },
      St_ft = { fg = theme.brightblue, bg = theme.background },

      St_lspMsg = { fg = theme.brightyellow, bg = theme.background },
      St_lspError = { fg = theme.brightred, bg = theme.background },
      St_lspWarning = { fg = theme.brightyellow, bg = theme.background },
      St_lspHints = { fg = theme.brightmagenta, bg = theme.background },
      St_lspInfo = { fg = theme.brightblue, bg = theme.background },
      St_lsp = { fg = theme.cyan, bg = theme.background },

      St_GitAdded = { fg = theme.green, bg = theme.background },
      St_GitChanged = { fg = theme.yellow, bg = theme.background },
      St_GitRemoved = { fg = theme.red, bg = theme.background },
      St_GitBranch = { fg = theme.magenta, bg = theme.background },

      St_NormalMode = { fg = theme.brightblue, bg = theme.background },
      St_VisualMode = { fg = theme.brightcyan, bg = theme.background },
      St_InsertMode = { fg = theme.brightred, bg = theme.background },
      St_TerminalMode = { fg = theme.brightgreen, bg = theme.background },
      St_NTerminalMode = { fg = theme.yellow, bg = theme.background },
      St_ReplaceMode = { fg = theme.brightyellow, bg = theme.background },
      St_ConfirmMode = { fg = theme.cyan, bg = theme.background },
      St_CommandMode = { fg = theme.brightgreen, bg = theme.background },
      St_SelectMode = { fg = theme.blue, bg = theme.background },

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
  end,
}
