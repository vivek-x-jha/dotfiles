-- https://github.com/christoomey/vim-tmux-navigator
return {
  'christoomey/vim-tmux-navigator',
  keys = {
    { '<c-h>', '<cmd>TmuxNavigateLeft<CR>', { desc = 'switch window left' } },
    { '<c-j>', '<cmd>TmuxNavigateDown<CR>', { desc = 'switch window down' } },
    { '<c-k>', '<cmd>TmuxNavigateUp<CR>', { desc = 'switch window up' } },
    { '<c-l>', '<cmd>TmuxNavigateRight<CR>', { desc = 'switch window right' } },
    { '<c-\\>', '<cmd>TmuxNavigatePrevious<CR>', { desc = 'switch last window' } },
  },
}
