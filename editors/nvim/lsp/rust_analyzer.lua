-- https://rust-analyzer.github.io/book/other_editors.html#neovim
return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },

  root_markers = {
    'rust-project.json',
    'Cargo.toml',
    '.git',
  },

  settings = {
    ['rust-analyzer'] = {
      check = {
        command = 'clippy',
      },
    },
  },
}
