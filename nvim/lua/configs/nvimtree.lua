dofile(vim.g.base46_cache .. 'nvimtree')

vim.cmd [[
  :hi NvimTreeExecFile          guifg=#ceffc9
  :hi NvimTreeSpecialFile       guifg=#f3b175
  :hi NvimTreeSymlink           guifg=#fdf7cd
  :hi NvimTreeSymlinkFolderName guifg=#fdf7cd

  :hi NvimTreeGitNew            guifg=#ffc7c7
  :hi NvimTreeGitDirty          guifg=#fdf7cd
  :hi NvimTreeGitStaged         guifg=#ceffc9
  :hi NvimTreeGitRenamed        guifg=#c9ccfb
]]

return {
  filters = { dotfiles = false },
  disable_netrw = true,
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    side = 'left',
    width = 30,
    preserve_window_proportions = true,
  },
  renderer = {
    root_folder_label = false,
    highlight_git = true,
    indent_markers = { enable = true },
    icons = {
      glyphs = {
        default = '󰈚',
        folder = {
          default = '󰉖',
          empty = '󱧹',
          empty_open = '󰷏',
          open = '󰷏',
          symlink = '󱉆',
        },
        git = {
          renamed = 'r',
          staged = '+',
          unmerged = '!',
          unstaged = '~',
          untracked = '?',
        },
      },
    },
  },
}
