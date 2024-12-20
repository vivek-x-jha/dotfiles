local g = vim.g

local api = vim.api
local aucmd = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup
local bufline_cnt = api.nvim_buf_line_count
local buflines = api.nvim_buf_get_lines
local bufname = api.nvim_buf_get_name
local clear_aucmds = api.nvim_clear_autocmds
local curline = api.nvim_get_current_line
local cursor = api.nvim_win_get_cursor
local del_augroup = api.nvim_del_augroup_by_name
local exec_aucmds = api.nvim_exec_autocmds
local usrcmd = api.nvim_create_user_command
local value = api.nvim_get_option_value

local vlsp = vim.lsp
local lsp_handlers = vlsp.handlers
local lsp_buf = vlsp.buf
local lsp_with = vlsp.with

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

local check_triggeredChars = function(triggerChars)
	local cur_line = curline()
	local pos = cursor(0)[2]
	local prev_char = cur_line:sub(pos - 1, pos - 1)
	local cur_char = cur_line:sub(pos, pos)

	for _, char in ipairs(triggerChars) do
		if cur_char == char or prev_char == char then return true end
	end
end

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
	-- Initialize colorify
	require('ui.colorify').run()

	aucmd('LspAttach', {
		group = augroup('LSP', { clear = true }),
		callback = function(args)
			vim.schedule(function()
				local client = vim.lsp.get_client_by_id(args.data.client_id)

				if client then
					local signatureProvider = client.server_capabilities.signatureHelpProvider

					if signatureProvider and signatureProvider.triggerCharacters then
						local LspAuGroup = augroup('LspSignature', { clear = false })
						local triggerChars = client.server_capabilities.signatureHelpProvider.triggerCharacters

						lsp_handlers['textDocument/signatureHelp'] = lsp_with(lsp_handlers.signature_help, {
							border = 'rounded',
							focusable = false,
							silent = true,
							max_height = 7,
						})

						clear_aucmds { group = LspAuGroup, buffer = args.buf }
						aucmd('TextChangedI', {
							group = LspAuGroup,
							buffer = args.buf,
							callback = function()
								if check_triggeredChars(triggerChars) then lsp_buf.signature_help() end
							end,
							desc = 'Detects Trigger Characters on Insert',
						})
					end
				end
			end)
		end,
		desc = 'Initialize LSP config',
	})

	usrcmd('MasonInstallAll', function()
		local masonames = require 'ui.masonames'
		local pkgs = {}

		local get_pkgs = function()
			local tools = {}

			local lsps = require('lspconfig.util').available_servers()
			vim.list_extend(tools, lsps)

			local conform_exists, conform = pcall(require, 'conform')

			if conform_exists then
				for _, v in ipairs(conform.list_all_formatters()) do
					local fmts = vim.split(v.name:gsub(',', ''), '%s+')
					vim.list_extend(tools, fmts)
				end
			end

			-- nvim-lint
			local lint_exists, lint = pcall(require, 'lint')

			if lint_exists then
				local linters = lint.linters_by_ft

				for _, v in pairs(linters) do
					vim.list_extend(tools, v)
				end
			end

			for _, v in pairs(tools) do
				table.insert(pkgs, masonames[v])
			end

			return pkgs
		end

		vim.cmd 'Mason'

		local mr = require 'mason-registry'

		mr.refresh(function()
			for _, tool in ipairs(get_pkgs()) do
				local p = mr.get_package(tool)

				if not p:is_installed() then p:install() end
			end
		end)
	end, {
		desc = 'Install all language servers',
	})
end)
