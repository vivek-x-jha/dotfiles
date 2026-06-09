local icons = require 'ui.icons'

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
    special_files = {
      'Icon\r',
      'Session.vim',
    },

    root_folder_label = false,
    highlight_git = 'icon',
    highlight_diagnostics = 'all',
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
          empty = icons.folder,
          empty_open = icons.folder,
          open = icons.folder,
          symlink = icons.folder,
        },
        symlink = icons.link,

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

local ok, api = pcall(require, 'nvim-tree.api')
if ok then
  local events = api.events.Event
  for _, event in ipairs { events.FileCreated, events.FileRemoved, events.FolderRemoved, events.NodeRenamed } do
    api.events.subscribe(event, function() require('workspace').schedule_session_sync() end)
  end
end
