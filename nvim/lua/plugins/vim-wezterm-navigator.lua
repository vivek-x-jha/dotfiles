local M = {}

function M.setup()
  local map = vim.api.nvim_set_keymap
  local options = { noremap = true, silent = true }

  -- Map ctrl + h/j/k/l for navigation
  map("n", "<C-h>", ":lua require'plugins.vim-wezterm-navigator'.navigate('h')<CR>", options)
  map("n", "<C-j>", ":lua require'plugins.vim-wezterm-navigator'.navigate('j')<CR>", options)
  map("n", "<C-k>", ":lua require'plugins.vim-wezterm-navigator'.navigate('k')<CR>", options)
  map("n", "<C-l>", ":lua require'plugins.vim-wezterm-navigator'.navigate('l')<CR>", options)
end

function M.navigate(direction)
  -- Define commands for direction
  local cmd = {
    h = "wincmd h",
    j = "wincmd j",
    k = "wincmd k",
    l = "wincmd l",
  }
  -- Navigate within Neovim using wincmd
  vim.cmd(cmd[direction])
end

return M
