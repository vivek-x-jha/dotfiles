local api = vim.api
local g = vim.g

local colorify = require 'ui.colorify'
local dashboard = require 'dashboard'
local lspsignature = require 'ui.lsp.signature'
local mason = require 'ui.mason'
local tabufline = require 'ui.tabufline'

-- user event that loads after UIEnter + only if file buf is there
api.nvim_create_autocmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
	group = api.nvim_create_augroup('NvFilePost', { clear = true }),
	callback = function(args)
		local file = api.nvim_buf_get_name(args.buf)
		local buftype = api.nvim_get_option_value('buftype', { buf = args.buf })

		if not g.ui_entered and args.event == 'UIEnter' then g.ui_entered = true end

		if file ~= '' and buftype ~= 'nofile' and g.ui_entered then
			api.nvim_exec_autocmds('User', { pattern = 'FilePost', modeline = false })
			api.nvim_del_augroup_by_name 'NvFilePost'

			vim.schedule(function()
				api.nvim_exec_autocmds('FileType', {})

				if g.editorconfig then require('editorconfig').config(args.buf) end
			end)
		end
	end,
})

-- Maintain fold state on reopen
api.nvim_create_autocmd('BufWinLeave', {
	pattern = { '*.*' },
	desc = 'save view (folds), when closing file',
	command = 'mkview',
})

api.nvim_create_autocmd('BufWinEnter', {
	pattern = { '*.*' },
	desc = 'load view (folds), when opening file',
	command = 'silent! loadview',
})

-- Start Showkeys on open
api.nvim_create_autocmd('VimEnter', {
	callback = function() vim.cmd 'ShowkeysToggle' end,
	desc = 'Start ShowkeysToggle on Neovim launch',
})

-- Toggle Dashboard
api.nvim_create_user_command('Dashboard', function()
	if vim.g.dashboard_displayed then
		tabufline.close_buffer()
	else
		dashboard.open()
	end
end, {})

vim.schedule(function()
	-- load nvdash only on empty file
	local buf_lines = api.nvim_buf_get_lines(0, 0, 1, false)
	local no_buf_content = api.nvim_buf_line_count(0) == 1 and buf_lines[1] == ''
	local bufname = api.nvim_buf_get_name(0)

	if bufname == '' and no_buf_content then dashboard.open() end

	api.nvim_create_autocmd('LspAttach', {
		callback = function(args)
			vim.schedule(function()
				local client = vim.lsp.get_client_by_id(args.data.client_id)

				if client then
					local signatureProvider = client.server_capabilities.signatureHelpProvider
					if signatureProvider and signatureProvider.triggerCharacters then lspsignature.setup(client, args.buf) end
				end
			end)
		end,
	})

	api.nvim_create_user_command('MasonInstallAll', function() mason.install_all() end, {})

	colorify.run()
end)
