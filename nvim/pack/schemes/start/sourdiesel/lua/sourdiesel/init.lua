local M = {}

local function hi(group, spec) vim.api.nvim_set_hl(0, group, spec) end

local function build_theme()
  local thm = {}
  local colors = {
    -- 16 ANSI slots
    'black',
    'red',
    'green',
    'yellow',
    'blue',
    'magenta',
    'cyan',
    'white',
    'brightblack',
    'brightred',
    'brightgreen',
    'brightyellow',
    'brightblue',
    'brightmagenta',
    'brightcyan',
    'brightwhite',
    -- extras
    'background',
    'dark',
    'grey',
  }

  for i, name in ipairs(colors) do
    local env = name:upper() .. '_HEX'
    local hex = assert(os.getenv(env), env .. ' not set!')
    thm[name] = hex
    if i <= 16 then vim.g['terminal_color_' .. (i - 1)] = hex end
  end

  return thm
end

M.setup = function()
  local thm = build_theme()

  --------------------------------------------------------------------------
  -- Defaults
  --------------------------------------------------------------------------
  hi('Added', { fg = thm.green })
  hi('Changed', { fg = thm.yellow })
  hi('ColorColumn', { bg = thm.black })
  hi('Comment', { fg = thm.brightblack, italic = true })
  hi('Conceal', { bg = thm.background })
  hi('Debug', { fg = thm.white })
  hi('DevIconDefault', { fg = thm.red })
  hi('Directory', { fg = thm.blue })
  hi('Error', { fg = thm.black, bg = thm.background })
  hi('ErrorMsg', { fg = thm.red, bg = thm.background })
  hi('Exception', { fg = thm.magenta })

  -- Cursor
  hi('Cursor', { fg = thm.black, bg = thm.grey })
  hi('CursorColumn', { bg = thm.grey })
  hi('CursorLine', { bg = thm.grey })
  hi('CursorLineNr', { fg = thm.brightmagenta })

  -- QuickFix
  hi('qfLineNr', { fg = thm.brightyellow, bg = thm.background })
  hi('qfFileName', { fg = thm.black, bg = thm.background })
  hi('QuickFixLine', { bold = true, bg = thm.grey })

  -- Folds
  hi('Folded', { fg = thm.black, bg = thm.background, italic = true })
  hi('FoldColumn', { fg = thm.brightblue, bg = thm.background })
  hi('CursorLineFold', { fg = thm.brightmagenta, bg = thm.background })

  hi('LineNr', { fg = thm.brightblack })
  hi('FloatBorder', { fg = thm.brightblack })
  hi('FloatTitle', { fg = thm.magenta })
  hi('Macro', { fg = thm.white })
  hi('MatchParen', { link = 'MatchWord' })
  hi('MatchWord', { bg = thm.grey, fg = thm.brightred })
  hi('ModeMsg', { fg = thm.green })
  hi('MoreMsg', { fg = thm.green })
  hi('NonText', { fg = thm.black })
  hi('Normal', { fg = thm.white, bg = thm.background })
  hi('NormalFloat', { bg = thm.background })
  hi('NvimInternalError', { fg = thm.red })

  hi('Pmenu', { bg = thm.dark })
  hi('PmenuSbar', { bg = thm.dark })
  hi('PmenuSel', { fg = thm.brightgreen, bg = thm.grey })
  hi('PmenuThumb', { bg = thm.background })

  hi('Question', { fg = thm.blue })
  hi('Removed', { fg = thm.red })
  hi('SignColumn', { fg = thm.black })
  hi('SpecialKey', { fg = thm.black })
  hi('Substitute', { fg = thm.brightred, bg = thm.grey })
  hi('Title', { fg = thm.blue })
  hi('TooLong', { fg = thm.white })
  hi('Visual', { bg = thm.grey })
  hi('VisualNOS', { fg = thm.white })
  hi('WarningMsg', { fg = thm.white, bg = thm.background })
  hi('WildMenu', { fg = thm.yellow, bg = thm.grey })
  hi('WinBar', { bg = thm.background })
  hi('WinBarNC', { bg = thm.background })
  hi('WinSeparator', { fg = thm.brightblack })
  hi('healthSuccess', { bg = thm.green, fg = thm.black })
  hi('YankFlash', { fg = thm.brightyellow, bg = thm.grey })

  --------------------------------------------------------------------------
  -- Syntax
  --------------------------------------------------------------------------
  hi('Boolean', { fg = thm.red })
  hi('Character', { fg = thm.cyan })
  hi('Conditional', { fg = thm.magenta })
  hi('Constant', { fg = thm.black })
  hi('Define', { fg = thm.magenta, sp = 'none' })
  hi('Delimiter', { fg = thm.cyan })
  hi('Float', { fg = thm.brightyellow })
  hi('Variable', { fg = thm.black })
  hi('Function', { fg = thm.blue })
  hi('Identifier', { fg = thm.red, sp = 'none' })
  hi('Include', { fg = thm.brightmagenta })
  hi('Keyword', { fg = thm.magenta })
  hi('Label', { fg = thm.yellow })
  hi('Number', { fg = thm.brightyellow })
  hi('Operator', { fg = thm.black, sp = 'none' })
  hi('PreProc', { fg = thm.yellow })
  hi('Repeat', { fg = thm.yellow })
  hi('Special', { fg = thm.blue })
  hi('SpecialChar', { fg = thm.cyan })
  hi('Statement', { fg = thm.magenta })
  hi('StorageClass', { fg = thm.yellow })
  hi('String', { fg = thm.green })
  hi('Structure', { fg = thm.red })
  hi('Tag', { fg = thm.brightyellow })
  hi('Todo', { fg = thm.cyan })
  hi('Type', { fg = thm.yellow, sp = 'none' })
  hi('Typedef', { fg = thm.yellow })
end

return M
