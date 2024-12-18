-- https://github.com/nvim-tree/nvim-tree.lua
return {
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
					warning = icn.warning,
					error = icn.error,
				},
			},
			modified = { enable = true },
			filters = { dotfiles = true },
			live_filter = { prefix = ' ' },
			help = { sort_by = 'desc' },
		}
	end,
}
