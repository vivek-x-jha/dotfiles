local icons = require 'icons'

require('nvim-web-devicons').setup {
  override = {
    default_icon = { icon = icons.file, name = 'Default' },
    js = { icon = icons.javascript, name = 'js' },
    ts = { icon = icons.typescript, name = 'ts' },
    lock = { icon = icons.lock, name = 'lock' },
    ['robots.txt'] = { icon = icons.robot, name = 'robots' },
  },
}

require('nvim-tree').setup {
  hijack_cursor = true,
  disable_netrw = true,
  sync_root_with_cwd = true,
  filesystem_watchers = { enable = false },
  view = { preserve_window_proportions = true },
  update_focused_file = { enable = true },
  modified = { enable = true },
  filters = { git_ignored = false },
  live_filter = { prefix = icons.search .. ' ' },
  help = { sort_by = 'desc' },

  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = 'H',
      info = 'I',
      warning = 'W',
      error = 'E',
    },
  },

  renderer = {
    root_folder_label = false,
    special_files = { 'README.md' },
    highlight_git = true,
    highlight_diagnostics = true,
    highlight_modified = 'icon',

    indent_markers = {
      enable = true,
      icons = { edge = '┊', item = '┊' },
    },

    icons = {
      modified_placement = 'signcolumn',
      diagnostics_placement = 'before',

      glyphs = {
        modified = icons.modified,

        folder = {
          default = icons.folder,
          empty = '󱧹',
          empty_open = '󰷏',
          open = '󰷏',
          symlink = '󱉆',
        },

        git = {
          renamed = '𝙍',
          staged = '+',
          unmerged = '!',
          unstaged = '~',
          untracked = '?',
          ignored = '',
          deleted = '✘',
        },
      },
    },
  },
}
