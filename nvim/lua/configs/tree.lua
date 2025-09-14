local icn = require 'icons'

require('nvim-web-devicons').setup {
  override = {
    default_icon = { icon = icn.completions.File, name = 'Default' },
    js = { icon = icn.javascript, name = 'js' },
    ts = { icon = icn.typescript, name = 'ts' },
    lock = { icon = icn.lock, name = 'lock' },
    ['robots.txt'] = { icon = icn.robot, name = 'robots' },
  },
}

require('nvim-tree').setup {
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

vim.keymap.set('n', '<C-n>', function()
  require('nvim-tree.api').tree.toggle { focus = false }
  vim.cmd 'wincmd ='
end, { desc = 'Toggle file explorer' })

vim.keymap.set('n', '<leader>e', function()
  require('nvim-tree.api').tree.open()
  vim.cmd 'wincmd ='
end, { desc = 'Focus file [e]xplorer' })
