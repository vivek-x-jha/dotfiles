-- https://github.com/ibhagwan/smartyank.nvim

return {
  'ibhagwan/smartyank.nvim',
  opts = {
    highlight = {
      enabled = true,
      higroup = 'YankFlash',
      timeout = 2000,
    },
    clipboard = {
      enabled = true,
    },
    tmux = {
      enabled = true,
      cmd = { 'tmux', 'set-buffer', '-w' },
    },
    osc52 = {
      enabled = true,
      ssh_only = true,
      silent = false,
      echo_hl = 'Directory',
    },
  },
}
