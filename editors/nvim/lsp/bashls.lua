-- https://github.com/bash-lsp/bash-language-server/tree/main?tab=readme-ov-file#neovim
return {
  cmd = { 'bash-language-server', 'start' },
  -- bashls is only useful for Bash-compatible files here; Zsh buffers get
  -- their own syntax/filetype handling and should not inherit Bash diagnostics.
  filetypes = { 'bash', 'sh' },
  settings = {
    bashIde = {
      globPattern = '*@(.sh|.inc|.bash|.command|profile|.bashrc|.bash_profile)',
    },
  },
}
