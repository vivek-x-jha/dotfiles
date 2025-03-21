return {
  -- https://github.com/ibhagwan/fzf-lua
  {
    'ibhagwan/fzf-lua',
    lazy = false,
    keys = {
      { '<leader>ff', '<cmd>FzfLua files<CR>', { desc = '[F]ind [F]iles' } },
      { '<leader>fo', '<cmd>FzfLua oldfiles<CR>', { desc = '[R]ecent [B]uffers' } },
      { '<leader>fa', '<cmd>FzfLua autocmds<cr>', { desc = '[F]ind Neovim [A]uto-commands' } },
      { '<leader>fw', '<cmd>FzfLua live_grep<CR>', { desc = '[F]ind [W]ord' } },
      { '<leader>fc:', '<cmd>FzfLua command_history<cr>', { desc = '[F]ind [C]ommands' } },
      { '<leader>fb', '<cmd>FzfLua buffers<CR>', { desc = '[F]ind [B]uffers' } },
      { '<leader>fn', '<cmd>FzfLua commands<cr>', { desc = '[F]ind Neovim [C]ommands' } },
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
