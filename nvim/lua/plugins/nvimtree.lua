-- https://github.com/nvim-tree/nvim-tree.lua
return {
	'nvim-tree/nvim-tree.lua',
	cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
	opts = function()
		return {
			filters = { dotfiles = false },
			disable_netrw = true,
			hijack_cursor = true,
			sync_root_with_cwd = true,
			update_focused_file = { enable = true, update_root = false },
			view = { side = 'left', width = 30, preserve_window_proportions = true },

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
							renamed = '󰑙',
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
