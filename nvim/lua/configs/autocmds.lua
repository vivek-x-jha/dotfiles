local g = vim.g
local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local bufline_cnt = vim.api.nvim_buf_line_count
local buflines = vim.api.nvim_buf_get_lines
local bufname = vim.api.nvim_buf_get_name
local del_augroup = vim.api.nvim_del_augroup_by_name
local exec_aucmds = vim.api.nvim_exec_autocmds
local usrcmd = vim.api.nvim_create_user_command
local value = vim.api.nvim_get_option_value

---------------------------- Initialization ----------------------------------

-- Toggle Dashboard
usrcmd('Dashboard', function()
	if g.dashboard_displayed then
		require('ui.buffers').close()
	else
		require('ui.dashboard').open()
	end
end, {})

-- Load Dashboard on start if no file opened
aucmd('VimEnter', {
	group = augroup('DashboardLoader', { clear = true }),
	callback = function()
		local buf_lines = buflines(0, 0, 1, false)
		local no_buf_content = bufline_cnt(0) == 1 and buf_lines[1] == ''
		local buf_name = bufname(0)

		if buf_name == '' and no_buf_content then vim.cmd 'Dashboard' end
	end,
})

-- Load Showkeys on start
aucmd('VimEnter', {
	callback = function() vim.cmd 'ShowkeysToggle' end,
	desc = 'Start ShowkeysToggle on Neovim launch',
})

---------------------------- UI Preparation ----------------------------------

-- Load LSP Progress bar
require('ui.statusline').autocmds()

-- Remove line numbers for Spectre buffers
aucmd('FileType', {
	pattern = 'spectre_panel',
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})

-- Maintain fold state on reopen
aucmd('BufWinEnter', {
	pattern = { '*.*' },
	desc = 'load view (folds), when opening file',
	command = 'silent! loadview',
})

aucmd('BufWinLeave', {
	pattern = { '*.*' },
	desc = 'save view (folds), when closing file',
	command = 'mkview',
})

-- Save terminal state on close
aucmd('TermClose', {
	callback = function(args) require('ui.terminal').save(args.buf, nil) end,
})

-- Reloads Nvim-Tree on most events
aucmd({ 'BufWritePost', 'BufDelete', 'BufNewFile', 'DirChanged', 'FocusGained', 'CursorHold', 'VimLeavePre', 'VimEnter', 'User' }, {
	pattern = { '*', 'GitCommitPost', 'GitRebasePost', 'GitCheckoutPost', 'GitPullPost', 'GitMergePost' },
	callback = function() require('nvim-tree.api').tree.reload() end,
})

---------------------------- Deferred ----------------------------------

-- Wait to load user events on non-empty buffers
aucmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
	group = augroup('NvFilePost', { clear = true }),
	callback = function(args)
		local file = bufname(args.buf)
		local buftype = value('buftype', { buf = args.buf })

		if not g.ui_entered and args.event == 'UIEnter' then g.ui_entered = true end

		if file ~= '' and buftype ~= 'nofile' and g.ui_entered then
			exec_aucmds('User', { pattern = 'FilePost', modeline = false })
			del_augroup 'NvFilePost'

			vim.schedule(function()
				exec_aucmds('FileType', {})

				if g.editorconfig then require('editorconfig').config(args.buf) end
			end)
		end
	end,
})

vim.schedule(function()
	-- Initialize LSP config
	aucmd('LspAttach', {
		callback = function(args)
			vim.schedule(function()
				local client = vim.lsp.get_client_by_id(args.data.client_id)

				if client then
					local signatureProvider = client.server_capabilities.signatureHelpProvider
					if signatureProvider and signatureProvider.triggerCharacters then require('ui.lsp.signature').setup(client, args.buf) end
				end
			end)
		end,
	})

	-- Install all language servers
	usrcmd('MasonInstallAll', function() require('ui.mason').install_all() end, {})

	-- Initialize colorify
	require('ui.colorify').run()
end)
