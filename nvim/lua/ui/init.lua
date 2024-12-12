local env = vim.env
local fn = vim.fn
local fs = vim.fs

local api = vim.api
local create_autocmd = api.nvim_create_autocmd
local create_usercmd = api.nvim_create_user_command

local colorify = require 'ui.colorify'
local dashboard = require 'ui.dashboard'
local lspsignature = require 'ui.lsp.signature'
local mason = require 'ui.mason'
local tabufline = require 'ui.tabufline'
local utils = require 'ui.utils'

-- Load UI elements
vim.o.statusline = "%!v:lua.require('ui.statusline')()"
require('ui.statusline.utils').autocmds()
require 'ui.tabufline.lazyload'
require 'ui.defaults'
require 'ui.git'
require 'ui.terminal'

-- Toggle NvDash
create_usercmd('Dashboard', function()
	if vim.g.dashboard_displayed then
		tabufline.close_buffer()
	else
		dashboard.open()
	end
end, {})

-- Setup autocommands
vim.schedule(function()
	-- load nvdash only on empty file
	local buf_lines = api.nvim_buf_get_lines(0, 0, 1, false)
	local no_buf_content = api.nvim_buf_line_count(0) == 1 and buf_lines[1] == ''
	local bufname = api.nvim_buf_get_name(0)

	if bufname == '' and no_buf_content then dashboard.open() end

	create_autocmd('LspAttach', {
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

	-- reload the plugin!
	create_autocmd('BufWritePost', {
		pattern = vim.tbl_map(
			function(path) return fs.normalize(vim.uv.fs_realpath(path) or path) end,
			fn.glob(fn.stdpath 'config' .. '/lua/**/*.lua', true, true, true)
		),
		group = api.nvim_create_augroup('ReloadNvChad', {}),

		callback = function(opts)
			local fp = fn.fnamemodify(fs.normalize(api.nvim_buf_get_name(opts.buf)), ':r') --[[@as string]]
			local app_name = env.NVIM_APPNAME and env.NVIM_APPNAME or 'nvim'
			local module = string.gsub(fp, '^.*/' .. app_name .. '/lua/', ''):gsub('/', '.')

			utils.reload(module)
			-- vim.cmd("redraw!")
		end,
	})

	create_usercmd('MasonInstallAll', function() mason.install_all() end, {})

	colorify.run()
end)
