return {
  -- https://github.com/christoomey/vim-tmux-navigator
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
    keys = {
      { '<c-h>', '<cmd>TmuxNavigateLeft<CR>', { desc = 'switch window left' } },
      { '<c-j>', '<cmd>TmuxNavigateDown<CR>', { desc = 'switch window down' } },
      { '<c-k>', '<cmd>TmuxNavigateUp<CR>', { desc = 'switch window up' } },
      { '<c-l>', '<cmd>TmuxNavigateRight<CR>', { desc = 'switch window right' } },
      { '<c-\\>', '<cmd>TmuxNavigatePrevious<CR>', { desc = 'switch last window' } },
    },
  },

  -- https://github.com/ThePrimeagen/harpoon/tree/harpoon2
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
  },

  -- https://github.com/nvim-telescope/telescope.nvim
  {
    'nvim-telescope/telescope.nvim',
    lazy = false, --TODO figure out why this is needed
    opts = function()
      local actions = require 'telescope.actions'

      return {
        defaults = {
          prompt_prefix = '   ',
          selection_caret = ' ',
          entry_prefix = ' ',
          sorting_strategy = 'ascending',
          layout_config = {
            horizontal = {
              prompt_position = 'top',
              preview_width = 0.55,
            },
            width = 0.87,
            height = 0.80,
          },
          mappings = {
            n = { ['q'] = actions.close },
          },
        },
      }
    end,
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
        filters = { dotfiles = true },
        live_filter = { prefix = ' ' },
        help = { sort_by = 'desc' },
      }
    end,
  },
}
