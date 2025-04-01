-- https://github.com/bash-lsp/bash-language-server/tree/main?tab=readme-ov-file#neovim
return {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh', 'zsh' },
  settings = {
    bashIde = {
      globPattern = '*@(.sh|.inc|.bash|.command|.bashrc|.bash_profile|.zshrc|.zshenv|.zprofile)',
    },
  },
}
