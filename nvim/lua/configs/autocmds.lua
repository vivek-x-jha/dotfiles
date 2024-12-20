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

local bufempty = function()
	local buf_lines = buflines(0, 0, 1, false)
	local no_buf_content = bufline_cnt(0) == 1 and buf_lines[1] == ''

	return bufname(0) == '' and no_buf_content
end

local tree_events = {
	{ events = { 'BufWritePost', 'BufDelete', 'BufNewFile' } },
	{ events = { 'DirChanged', 'FocusGained', 'CursorHold' } },
	{ events = { 'User' }, pattern = { 'GitCommitPost', 'GitRebasePost', 'GitCheckoutPost', 'GitPullPost', 'GitMergePost' } },
	{ events = { 'VimLeavePre', 'VimEnter' } },
}

---------------------------- Initialization ----------------------------------

usrcmd('Dashboard', function()
	if g.dashboard_displayed then
		require('ui.buffers').close()
	else
		require('ui.dashboard').open()
	end
end, {
	desc = 'Toggle Dashboard',
})

aucmd('VimEnter', {
	group = augroup('Dashboard', { clear = true }),
	callback = function()
		if bufempty() then vim.cmd 'Dashboard' end
	end,
	desc = 'Display Dashboard on blank startup',
})

aucmd('VimEnter', {
	group = augroup('Showkeys', { clear = true }),
	callback = function() vim.cmd 'ShowkeysToggle' end,
	desc = 'Initialize Showkeys on startup',
})

---------------------------- UI Preparation ----------------------------------

aucmd('FileType', {
	group = augroup('Spectre', { clear = true }),
	pattern = 'spectre_panel',
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
	desc = 'Hide line numbers for Spectre',
})

aucmd('BufWinEnter', {
	group = augroup('Folds', { clear = true }),
	pattern = { '*.*' },
	desc = 'Load folds when opening file',
	command = 'silent! loadview',
})

aucmd('BufWinLeave', {
	group = augroup('Folds', { clear = true }),
	pattern = { '*.*' },
	desc = 'Save folds when closing file',
	command = 'mkview',
})

aucmd('TermClose', {
	group = augroup('Terminal', { clear = true }),
	callback = function(args) require('ui.terminal').save(args.buf, nil) end,
	desc = 'Save terminal state on close',
})

for _, action in ipairs(tree_events) do
	aucmd(action.events, {
		group = augroup('NvimTreeRefresh', { clear = true }),
		pattern = action.pattern,
		callback = function() require('nvim-tree.api').tree.reload() end,
		desc = 'Reloads Nvim-Tree on most events',
	})
end

-- Load LSP Progress bar
require('ui.statusline').autocmds()

---------------------------- Deferred ----------------------------------

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
	desc = 'Wait to load user events on non-empty buffers',
})

vim.schedule(function()
	aucmd('LspAttach', {
		group = augroup('LSP', { clear = true }),
		callback = function(args)
			vim.schedule(function()
				local client = vim.lsp.get_client_by_id(args.data.client_id)

				if client then
					local signatureProvider = client.server_capabilities.signatureHelpProvider
					if signatureProvider and signatureProvider.triggerCharacters then require('ui.lsp.signature').setup(client, args.buf) end
				end
			end)
		end,
		desc = 'Initialize LSP config',
	})

	usrcmd('MasonInstallAll', function() require('ui.mason').install_all() end, {
		desc = 'Install all language servers',
	})

	-- Initialize colorify
	require('ui.colorify').run()
end)
