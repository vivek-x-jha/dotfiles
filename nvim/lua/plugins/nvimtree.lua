-- https://github.com/nvim-tree/nvim-tree.lua
return {
	'nvim-tree/nvim-tree.lua',
	cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
	opts = function()
		local b16 = require 'ui.base16'
		b16.highlight {
			NvimTreeCursorLine = { fg = b16.white, underline = true },
			NvimTreeFileName = { fg = b16.black },
			NvimTreeExecFile = { fg = b16.brightgreen },
			NvimTreeSpecialFile = { fg = b16.brightyellow },
			NvimTreeFolderIcon = { fg = b16.blue },
			NvimTreeIndentMarker = { fg = b16.brightmagenta },
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
				indent_markers = {
					enable = true,
					icons = {
						edge = '┊',
						item = '┊',
					},
				},
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
