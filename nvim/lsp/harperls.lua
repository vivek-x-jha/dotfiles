return {
  cmd = { 'harper-ls' },
  filetypes = { 'markdown', 'text' },
  root_markers = { '.git', '.nvim-root' },

  settings = {
    userDictPath = '',
    fileDictPath = '',
    linters = {
      SpellCheck = true,
      SpelledNumbers = false,
      AnA = true,
      SentenceCapitalization = true,
      UnclosedQuotes = true,
      WrongQuotes = false,
      LongSentences = true,
      RepeatedWords = true,
      Spaces = true,
      Matcher = true,
      CorrectNumberSuffix = true,
    },

    codeActions = {
      ForceStable = false,
    },

    markdown = {
      IgnoreLinkTitle = false,
    },

    diagnosticSeverity = 'hint',
    isolateEnglish = false,
    dialect = 'American',
  },
}
