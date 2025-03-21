return {
  -- https://github.com/ibhagwan/fzf-lua
  {
    'ibhagwan/fzf-lua',
    lazy = false,
    keys = {
      { '<leader>fw', '<cmd>FzfLua live_grep<CR>', { desc = 'Find words' } },
      { '<leader>ff', '<cmd>FzfLua files<CR>', { desc = 'Find files' } },
      { '<leader>fb', '<cmd>FzfLua buffers<CR>', { desc = 'Find buffers' } },
      { '<leader>fo', '<cmd>FzfLua oldfiles<CR>', { desc = 'Recent buffers' } },
      { '<leader>fc:', '<cmd>FzfLua command_history<cr>', { desc = 'Find commands' } },
      { '<leader>fn', '<cmd>FzfLua commands<cr>', { desc = 'Find Neovim commands' } },
      { '<leader>fx', '<cmd>FzfLua autocmds<cr>', { desc = 'Find Neovim Auto Commands' } },

      { '<leader>gs', '<cmd>FzfLua git_branches<CR>', { desc = 'Switch branches' } },
    },
    opts = {},
  },

  -- https://github.com/christoomey/vim-tmux-navigator
  {
    'christoomey/vim-tmux-navigator',
    keys = {
      { '<c-h>', '<cmd>TmuxNavigateLeft<CR>', { desc = 'switch window left' } },
      { '<c-j>', '<cmd>TmuxNavigateDown<CR>', { desc = 'switch window down' } },
      { '<c-k>', '<cmd>TmuxNavigateUp<CR>', { desc = 'switch window up' } },
      { '<c-l>', '<cmd>TmuxNavigateRight<CR>', { desc = 'switch window right' } },
      { '<c-\\>', '<cmd>TmuxNavigatePrevious<CR>', { desc = 'switch last window' } },
    },
  },

  -- https://github.com/nvim-tree/nvim-tree.lua
  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
    opts = function()
      local icn = require 'ui.icons'

      return {
        hijack_cursor = true,
        disable_netrw = true,
        sync_root_with_cwd = true,
        view = { preserve_window_proportions = true },

        renderer = {
          root_folder_label = false,
          special_files = { 'README.md' },
          highlight_git = true,
          highlight_diagnostics = true,
          highlight_modified = 'icon',
          indent_markers = {
            enable = true,
            icons = {
              edge = '┊',
              item = '┊',
            },
          },
          icons = {
            modified_placement = 'signcolumn',
            diagnostics_placement = 'before',
            glyphs = {
              modified = icn.modified,
              folder = {
                default = '󰉖',
                empty = '󱧹',
                empty_open = '󰷏',
                open = '󰷏',
                symlink = '󱉆',
              },
              git = {
                renamed = '󰑙',
                staged = '+',
                unmerged = '!',
                unstaged = '~',
                untracked = '?',
                ignored = '',
              },
            },
          },
        },

        update_focused_file = { enable = true },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
          icons = {
            hint = icn.hint,
            info = icn.info,
            warning = icn.warn,
            error = icn.error,
          },
        },
        modified = { enable = true },
        filters = { git_ignored = false },
        live_filter = { prefix = ' ' },
        help = { sort_by = 'desc' },
      }
    end,
  },
}
