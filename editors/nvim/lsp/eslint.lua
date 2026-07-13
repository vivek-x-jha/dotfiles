-- https://github.com/hrsh7th/vscode-langservers-extracted#neovim
return {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },

  root_markers = {
    'eslint.config.js',
    'eslint.config.mjs',
    'eslint.config.cjs',
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.json',
    'package.json',
    '.git',
  },

  settings = {
    validate = 'on',
    packageManager = 'npm',
    useESLintClass = false,
    experimental = { useFlatConfig = false },
    codeAction = {
      disableRuleComment = { enable = true, location = 'separateLine' },
      showDocumentation = { enable = true },
    },
    codeActionOnSave = { enable = false, mode = 'all' },
    format = false,
    nodePath = '',
    onIgnoredFiles = 'off',
    problems = { shortenToSingleLine = false },
    quiet = false,
    rulesCustomizations = {},
    run = 'onType',
    workingDirectory = { mode = 'location' },
  },
}
