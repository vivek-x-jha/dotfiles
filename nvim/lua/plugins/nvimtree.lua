-- https://github.com/nvim-tree/nvim-tree.lua
return {
	'nvim-tree/nvim-tree.lua',
	cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
	opts = function()
		local b16 = require 'ui.base16'
		require('ui.utils').highlight {
			NvimTreeExecFile = { fg = b16.green },
			NvimTreeSpecialFile = { fg = b16.brightyellow },
			NvimTreeSymlink = { fg = b16.yellow },
			NvimTreeSymlinkFolderName = { fg = b16.yellow },
			NvimTreeGitNew = { fg = b16.red },
			NvimTreeGitDirty = { fg = b16.yellow },
			NvimTreeGitStaged = { fg = b16.green },
			NvimTreeGitRenamed = { fg = b16.brightmagenta },
		}

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
	end,
}
