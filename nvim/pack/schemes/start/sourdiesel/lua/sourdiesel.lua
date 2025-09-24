--- @class Colorscheme
--- @field setup fun(): nil -- Applies all highlight groups
local M = {}

--- Read hex color env vars from ~/.zshenv (or a custom file) and build a palette table.
---
--- Expected lines look like: `export RED_HEX='#ff0000'`
--- * The `_HEX` suffix is stripped.
--- * Keys are lowercased (e.g., "RED_HEX" -> "red").
--- * Values are normalized to lowercase `#rrggbb`.
---
--- @param env_path? string -- Optional path to an env file; falls back to $HOME/.zshenv
--- @return table<string, string>
local hexify = function(env_path)
  env_path = env_path or os.getenv 'HOME' .. '/.zshenv'

  --- @type table<string, string>
  local palette = {}

  --- @type file* -- Opened file handle
  local f = assert(io.open(env_path, 'r'), 'Failed to open ' .. env_path)

  for line in f:lines() do
    --- @type string?, string? -- Extracted color name and hex code from line
    local color, hex = line:match '^%s*export%s+([A-Z_]+_HEX)%s*=%s*[\'"]?(#%x%x%x%x%x%x)[\'"]?'

    if color and hex then
      -- strip the _HEX suffix and lowercase the key
      color = color:match('^(.-)_HEX$'):lower()
      palette[color] = hex:lower()
    end
  end

  f:close()
  return palette
end

--- @type table<string, string> -- Palette of colors
local thm = hexify()

