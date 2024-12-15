-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
			{ out, 'WarningMsg' },
			{ '\nPress any key to exit...' },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Load Highlights
local b16 = require 'ui.base16'
b16.highlight {

	LazyH1 = { fg = b16.brightgreen },
	LazyBorder = { fg = b16.brightblack },
	LazyButton = { fg = b16.grey },
	LazyH2 = { fg = b16.magenta, bold = true },
	LazyReasonPlugin = { fg = b16.red },
	LazyValue = { fg = b16.cyan },
	LazyDir = { fg = b16.blue },
	LazyUrl = { fg = b16.red },
	LazyCommit = { fg = b16.green },
	LazyNoCond = { fg = b16.red },
	LazySpecial = { fg = b16.blue },
	LazyReasonFt = { fg = b16.brightmagenta },
	LazyOperator = { fg = b16.white },
	LazyReasonKeys = { fg = b16.cyan },
	LazyTaskOutput = { fg = b16.white },
	LazyCommitIssue = { fg = b16.magenta },
	LazyReasonEvent = { fg = b16.yellow },
	LazyReasonStart = { fg = b16.white },
	LazyReasonRuntime = { fg = b16.brightyellow },
	LazyReasonCmd = { fg = b16.yellow },
	LazyReasonSource = { fg = b16.cyan },
	LazyReasonImport = { fg = b16.white },
	LazyProgressDone = { fg = b16.green },
}

-- Configuration
require('lazy').setup {
	defaults = {
		lazy = true,
		version = '*',
	},

	spec = 'plugins',

	install = {
		colorscheme = { 'nvchad' },
	},

	ui = {
		border = 'single',
		icons = {
			ft = '',
			lazy = '󰂠 ',
			loaded = '',
			not_loaded = '',
		},
	},

	performance = {
		rtp = {
			disabled_plugins = {
				'2html_plugin',
				'tohtml',
				'getscript',
				'getscriptPlugin',
				'gzip',
				'logipat',
				'netrw',
				'netrwPlugin',
				'netrwSettings',
				'netrwFileHandlers',
				'matchit',
				'tar',
				'tarPlugin',
				'rrhelper',
				'spellfile_plugin',
				'vimball',
				'vimballPlugin',
				'zip',
				'zipPlugin',
				'tutor',
				'rplugin',
				'syntax',
				'synmenu',
				'optwin',
				'compiler',
				'bugreport',
				'ftplugin',
			},
		},
	},
}
