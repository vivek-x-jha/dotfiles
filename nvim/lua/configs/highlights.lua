--- @class Highlight
--- @field setup fun(opts?: string): nil
return {
  setup = function(opts)
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

    for i, color in ipairs(colors) do
      local env = color:upper() .. '_HEX'
      local hex = assert(os.getenv(env), env .. ' not set!') -- expects env vars: <COLOR>_HEX (i.e. BLACK_HEX)
      thm[color] = hex

      -- Set terminal colors
      if i <= 16 then vim.g['terminal_color_' .. (i - 1)] = hex end
    end

    ---------------------------- Spectre ----------------------------------

    if opts == 'spectre' then
      vim.api.nvim_set_hl(0, 'SpectreHeader', { fg = thm.brightmagenta, bg = thm.background, bold = true })
      vim.api.nvim_set_hl(0, 'SpectreBody', { fg = thm.black, bg = thm.background, bold = true })
      vim.api.nvim_set_hl(0, 'SpectreFile', { fg = thm.yellow, bg = thm.background })
      vim.api.nvim_set_hl(0, 'SpectreDir', { fg = thm.blue, bg = thm.background })
      vim.api.nvim_set_hl(0, 'SpectreSearch', { fg = thm.brightred, bg = thm.grey })
      vim.api.nvim_set_hl(0, 'SpectreBorder', { fg = thm.brightblack, bg = thm.background })
      vim.api.nvim_set_hl(0, 'SpectreReplace', { fg = thm.brightgreen, bg = thm.grey })

      return
    end

    ---------------------------- Defaults ----------------------------------

    vim.api.nvim_set_hl(0, 'Added', { fg = thm.green })
    vim.api.nvim_set_hl(0, 'Changed', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'ColorColumn', { bg = thm.black })
    vim.api.nvim_set_hl(0, 'Comment', { fg = thm.brightblack, italic = true })
    vim.api.nvim_set_hl(0, 'Conceal', { bg = thm.background })
    vim.api.nvim_set_hl(0, 'Debug', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'DevIconDefault', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'Directory', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'Error', { fg = thm.black, bg = thm.background })
    vim.api.nvim_set_hl(0, 'ErrorMsg', { fg = thm.red, bg = thm.background })
    vim.api.nvim_set_hl(0, 'Exception', { fg = thm.magenta })

    -- Cursor
    vim.api.nvim_set_hl(0, 'Cursor', { fg = thm.black, bg = thm.grey })
    vim.api.nvim_set_hl(0, 'CursorColumn', { bg = thm.grey })
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = thm.grey })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = thm.brightmagenta })

    -- QuickFix
    vim.api.nvim_set_hl(0, 'qfLineNr', { fg = thm.brightyellow, bg = thm.background })
    vim.api.nvim_set_hl(0, 'qfFileName', { fg = thm.black, bg = thm.background })
    vim.api.nvim_set_hl(0, 'QuickFixLine', { bold = true, bg = thm.grey })

    -- Folds
    vim.api.nvim_set_hl(0, 'Folded', { fg = thm.black, bg = thm.background, italic = true })
    vim.api.nvim_set_hl(0, 'FoldColumn', { fg = thm.brightblue, bg = thm.background })
    vim.api.nvim_set_hl(0, 'CursorLineFold', { fg = thm.brightmagenta, bg = thm.background })

    vim.api.nvim_set_hl(0, 'LineNr', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'FloatBorder', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'FloatTitle', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, 'Macro', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'MatchParen', { link = 'MatchWord' })
    vim.api.nvim_set_hl(0, 'MatchWord', { bg = thm.grey, fg = thm.brightred })
    vim.api.nvim_set_hl(0, 'ModeMsg', { fg = thm.green })
    vim.api.nvim_set_hl(0, 'MoreMsg', { fg = thm.green })
    vim.api.nvim_set_hl(0, 'NonText', { fg = thm.black })
    vim.api.nvim_set_hl(0, 'Normal', { fg = thm.white, bg = thm.background })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = thm.background })
    vim.api.nvim_set_hl(0, 'NvimInternalError', { fg = thm.red })

    vim.api.nvim_set_hl(0, 'Pmenu', { bg = thm.dark })
    vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = thm.dark })
    vim.api.nvim_set_hl(0, 'PmenuSel', { fg = thm.brightgreen, bg = thm.grey })
    vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = thm.background })

    vim.api.nvim_set_hl(0, 'Question', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'Removed', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'SignColumn', { fg = thm.black })
    vim.api.nvim_set_hl(0, 'SpecialKey', { fg = thm.black })
    vim.api.nvim_set_hl(0, 'Substitute', { fg = thm.brightred, bg = thm.grey })
    vim.api.nvim_set_hl(0, 'Title', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'TooLong', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'Visual', { bg = thm.grey })
    vim.api.nvim_set_hl(0, 'VisualNOS', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'WarningMsg', { fg = thm.white, bg = thm.background })
    vim.api.nvim_set_hl(0, 'WildMenu', { fg = thm.yellow, bg = thm.grey })
    vim.api.nvim_set_hl(0, 'WinBar', { bg = thm.background })
    vim.api.nvim_set_hl(0, 'WinBarNC', { bg = thm.background })
    vim.api.nvim_set_hl(0, 'WinSeparator', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'healthSuccess', { bg = thm.green, fg = thm.black })
    vim.api.nvim_set_hl(0, 'YankFlash', { fg = thm.brightyellow, bg = thm.grey })

    ---------------------------- Syntax ----------------------------------

    vim.api.nvim_set_hl(0, 'Boolean', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'Character', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, 'Conditional', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, 'Constant', { fg = thm.black })
    vim.api.nvim_set_hl(0, 'Define', { fg = thm.magenta, sp = 'none' })
    vim.api.nvim_set_hl(0, 'Delimiter', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, 'Float', { fg = thm.brightyellow })
    vim.api.nvim_set_hl(0, 'Variable', { fg = thm.black })
    vim.api.nvim_set_hl(0, 'Function', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'Identifier', { fg = thm.red, sp = 'none' })
    vim.api.nvim_set_hl(0, 'Include', { fg = thm.brightmagenta })
    vim.api.nvim_set_hl(0, 'Keyword', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, 'Label', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'Number', { fg = thm.brightyellow })
    vim.api.nvim_set_hl(0, 'Operator', { fg = thm.black, sp = 'none' })
    vim.api.nvim_set_hl(0, 'PreProc', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'Repeat', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'Special', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'SpecialChar', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, 'Statement', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, 'StorageClass', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'String', { fg = thm.green })
    vim.api.nvim_set_hl(0, 'Structure', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'Tag', { fg = thm.brightyellow })
    vim.api.nvim_set_hl(0, 'Todo', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, 'Type', { fg = thm.yellow, sp = 'none' })
    vim.api.nvim_set_hl(0, 'Typedef', { fg = thm.yellow })

    -- Treesitter
    vim.api.nvim_set_hl(0, '@variable', { fg = thm.black })
    vim.api.nvim_set_hl(0, '@variable.builtin', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, '@variable.parameter', { fg = thm.white })
    vim.api.nvim_set_hl(0, '@variable.member', { fg = thm.white })
    vim.api.nvim_set_hl(0, '@variable.member.key', { fg = thm.white })

    vim.api.nvim_set_hl(0, '@module', { fg = thm.white })
    -- vim.api.nvim_set_hl(0, '@module.builtin', { fg = thm.white })

    vim.api.nvim_set_hl(0, '@constant', { fg = thm.white })
    vim.api.nvim_set_hl(0, '@constant.builtin', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, '@constant.macro', { fg = thm.white })

    vim.api.nvim_set_hl(0, '@string', { fg = thm.green })
    vim.api.nvim_set_hl(0, '@string.regex', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, '@string.escape', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, '@character', { fg = thm.white })
    -- vim.api.nvim_set_hl(0, '@character.special', { fg = thm.white })
    vim.api.nvim_set_hl(0, '@number', { fg = thm.red })
    vim.api.nvim_set_hl(0, '@number.float', { fg = thm.red })

    vim.api.nvim_set_hl(0, '@annotation', { fg = thm.black })
    vim.api.nvim_set_hl(0, '@attribute', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, '@error', { fg = thm.white })

    vim.api.nvim_set_hl(0, '@keyword.exception', { fg = thm.white })
    vim.api.nvim_set_hl(0, '@keyword', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, '@keyword.function', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, '@keyword.return', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, '@keyword.operator', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, '@keyword.import', { link = 'Include' })
    vim.api.nvim_set_hl(0, '@keyword.conditional', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, '@keyword.conditional.ternary', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, '@keyword.repeat', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, '@keyword.storage', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, '@keyword.directive.define', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, '@keyword.directive', { fg = thm.yellow })

    vim.api.nvim_set_hl(0, '@function', { fg = thm.blue })
    vim.api.nvim_set_hl(0, '@function.builtin', { fg = thm.blue })
    vim.api.nvim_set_hl(0, '@function.macro', { fg = thm.white })
    vim.api.nvim_set_hl(0, '@function.call', { fg = thm.blue })
    vim.api.nvim_set_hl(0, '@function.method', { fg = thm.blue })
    vim.api.nvim_set_hl(0, '@function.method.call', { fg = thm.blue })
    vim.api.nvim_set_hl(0, '@constructor', { fg = thm.cyan })

    vim.api.nvim_set_hl(0, '@operator', { fg = thm.black })
    vim.api.nvim_set_hl(0, '@reference', { fg = thm.black })
    vim.api.nvim_set_hl(0, '@punctuation.bracket', { fg = thm.black })
    vim.api.nvim_set_hl(0, '@punctuation.delimiter', { fg = thm.black })
    vim.api.nvim_set_hl(0, '@symbol', { fg = thm.green })
    vim.api.nvim_set_hl(0, '@tag', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, '@tag.attribute', { fg = thm.white })
    vim.api.nvim_set_hl(0, '@tag.delimiter', { fg = thm.black })
    vim.api.nvim_set_hl(0, '@text', { fg = thm.black })
    vim.api.nvim_set_hl(0, '@text.emphasis', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, '@text.strike', { fg = thm.black, strikethrough = true })
    vim.api.nvim_set_hl(0, '@type.builtin', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, '@definition', { sp = thm.grey, underline = true })
    vim.api.nvim_set_hl(0, '@scope', { bold = true })
    vim.api.nvim_set_hl(0, '@property', { fg = thm.white })

    vim.api.nvim_set_hl(0, '@markup.heading', { fg = thm.blue })
    vim.api.nvim_set_hl(0, '@markup.raw', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, '@markup.link', { fg = thm.white })
    vim.api.nvim_set_hl(0, '@markup.link.url', { fg = thm.yellow, underline = true })
    vim.api.nvim_set_hl(0, '@markup.link.label', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, '@markup.list', { fg = thm.white })
    vim.api.nvim_set_hl(0, '@markup.strong', { bold = true })
    vim.api.nvim_set_hl(0, '@markup.underline', { underline = true })
    vim.api.nvim_set_hl(0, '@markup.italic', { italic = true })
    vim.api.nvim_set_hl(0, '@markup.strikethrough', { strikethrough = true })
    vim.api.nvim_set_hl(0, '@markup.quote', { bg = thm.red })

    vim.api.nvim_set_hl(0, '@comment', { fg = thm.brightblack, italic = true })
    vim.api.nvim_set_hl(0, '@comment.todo', { fg = thm.brightblue })
    vim.api.nvim_set_hl(0, '@comment.warning', { fg = thm.brightyellow })
    vim.api.nvim_set_hl(0, '@comment.note', { fg = thm.brightcyan })
    vim.api.nvim_set_hl(0, '@comment.danger', { fg = thm.brightred })

    vim.api.nvim_set_hl(0, '@diff.plus', { fg = thm.green })
    vim.api.nvim_set_hl(0, '@diff.minus', { fg = thm.red })
    vim.api.nvim_set_hl(0, '@diff.delta', { fg = thm.black })

    ---------------------------- LSP ----------------------------------

    -- Completions
    vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', { fg = thm.cyan, bold = true })
    vim.api.nvim_set_hl(0, 'BlinkCmpScrollBarThumb', { fg = thm.grey })
    vim.api.nvim_set_hl(0, 'BlinkCmpScrollBarGutter', { fg = thm.grey })
    vim.api.nvim_set_hl(0, 'BlinkCmpLabel', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'BlinkCmpLabelDeprecated', { fg = thm.red, strikethrough = true })
    vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, 'BlinkCmpLabelDetail', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'BlinkCmpLabelDescription', { fg = thm.brightblack })

    vim.api.nvim_set_hl(0, 'BlinkCmpKindText', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindMethod', { fg = thm.brightblue })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindFunction', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindConstructor', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindField', { fg = thm.brightmagenta })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindVariable', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindClass', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindInterface', { fg = thm.brightyellow })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindModule', { fg = thm.brightgreen })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindProperty', { fg = thm.green })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindUnit', { fg = thm.brightwhite })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindValue', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindEnum', { fg = thm.brightred })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindKeyword', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindSnippet', { fg = thm.brightcyan })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindColor', { fg = thm.brightblue })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindFile', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindReference', { fg = thm.brightmagenta })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindFolder', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindEnumMember', { fg = thm.brightred })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindConstant', { fg = thm.brightcyan })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindStruct', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindEvent', { fg = thm.brightgreen })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindOperator', { fg = thm.green })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindTypeParameter', { fg = thm.brightblue })

    vim.api.nvim_set_hl(0, 'BlinkCmpSource', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, 'BlinkCmpGhostText', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'BlinkCmpDoc', { fg = thm.white, bg = thm.dark })
    vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'BlinkCmpDocSeparator', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'BlinkCmpDocCursorLine', { bg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelp', { fg = thm.white, bg = thm.dark })
    vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpBorder', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpActiveParameter', { fg = thm.yellow, bold = true })

    -- Mason
    vim.api.nvim_set_hl(0, 'MasonHeader', { fg = thm.brightmagenta })
    vim.api.nvim_set_hl(0, 'MasonHighlight', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'MasonHighlightBlock', { fg = thm.brightgreen })
    vim.api.nvim_set_hl(0, 'MasonHighlightBlockBold', { link = 'MasonHighlightBlock' })
    vim.api.nvim_set_hl(0, 'MasonHeaderSecondary', { link = 'MasonHighlightBlock' })
    vim.api.nvim_set_hl(0, 'MasonMuted', { fg = thm.grey })
    vim.api.nvim_set_hl(0, 'MasonMutedBlock', { fg = thm.black })

    -- Lspconfig
    vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = thm.grey })
    vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = thm.grey })
    vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = thm.grey })

    vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = thm.brightred })
    vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = thm.brightyellow })
    vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = thm.brightmagenta })
    vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = thm.brightblue })

    vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { fg = thm.black, bg = thm.green })
    vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = thm.grey })

    ---------------------------- Search and Refactor ----------------------------------

    vim.api.nvim_set_hl(0, 'Search', { fg = thm.brightred, bg = thm.grey, bold = true })
    vim.api.nvim_set_hl(0, 'CurSearch', { fg = thm.brightcyan, bg = thm.grey, bold = true })
    vim.api.nvim_set_hl(0, 'IncSearch', { fg = thm.brightyellow, bg = thm.grey, bold = true })

    -- Dashboard
    vim.api.nvim_set_hl(0, 'DashAscii', { fg = thm.brightmagenta })
    vim.api.nvim_set_hl(0, 'DashLine', { fg = thm.black })
    vim.api.nvim_set_hl(0, 'DashPlugins', { fg = thm.brightyellow })
    vim.api.nvim_set_hl(0, 'DashFiles', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'DashRecent', { fg = thm.green })
    vim.api.nvim_set_hl(0, 'DashTrigger', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'DashSettings', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'DashWord', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, 'DashCmdHist', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, 'DashBuffers', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'DashNvimCmds', { fg = thm.brightblue })
    vim.api.nvim_set_hl(0, 'DashGitFiles', { fg = thm.brightred })
    vim.api.nvim_set_hl(0, 'DashGitLog', { fg = thm.brightgreen })
    vim.api.nvim_set_hl(0, 'DashGitStatus', { fg = thm.brightcyan })
    vim.api.nvim_set_hl(0, 'DashGitSwitch', { fg = thm.brightwhite })

    -- Nvim-Tree
    vim.api.nvim_set_hl(0, 'NvimTreeNormal', { fg = thm.black })
    vim.api.nvim_set_hl(0, 'NvimTreeCursorLine', { bg = thm.grey, bold = true })
    vim.api.nvim_set_hl(0, 'NvimTreeFileName', { fg = thm.black })
    vim.api.nvim_set_hl(0, 'NvimTreeExecFile', { fg = thm.brightgreen })
    vim.api.nvim_set_hl(0, 'NvimTreeSpecialFile', { fg = thm.brightyellow })
    vim.api.nvim_set_hl(0, 'NvimTreeFolderIcon', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'NvimTreeIndentMarker', { fg = thm.brightmagenta })
    vim.api.nvim_set_hl(0, 'NvimTreeSymlink', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'NvimTreeSymlinkFolderName', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'NvimTreeModifiedIcon', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'NvimTreeGitNew', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'NvimTreeGitDirty', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'NvimTreeGitStaged', { fg = thm.green })
    vim.api.nvim_set_hl(0, 'NvimTreeGitRenamed', { link = 'NvimTreeGitStaged' })
    vim.api.nvim_set_hl(0, 'NvimTreeGitIgnored', { fg = thm.brightblack, italic = true })

    -- Fzf-lua
    vim.api.nvim_set_hl(0, 'FzfLuaTitle', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, 'FzfLuaBorder', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'FzfLuaPreviewTitle', { fg = thm.brightmagenta })
    vim.api.nvim_set_hl(0, 'FzfLuaPreviewBorder', { fg = thm.brightblack })

    ---------------------------- Notifications ----------------------------------

    -- Noice
    vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorder', { fg = thm.brightgreen, bg = thm.background })
    vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupTitle', { fg = thm.brightgreen, bg = thm.background })
    -- vim.api.nvim_set_hl(0, 'NoicePop', { fg = thm.black })
    vim.api.nvim_set_hl(0, 'NoicePopupmenuSelected', { fg = thm.green, bg = thm.grey })
    vim.api.nvim_set_hl(0, 'NoiceCmdlineIcon', { fg = thm.blue, bg = thm.background })

    -- Notify
    vim.api.nvim_set_hl(0, 'NotifyERRORBorder', { fg = thm.brightred, bg = thm.background })
    vim.api.nvim_set_hl(0, 'NotifyERRORIcon', { fg = thm.brightred, bg = thm.background })
    vim.api.nvim_set_hl(0, 'NotifyERRORTitle', { fg = thm.brightred, bg = thm.background })

    vim.api.nvim_set_hl(0, 'NotifyWARNBorder', { fg = thm.brightyellow, bg = thm.background })
    vim.api.nvim_set_hl(0, 'NotifyWARNIcon', { fg = thm.brightyellow, bg = thm.background })
    vim.api.nvim_set_hl(0, 'NotifyWARNTitle', { fg = thm.brightyellow, bg = thm.background })

    vim.api.nvim_set_hl(0, 'NotifyINFOBorder', { fg = thm.brightblue, bg = thm.background })
    vim.api.nvim_set_hl(0, 'NotifyINFOIcon', { fg = thm.brightblue, bg = thm.background })
    vim.api.nvim_set_hl(0, 'NotifyINFOTitle', { fg = thm.brightblue, bg = thm.background })

    vim.api.nvim_set_hl(0, 'NotifyDEBUGBorder', { fg = thm.brightmagenta, bg = thm.background })
    vim.api.nvim_set_hl(0, 'NotifyDEBUGIcon', { fg = thm.brightmagenta, bg = thm.background })
    vim.api.nvim_set_hl(0, 'NotifyDEBUGTitle', { fg = thm.brightmagenta, bg = thm.background })

    vim.api.nvim_set_hl(0, 'NotifyTRACEBorder', { fg = thm.brightcyan, bg = thm.background })
    vim.api.nvim_set_hl(0, 'NotifyTRACEIcon', { fg = thm.brightcyan, bg = thm.background })
    vim.api.nvim_set_hl(0, 'NotifyTRACETitle', { fg = thm.brightcyan, bg = thm.background })

    ---------------------------- Meta Assistance ----------------------------------

    -- WhichKey
    vim.api.nvim_set_hl(0, 'WhichKey', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, 'WhichKeyBorder', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'WhichKeySeparator', { fg = thm.black })
    vim.api.nvim_set_hl(0, 'WhichKeyDesc', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'WhichKeyGroup', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'WhichKeyValue', { fg = thm.brightmagenta })

    ---------------------------- Productivity ----------------------------------

    -- Git
    vim.api.nvim_set_hl(0, 'diffOldFile', { fg = thm.brightred })
    vim.api.nvim_set_hl(0, 'diffNewFile', { fg = thm.brightgreen })
    vim.api.nvim_set_hl(0, 'DiffAdd', { fg = thm.green })
    vim.api.nvim_set_hl(0, 'DiffAdded', { fg = thm.green })
    vim.api.nvim_set_hl(0, 'DiffChange', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'DiffChangeDelete', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'DiffModified', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'DiffDelete', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'DiffRemoved', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'DiffText', { fg = thm.white, bg = thm.grey })

    vim.api.nvim_set_hl(0, 'gitcommitOverflow', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'gitcommitSummary', { fg = thm.green })
    vim.api.nvim_set_hl(0, 'gitcommitComment', { fg = thm.grey })
    vim.api.nvim_set_hl(0, 'gitcommitUntracked', { fg = thm.grey })
    vim.api.nvim_set_hl(0, 'gitcommitDiscarded', { fg = thm.grey })
    vim.api.nvim_set_hl(0, 'gitcommitSelected', { fg = thm.grey })
    vim.api.nvim_set_hl(0, 'gitcommitHeader', { fg = thm.brightmagenta })
    vim.api.nvim_set_hl(0, 'gitcommitSelectedType', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'gitcommitUnmergedType', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'gitcommitDiscardedType', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'gitcommitBranch', { fg = thm.yellow, bold = true })
    vim.api.nvim_set_hl(0, 'gitcommitUntrackedFile', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'gitcommitUnmergedFile', { fg = thm.red, bold = true })
    vim.api.nvim_set_hl(0, 'gitcommitDiscardedFile', { fg = thm.red, bold = true })
    vim.api.nvim_set_hl(0, 'gitcommitSelectedFile', { fg = thm.green, bold = true })

    -- Lazy
    vim.api.nvim_set_hl(0, 'LazyH1', { fg = thm.brightcyan, bold = true })
    vim.api.nvim_set_hl(0, 'LazyBorder', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'LazyButton', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'LazyButtonActive', { fg = thm.white, bold = true })
    vim.api.nvim_set_hl(0, 'LazyH2', { fg = thm.magenta, bold = true })
    vim.api.nvim_set_hl(0, 'LazyReasonPlugin', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'LazyValue', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, 'LazyDir', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'LazyUrl', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'LazyCommit', { fg = thm.green })
    vim.api.nvim_set_hl(0, 'LazyNoCond', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'LazyReasonFt', { fg = thm.brightmagenta })
    vim.api.nvim_set_hl(0, 'LazyOperator', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'LazyReasonKeys', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, 'LazyTaskOutput', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'LazyCommitIssue', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, 'LazyReasonEvent', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'LazyReasonStart', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'LazyReasonRuntime', { fg = thm.brightyellow })
    vim.api.nvim_set_hl(0, 'LazyReasonCmd', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'LazyReasonSource', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, 'LazyReasonImport', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'LazyProgressDone', { fg = thm.green })
    vim.api.nvim_set_hl(0, 'LazySpecial', { fg = thm.green })

    -- Indent Blankline
    vim.api.nvim_set_hl(0, 'IblIndent', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'IblWhitespace', { fg = thm.grey })
    vim.api.nvim_set_hl(0, 'IblScope', { fg = thm.brightmagenta })

    -- Todo
    vim.api.nvim_set_hl(0, 'TodoBgFix', { fg = thm.grey, bg = thm.red, bold = true })
    vim.api.nvim_set_hl(0, 'TodoBgHack', { fg = thm.grey, bg = thm.brightyellow, bold = true })
    vim.api.nvim_set_hl(0, 'TodoBgNote', { fg = thm.grey, bg = thm.white, bold = true })
    vim.api.nvim_set_hl(0, 'TodoBgPerf', { fg = thm.grey, bg = thm.brightmagenta, bold = true })
    vim.api.nvim_set_hl(0, 'TodoBgTest', { fg = thm.grey, bg = thm.brightmagenta, bold = true })
    vim.api.nvim_set_hl(0, 'TodoBgTodo', { fg = thm.grey, bg = thm.yellow, bold = true })
    vim.api.nvim_set_hl(0, 'TodoBgWarn', { fg = thm.brightyellow, bold = true })
    vim.api.nvim_set_hl(0, 'TodoFgFix', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'TodoFgHack', { fg = thm.brightyellow })
    vim.api.nvim_set_hl(0, 'TodoFgNote', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'TodoFgPerf', { fg = thm.brightmagenta })
    vim.api.nvim_set_hl(0, 'TodoFgTest', { fg = thm.brightmagenta })
    vim.api.nvim_set_hl(0, 'TodoFgTodo', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'TodoFgWarn', { fg = thm.brightyellow })
    vim.api.nvim_set_hl(0, 'TodoSignFix', { link = 'TodoFgFix' })
    vim.api.nvim_set_hl(0, 'TodoSignHack', { link = 'TodoFgHack' })
    vim.api.nvim_set_hl(0, 'TodoSignNote', { link = 'TodoFgNote' })
    vim.api.nvim_set_hl(0, 'TodoSignPerf', { link = 'TodoFgPerf' })
    vim.api.nvim_set_hl(0, 'TodoSignTest', { link = 'TodoFgTest' })
    vim.api.nvim_set_hl(0, 'TodoSignTodo', { link = 'TodoFgTodo' })
    vim.api.nvim_set_hl(0, 'TodoSignWarn', { link = 'TodoFgWarn' })

    ---------------------------- UI and Status ----------------------------------

    -- StatusLine
    vim.api.nvim_set_hl(0, 'StatusLine', { fg = thm.yellow, bg = thm.background })

    vim.api.nvim_set_hl(0, 'StText', { fg = thm.brightgreen, bg = thm.background })

    vim.api.nvim_set_hl(0, 'St_file', { fg = thm.black, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_filemod', { fg = thm.red, bold = true, underline = true })
    vim.api.nvim_set_hl(0, 'St_cursor', { fg = thm.black, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_cwd', { fg = thm.blue, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_ft', { fg = thm.brightblue, bg = thm.background })

    vim.api.nvim_set_hl(0, 'St_lspMsg', { fg = thm.brightyellow, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_lspError', { fg = thm.brightred, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_lspWarning', { fg = thm.brightyellow, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_lspHints', { fg = thm.brightmagenta, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_lspInfo', { fg = thm.brightblue, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_lsp', { fg = thm.cyan, bg = thm.background })

    vim.api.nvim_set_hl(0, 'St_GitAdded', { fg = thm.green, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_GitChanged', { fg = thm.yellow, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_GitRemoved', { fg = thm.red, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_GitAhead', { fg = thm.brightblue, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_GitBehind', { fg = thm.brightblue, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_GitUntracked', { fg = thm.red, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_GitBranch', { fg = thm.magenta, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_GitConflicted', { fg = thm.brightred, bg = thm.background })

    vim.api.nvim_set_hl(0, 'St_NormalMode', { fg = thm.brightblue, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_VisualMode', { fg = thm.brightcyan, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_InsertMode', { fg = thm.brightred, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_TerminalMode', { fg = thm.brightgreen, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_NTerminalMode', { fg = thm.yellow, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_ReplaceMode', { fg = thm.brightyellow, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_ConfirmMode', { fg = thm.cyan, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_CommandMode', { fg = thm.brightgreen, bg = thm.background })
    vim.api.nvim_set_hl(0, 'St_SelectMode', { fg = thm.blue, bg = thm.background })

    -- Render-markdown
    vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = thm.dark })
    vim.api.nvim_set_hl(0, 'RenderMarkdownCodeInline', { fg = thm.brightred })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH1Bg', { fg = thm.cyan, bold = true })
    vim.api.nvim_set_hl(0, 'markdownh1', { fg = thm.cyan, bold = true })
    vim.api.nvim_set_hl(0, 'markdownh2', { fg = thm.magenta, bold = true })
    vim.api.nvim_set_hl(0, 'markdownh3', { fg = thm.blue, bold = true })
    vim.api.nvim_set_hl(0, 'markdownh4', { fg = thm.white, bold = true })
    vim.api.nvim_set_hl(0, 'markdownh5', { fg = thm.black, bold = true })
    vim.api.nvim_set_hl(0, 'markdownh6', { fg = thm.brightblack, bold = true })

    -- Code
    -- vim.api.nvim_set_hl(0, 'markdowncode', { fg = thm.brightred, bg = thm.dark })
    vim.api.nvim_set_hl(0, 'markdowncodeblock', { fg = thm.brightyellow })
    vim.api.nvim_set_hl(0, 'markdowncodedelimiter', { fg = thm.brightblack })

    -- Links
    vim.api.nvim_set_hl(0, 'markdownurl', { fg = thm.brightblack, underline = true })
    vim.api.nvim_set_hl(0, 'markdownlinktext', { fg = thm.yellow, underline = true })
    vim.api.nvim_set_hl(0, 'markdownlinkdelimiter', { fg = thm.blue })

    -- Emphasis and Formatting
    vim.api.nvim_set_hl(0, 'markdownitalic', { fg = thm.yellow, italic = true })
    vim.api.nvim_set_hl(0, 'markdownbold', { fg = thm.red, bold = true })
    vim.api.nvim_set_hl(0, 'markdownbolditalic', { fg = thm.cyan, bold = true, italic = true })
    vim.api.nvim_set_hl(0, 'markdownstrike', { fg = thm.brightblue, strikethrough = true })

    -- Blockquotes and Rules
    vim.api.nvim_set_hl(0, 'markdownblockquote', { fg = thm.brightblack, italic = true })
    vim.api.nvim_set_hl(0, 'markdownrule', { fg = thm.brightblack })

    -- Lists
    vim.api.nvim_set_hl(0, 'markdownlistmarker', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'markdowntable', { fg = thm.blue })

    -- Tasks
    vim.api.nvim_set_hl(0, 'markdowntaskchecked', { fg = thm.brightgreen })
    vim.api.nvim_set_hl(0, 'markdowntaskunchecked', { fg = thm.brightblack })

    -- Highlight Groups for Code Syntax
    vim.api.nvim_set_hl(0, 'markdowncomment', { fg = thm.brightblack })
    vim.api.nvim_set_hl(0, 'markdowncommentpreproc', { fg = thm.brightcyan })
    vim.api.nvim_set_hl(0, 'markdownkeyword', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, 'markdownkeywordtype', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'markdownoperator', { fg = thm.black })
    vim.api.nvim_set_hl(0, 'markdownpunctuation', { fg = thm.white })

    -- String and Literals
    vim.api.nvim_set_hl(0, 'markdownstring', { fg = thm.green })
    vim.api.nvim_set_hl(0, 'markdownstringescape', { fg = thm.brightcyan })

    -- Errors and Inserts
    vim.api.nvim_set_hl(0, 'markdownerror', { fg = thm.white, bg = thm.brightred })
    vim.api.nvim_set_hl(0, 'markdowninsert', { fg = thm.brightgreen })
    vim.api.nvim_set_hl(0, 'markdowndelete', { fg = thm.red })

    -- Special Elements
    vim.api.nvim_set_hl(0, 'markdowndefinitionterm', { fg = thm.brightmagenta })
    vim.api.nvim_set_hl(0, 'markdowndefinitiondescription', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'markdownenumeration', { fg = thm.blue })

    -- Images
    vim.api.nvim_set_hl(0, 'markdownimage', { fg = thm.brightblack, underline = true })
    vim.api.nvim_set_hl(0, 'markdownimagetext', { fg = thm.yellow })

    -- Devicons
    vim.api.nvim_set_hl(0, 'DevIconc', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'DevIconcss', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'DevIcondeb', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, 'DevIconDockerfile', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, 'DevIconhtml', { fg = thm.brightred })
    vim.api.nvim_set_hl(0, 'DevIconjpeg', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, 'DevIconjpg', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, 'DevIconjs', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'DevIconkt', { fg = thm.brightyellow })
    vim.api.nvim_set_hl(0, 'DevIconlock', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'DevIconlua', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'DevIconmp3', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'DevIconmp4', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'DevIconout', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'DevIconpng', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, 'DevIconpy', { fg = thm.cyan })
    vim.api.nvim_set_hl(0, 'DevIcontoml', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'DevIconts', { fg = thm.brightcyan })
    vim.api.nvim_set_hl(0, 'DevIconttf', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'DevIconrb', { fg = thm.magenta })
    vim.api.nvim_set_hl(0, 'DevIconrpm', { fg = thm.brightyellow })
    vim.api.nvim_set_hl(0, 'DevIconvue', { fg = thm.brightgreen })
    vim.api.nvim_set_hl(0, 'DevIconwoff', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'DevIconwoff2', { fg = thm.white })
    vim.api.nvim_set_hl(0, 'DevIconxz', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'DevIconzip', { fg = thm.yellow })
    vim.api.nvim_set_hl(0, 'DevIconZig', { fg = thm.brightyellow })
    vim.api.nvim_set_hl(0, 'DevIconMd', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'DevIconTSX', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'DevIconJSX', { fg = thm.blue })
    vim.api.nvim_set_hl(0, 'DevIconSvelte', { fg = thm.red })
    vim.api.nvim_set_hl(0, 'DevIconJava', { fg = thm.brightyellow })
    vim.api.nvim_set_hl(0, 'DevIconDart', { fg = thm.cyan })
  end,
}