--- @type table<string, { fg?: string, bg?: string, sp?: string, link?: string, bold?: boolean, italic?: boolean, underline?: boolean }> -- Local and vendor highlight groups with options
local highlights = {
  ---------------------------- Defaults ----------------------------------

  Added = { fg = thm.green },
  Changed = { fg = thm.yellow },
  ColorColumn = { bg = thm.black },
  Comment = { fg = thm.brightblack, italic = true },
  Conceal = { bg = thm.nvim_bg },
  Debug = { fg = thm.white },
  DevIconDefault = { fg = thm.red },
  Directory = { fg = thm.blue },
  Error = { fg = thm.black, bg = thm.nvim_bg },
  ErrorMsg = { fg = thm.red, bg = thm.nvim_bg },
  Exception = { fg = thm.magenta },

  -- Cursor
  Cursor = { fg = thm.black, bg = thm.grey },
  CursorColumn = { bg = thm.grey },
  CursorLine = { bg = thm.grey },
  CursorLineNr = { fg = thm.brightmagenta },

  -- QuickFix
  qfLineNr = { fg = thm.brightyellow, bg = thm.nvim_bg },
  qfFileName = { fg = thm.black, bg = thm.nvim_bg },
  QuickFixLine = { bold = true, bg = thm.grey },

  -- Folds
  Folded = { fg = thm.black, bg = thm.nvim_bg, italic = true },
  FoldColumn = { fg = thm.brightblue, bg = thm.nvim_bg },
  CursorLineFold = { fg = thm.brightmagenta, bg = thm.nvim_bg },

  LineNr = { fg = thm.brightblack },
  FloatBorder = { fg = thm.brightblack },
  FloatTitle = { fg = thm.magenta },
  Macro = { fg = thm.white },
  MatchWord = { bg = thm.grey, fg = thm.brightred },
  MatchParen = { link = 'MatchWord' },
  ModeMsg = { fg = thm.green },
  MoreMsg = { fg = thm.green },
  NonText = { fg = thm.black },
  Normal = { fg = thm.white, bg = thm.nvim_bg },
  NormalFloat = { bg = thm.nvim_bg },
  NvimInternalError = { fg = thm.red },

  Pmenu = { bg = thm.dark },
  PmenuSbar = { bg = thm.dark },
  PmenuSel = { fg = thm.brightgreen, bg = thm.grey },
  PmenuThumb = { bg = thm.nvim_bg },

  Question = { fg = thm.blue },
  Removed = { fg = thm.red },
  SignColumn = { fg = thm.black },
  SpecialKey = { fg = thm.black },
  Substitute = { fg = thm.brightred, bg = thm.grey },
  Title = { fg = thm.blue },
  TooLong = { fg = thm.white },
  Visual = { bg = thm.grey },
  VisualNOS = { fg = thm.white },
  WarningMsg = { fg = thm.white, bg = thm.nvim_bg },
  WildMenu = { fg = thm.yellow, bg = thm.grey },
  WinBar = { bg = thm.nvim_bg },
  WinBarNC = { bg = thm.nvim_bg },
  WinSeparator = { fg = thm.brightblack },
  healthSuccess = { bg = thm.green, fg = thm.black },
  YankFlash = { fg = thm.brightyellow, bg = thm.grey },

  ------------------------------- Syntax ----------------------------------

  Boolean = { fg = thm.red },
  Character = { fg = thm.cyan },
  Conditional = { fg = thm.magenta },
  Constant = { fg = thm.black },
  Define = { fg = thm.magenta, sp = 'none' },
  Delimiter = { fg = thm.cyan },
  Float = { fg = thm.brightyellow },
  Variable = { fg = thm.black },
  Function = { fg = thm.blue },
  Identifier = { fg = thm.red, sp = 'none' },
  Include = { fg = thm.magenta },
  Keyword = { fg = thm.magenta },
  Label = { fg = thm.yellow },
  Number = { fg = thm.brightyellow },
  Operator = { fg = thm.black, sp = 'none' },
  PreProc = { fg = thm.yellow },
  Repeat = { fg = thm.yellow },
  Special = { fg = thm.blue },
  SpecialChar = { fg = thm.cyan },
  Statement = { fg = thm.magenta },
  StorageClass = { fg = thm.yellow },
  String = { fg = thm.green },
  Structure = { fg = thm.red },
  Tag = { fg = thm.brightyellow },
  Todo = { fg = thm.cyan },
  Type = { fg = thm.yellow, sp = 'none' },
  Typedef = { fg = thm.yellow },

  ---------------------------- Spectre ----------------------------------
  SpectreHeader = { fg = thm.brightmagenta, bg = thm.nvim_bg, bold = true },
  SpectreBody = { fg = thm.black, bg = thm.nvim_bg, bold = true },
  SpectreFile = { fg = thm.yellow, bg = thm.nvim_bg },
  SpectreDir = { fg = thm.blue, bg = thm.nvim_bg },
  SpectreSearch = { fg = thm.brightred, bg = thm.grey },
  SpectreBorder = { fg = thm.brightblack, bg = thm.nvim_bg },
  SpectreReplace = { fg = thm.brightgreen, bg = thm.grey },

  ---------------------------- Treesitter --------------------------------
  ['@variable'] = { fg = thm.black },
  ['@variable.builtin'] = { fg = thm.yellow },
  ['@variable.parameter'] = { fg = thm.white },
  ['@variable.member'] = { fg = thm.white },
  ['@variable.member.key'] = { fg = thm.white },

  ['@module'] = { fg = thm.white },
  -- ['@module.builtin']        = { fg = thm.white },

  ['@constant'] = { fg = thm.white },
  ['@constant.builtin'] = { fg = thm.yellow },
  ['@constant.macro'] = { fg = thm.white },

  ['@string'] = { fg = thm.green },
  ['@string.regex'] = { fg = thm.cyan },
  ['@string.escape'] = { fg = thm.cyan },
  ['@character'] = { fg = thm.white },
  -- ['@character.special']      = { fg = thm.white },
  ['@number'] = { fg = thm.red },
  ['@number.float'] = { fg = thm.red },

  ['@annotation'] = { fg = thm.black },
  ['@attribute'] = { fg = thm.yellow },
  ['@error'] = { fg = thm.white },

  ['@keyword.exception'] = { fg = thm.white },
  ['@keyword'] = { fg = thm.magenta },
  ['@keyword.function'] = { fg = thm.magenta },
  ['@keyword.return'] = { fg = thm.magenta },
  ['@keyword.operator'] = { fg = thm.magenta },
  ['@keyword.import'] = { link = 'Include' },
  ['@keyword.conditional'] = { fg = thm.magenta },
  ['@keyword.conditional.ternary'] = { fg = thm.magenta },
  ['@keyword.repeat'] = { fg = thm.yellow },
  ['@keyword.storage'] = { fg = thm.yellow },
  ['@keyword.directive.define'] = { fg = thm.magenta },
  ['@keyword.directive'] = { fg = thm.yellow },

  ['@function'] = { fg = thm.blue },
  ['@function.builtin'] = { fg = thm.blue },
  ['@function.macro'] = { fg = thm.white },
  ['@function.call'] = { fg = thm.blue },
  ['@function.method'] = { fg = thm.blue },
  ['@function.method.call'] = { fg = thm.blue },
  ['@constructor'] = { fg = thm.cyan },

  ['@operator'] = { fg = thm.black },
  ['@reference'] = { fg = thm.black },
  ['@punctuation.bracket'] = { fg = thm.black },
  ['@punctuation.delimiter'] = { fg = thm.black },
  ['@symbol'] = { fg = thm.green },
  ['@tag'] = { fg = thm.yellow },
  ['@tag.attribute'] = { fg = thm.white },
  ['@tag.delimiter'] = { fg = thm.black },
  ['@text'] = { fg = thm.black },
  ['@text.emphasis'] = { fg = thm.yellow },
  ['@text.strike'] = { fg = thm.black, strikethrough = true },
  ['@type.builtin'] = { fg = thm.yellow },
  ['@definition'] = { sp = thm.grey, underline = true },
  ['@scope'] = { bold = true },
  ['@property'] = { fg = thm.white },

  ['@markup.heading'] = { fg = thm.blue },
  ['@markup.raw'] = { fg = thm.yellow },
  ['@markup.link'] = { fg = thm.white },
  ['@markup.link.url'] = { fg = thm.yellow, underline = true },
  ['@markup.link.label'] = { fg = thm.cyan },
  ['@markup.list'] = { fg = thm.white },
  ['@markup.strong'] = { bold = true },
  ['@markup.underline'] = { underline = true },
  ['@markup.italic'] = { italic = true },
  ['@markup.strikethrough'] = { strikethrough = true },
  ['@markup.quote'] = { bg = thm.red },

  ['@comment'] = { fg = thm.brightblack, italic = true },
  ['@comment.todo'] = { fg = thm.brightblue },
  ['@comment.warning'] = { fg = thm.brightyellow },
  ['@comment.note'] = { fg = thm.brightcyan },
  ['@comment.danger'] = { fg = thm.brightred },

  ['@diff.plus'] = { fg = thm.green },
  ['@diff.minus'] = { fg = thm.red },
  ['@diff.delta'] = { fg = thm.black },

  ---------------------------- LSP / Completions -------------------------
  BlinkCmpMenu = { fg = thm.brightblack },
  BlinkCmpMenuBorder = { fg = thm.brightblack },
  BlinkCmpMenuSelection = { fg = thm.cyan, bold = true },
  BlinkCmpScrollBarThumb = { fg = thm.grey },
  BlinkCmpScrollBarGutter = { fg = thm.grey },
  BlinkCmpLabel = { fg = thm.white },
  BlinkCmpLabelDeprecated = { fg = thm.red, strikethrough = true },
  BlinkCmpLabelMatch = { fg = thm.magenta },
  BlinkCmpLabelDetail = { fg = thm.brightblack },
  BlinkCmpLabelDescription = { fg = thm.brightblack },

  BlinkCmpKindText = { fg = thm.white },
  BlinkCmpKindMethod = { fg = thm.brightblue },
  BlinkCmpKindFunction = { fg = thm.blue },
  BlinkCmpKindConstructor = { fg = thm.cyan },
  BlinkCmpKindField = { fg = thm.brightmagenta },
  BlinkCmpKindVariable = { fg = thm.magenta },
  BlinkCmpKindClass = { fg = thm.yellow },
  BlinkCmpKindInterface = { fg = thm.brightyellow },
  BlinkCmpKindModule = { fg = thm.brightgreen },
  BlinkCmpKindProperty = { fg = thm.green },
  BlinkCmpKindUnit = { fg = thm.brightwhite },
  BlinkCmpKindValue = { fg = thm.cyan },
  BlinkCmpKindEnum = { fg = thm.brightred },
  BlinkCmpKindKeyword = { fg = thm.red },
  BlinkCmpKindSnippet = { fg = thm.brightcyan },
  BlinkCmpKindColor = { fg = thm.brightblue },
  BlinkCmpKindFile = { fg = thm.brightblack },
  BlinkCmpKindReference = { fg = thm.brightmagenta },
  BlinkCmpKindFolder = { fg = thm.brightblack },
  BlinkCmpKindEnumMember = { fg = thm.brightred },
  BlinkCmpKindConstant = { fg = thm.brightcyan },
  BlinkCmpKindStruct = { fg = thm.yellow },
  BlinkCmpKindEvent = { fg = thm.brightgreen },
  BlinkCmpKindOperator = { fg = thm.green },
  BlinkCmpKindTypeParameter = { fg = thm.brightblue },

  BlinkCmpSource = { fg = thm.cyan },
  BlinkCmpGhostText = { fg = thm.brightblack },
  BlinkCmpDoc = { fg = thm.white, bg = thm.dark },
  BlinkCmpDocBorder = { fg = thm.brightblack },
  BlinkCmpDocSeparator = { fg = thm.brightblack },
  BlinkCmpDocCursorLine = { bg = thm.brightblack },
  BlinkCmpSignatureHelp = { fg = thm.white, bg = thm.dark },
  BlinkCmpSignatureHelpBorder = { fg = thm.brightblack },
  BlinkCmpSignatureHelpActiveParameter = { fg = thm.yellow, bold = true },

  MasonHeader = { fg = thm.brightmagenta },
  MasonHighlight = { fg = thm.blue },
  MasonHighlightBlock = { fg = thm.brightgreen },
  MasonHighlightBlockBold = { link = 'MasonHighlightBlock' },
  MasonHeaderSecondary = { link = 'MasonHighlightBlock' },
  MasonMuted = { fg = thm.grey },
  MasonMutedBlock = { fg = thm.black },

  LspReferenceText = { bg = thm.grey },
  LspReferenceRead = { bg = thm.grey },
  LspReferenceWrite = { bg = thm.grey },

  DiagnosticError = { fg = thm.brightred },
  DiagnosticWarn = { fg = thm.brightyellow },
  DiagnosticHint = { fg = thm.brightmagenta },
  DiagnosticInfo = { fg = thm.brightblue },

  LspSignatureActiveParameter = { fg = thm.black, bg = thm.green },
  LspInlayHint = { fg = thm.grey },

  ---------------------------- Search / Refactor --------------------------
  Search = { fg = thm.brightred, bg = thm.grey, bold = true },
  CurSearch = { fg = thm.brightcyan, bg = thm.grey, bold = true },
  IncSearch = { fg = thm.brightyellow, bg = thm.grey, bold = true },

  ---------------------------- Dashboard ----------------------------------
  DashAscii = { fg = thm.brightmagenta },
  DashLine = { fg = thm.black },
  DashPlugins = { fg = thm.brightyellow },
  DashFiles = { fg = thm.red },
  DashRecent = { fg = thm.green },
  DashTrigger = { fg = thm.yellow },
  DashSettings = { fg = thm.blue },
  DashWord = { fg = thm.magenta },
  DashCmdHist = { fg = thm.cyan },
  DashBuffers = { fg = thm.white },
  DashNvimCmds = { fg = thm.brightblue },
  DashGitFiles = { fg = thm.brightred },
  DashGitLog = { fg = thm.brightgreen },
  DashGitStatus = { fg = thm.brightcyan },
  DashGitSwitch = { fg = thm.brightwhite },

  ---------------------------- Nvim-Tree ----------------------------------
  NvimTreeNormal = { fg = thm.black },
  NvimTreeCursorLine = { bg = thm.grey, bold = true },
  NvimTreeFileName = { fg = thm.black },
  NvimTreeExecFile = { fg = thm.brightgreen },
  NvimTreeSpecialFile = { fg = thm.brightyellow },
  NvimTreeFolderIcon = { fg = thm.blue },
  NvimTreeIndentMarker = { fg = thm.brightmagenta },
  NvimTreeSymlink = { fg = thm.yellow },
  NvimTreeSymlinkFolderName = { fg = thm.yellow },
  NvimTreeModifiedIcon = { fg = thm.red },

  NvimTreeGitFileNewHl = { fg = thm.red },
  NvimTreeGitNewIcon = { link = 'NvimTreeGitFileNewHl' },

  NvimTreeGitFileDirtyHl = { fg = thm.yellow },
  NvimTreeGitDirtyIcon = { link = 'NvimTreeGitFileDirtyHl' },

  NvimTreeGitFileRenamedHl = { fg = thm.green },
  NvimTreeGitRenamedIcon = { link = 'NvimTreeGitFileRenamedHl' },

  NvimTreeGitFileStagedHl = { fg = thm.green },
  NvimTreeGitStagedIcon = { link = 'NvimTreeGitFileStagedHl' },

  NvimTreeGitDeletedIcon = { fg = thm.green },

  NvimTreeWindowPicker = { fg = thm.brightcyan, bg = thm.dark, bold = true },

  ---------------------------- Fzf-lua ------------------------------------
  FzfLuaTitle = { fg = thm.magenta },
  FzfLuaBorder = { fg = thm.brightblack },
  FzfLuaPreviewTitle = { fg = thm.brightmagenta },
  FzfLuaPreviewBorder = { fg = thm.brightblack },

  ---------------------------- Notifications ------------------------------
  NoiceCmdlinePopupBorder = { fg = thm.brightgreen, bg = thm.nvim_bg },
  NoiceCmdlinePopupTitle = { fg = thm.brightgreen, bg = thm.nvim_bg },
  NoicePopupmenuSelected = { fg = thm.green, bg = thm.grey },
  NoiceCmdlineIcon = { fg = thm.blue, bg = thm.nvim_bg },

  NotifyERRORBorder = { fg = thm.brightred, bg = thm.nvim_bg },
  NotifyERRORIcon = { fg = thm.brightred, bg = thm.nvim_bg },
  NotifyERRORTitle = { fg = thm.brightred, bg = thm.nvim_bg },

  NotifyWARNBorder = { fg = thm.brightyellow, bg = thm.nvim_bg },
  NotifyWARNIcon = { fg = thm.brightyellow, bg = thm.nvim_bg },
  NotifyWARNTitle = { fg = thm.brightyellow, bg = thm.nvim_bg },

  NotifyINFOBorder = { fg = thm.brightblue, bg = thm.nvim_bg },
  NotifyINFOIcon = { fg = thm.brightblue, bg = thm.nvim_bg },
  NotifyINFOTitle = { fg = thm.brightblue, bg = thm.nvim_bg },

  NotifyDEBUGBorder = { fg = thm.brightmagenta, bg = thm.nvim_bg },
  NotifyDEBUGIcon = { fg = thm.brightmagenta, bg = thm.nvim_bg },
  NotifyDEBUGTitle = { fg = thm.brightmagenta, bg = thm.nvim_bg },

  NotifyTRACEBorder = { fg = thm.brightcyan, bg = thm.nvim_bg },
  NotifyTRACEIcon = { fg = thm.brightcyan, bg = thm.nvim_bg },
  NotifyTRACETitle = { fg = thm.brightcyan, bg = thm.nvim_bg },

  ---------------------------- Productivity (Git) -------------------------
  diffOldFile = { fg = thm.brightred },
  diffNewFile = { fg = thm.brightgreen },
  DiffAdd = { fg = thm.green },
  DiffAdded = { fg = thm.green },
  DiffChange = { fg = thm.yellow },
  DiffChangeDelete = { fg = thm.red },
  DiffModified = { fg = thm.yellow },
  DiffDelete = { fg = thm.red },
  DiffRemoved = { fg = thm.red },
  DiffText = { fg = thm.white, bg = thm.grey },

  gitcommitOverflow = { fg = thm.red },
  gitcommitSummary = { fg = thm.green },
  gitcommitComment = { fg = thm.grey },
  gitcommitUntracked = { fg = thm.grey },
  gitcommitDiscarded = { fg = thm.grey },
  gitcommitSelected = { fg = thm.grey },
  gitcommitHeader = { fg = thm.brightmagenta },
  gitcommitSelectedType = { fg = thm.blue },
  gitcommitUnmergedType = { fg = thm.blue },
  gitcommitDiscardedType = { fg = thm.blue },
  gitcommitBranch = { fg = thm.yellow, bold = true },
  gitcommitUntrackedFile = { fg = thm.yellow },
  gitcommitUnmergedFile = { fg = thm.red, bold = true },
  gitcommitDiscardedFile = { fg = thm.red, bold = true },
  gitcommitSelectedFile = { fg = thm.green, bold = true },

  ---------------------------- Indent Blankline ---------------------------
  IblIndent = { fg = thm.brightblack },
  IblWhitespace = { fg = thm.grey },
  IblScope = { fg = thm.brightmagenta },

  ---------------------------- UI / StatusLine ----------------------------
  StatusLine = { fg = thm.yellow, bg = thm.nvim_bg },

  StText = { fg = thm.brightgreen, bg = thm.nvim_bg },

  St_file = { fg = thm.black, bg = thm.nvim_bg },
  St_filemod = { fg = thm.red, bold = true, underline = true },
  St_cursor = { fg = thm.black, bg = thm.nvim_bg },
  St_cwd = { fg = thm.blue, bg = thm.nvim_bg },
  St_ft = { fg = thm.brightblue, bg = thm.nvim_bg },

  St_lspMsg = { fg = thm.brightyellow, bg = thm.nvim_bg },
  St_lspError = { fg = thm.brightred, bg = thm.nvim_bg },
  St_lspWarning = { fg = thm.brightyellow, bg = thm.nvim_bg },
  St_lspHints = { fg = thm.brightmagenta, bg = thm.nvim_bg },
  St_lspInfo = { fg = thm.brightblue, bg = thm.nvim_bg },
  St_lsp = { fg = thm.cyan, bg = thm.nvim_bg },

  St_GitAdded = { fg = thm.green, bg = thm.nvim_bg },
  St_GitChanged = { fg = thm.yellow, bg = thm.nvim_bg },
  St_GitRemoved = { fg = thm.red, bg = thm.nvim_bg },
  St_GitAhead = { fg = thm.brightblue, bg = thm.nvim_bg },
  St_GitBehind = { fg = thm.brightblue, bg = thm.nvim_bg },
  St_GitUntracked = { fg = thm.red, bg = thm.nvim_bg },
  St_GitBranch = { fg = thm.magenta, bg = thm.nvim_bg },
  St_GitConflicted = { fg = thm.brightred, bg = thm.nvim_bg },

  St_NormalMode = { fg = thm.brightblue, bg = thm.nvim_bg },
  St_VisualMode = { fg = thm.brightcyan, bg = thm.nvim_bg },
  St_InsertMode = { fg = thm.brightred, bg = thm.nvim_bg },
  St_TerminalMode = { fg = thm.brightgreen, bg = thm.nvim_bg },
  St_NTerminalMode = { fg = thm.yellow, bg = thm.nvim_bg },
  St_ReplaceMode = { fg = thm.brightyellow, bg = thm.nvim_bg },
  St_ConfirmMode = { fg = thm.cyan, bg = thm.nvim_bg },
  St_CommandMode = { fg = thm.brightgreen, bg = thm.nvim_bg },
  St_SelectMode = { fg = thm.blue, bg = thm.nvim_bg },

  ---------------------------- Devicons -----------------------------------
  DevIconc = { fg = thm.blue },
  DevIconcss = { fg = thm.blue },
  DevIcondeb = { fg = thm.cyan },
  DevIconDockerfile = { fg = thm.cyan },
  DevIconhtml = { fg = thm.brightred },
  DevIconjpeg = { fg = thm.magenta },
  DevIconjpg = { fg = thm.magenta },
  DevIconjs = { fg = thm.yellow },
  DevIconkt = { fg = thm.brightyellow },
  DevIconlock = { fg = thm.red },
  DevIconlua = { fg = thm.blue },
  DevIconmp3 = { fg = thm.white },
  DevIconmp4 = { fg = thm.white },
  DevIconout = { fg = thm.white },
  DevIconpng = { fg = thm.magenta },
  DevIconpy = { fg = thm.cyan },
  DevIcontoml = { fg = thm.blue },
  DevIconts = { fg = thm.brightcyan },
  DevIconttf = { fg = thm.white },
  DevIconrb = { fg = thm.magenta },
  DevIconrpm = { fg = thm.brightyellow },
  DevIconvue = { fg = thm.brightgreen },
  DevIconwoff = { fg = thm.white },
  DevIconwoff2 = { fg = thm.white },
  DevIconxz = { fg = thm.yellow },
  DevIconzip = { fg = thm.yellow },
  DevIconZig = { fg = thm.brightyellow },
  DevIconMd = { fg = thm.blue },
  DevIconTSX = { fg = thm.blue },
  DevIconJSX = { fg = thm.blue },
  DevIconSvelte = { fg = thm.red },
  DevIconJava = { fg = thm.brightyellow },
  DevIconDart = { fg = thm.cyan },
}

M.setup = function()
  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

return M
