-- https://github.com/typescript-language-server/typescript-language-server#configuration
return {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },

  root_markers = {
    'package.json',
    'tsconfig.json',
    'jsconfig.json',
    '.git',
  },

  init_options = {
    hostInfo = 'neovim',
  },
}
