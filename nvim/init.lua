--  _   _ ______ ______      _______ __  __
-- | \ | |  ____/ __ \ \    / /_   _|  \/  |
-- |  \| | |__ | |  | \ \  / /  | | | \  / |
-- | . ` |  __|| |  | |\ \/ /   | | | |\/| |
-- | |\  | |___| |__| | \  /   _| |_| |  | |
-- |_| \_|______\____/   \/   |_____|_|  |_|
-- https://neovim.io/doc/

local api = vim.api
local create_autocmd = api.nvim_create_autocmd
local create_usercmd = api.nvim_create_user_command
local env = vim.env
local fn = vim.fn
local g = vim.g
local o = vim.o
local opt = vim.opt

local colorify = require 'ui.colorify'
local dashboard = require 'ui.dashboard'
local lspsignature = require 'ui.lsp.signature'
local mason = require 'ui.mason'
local statusline = require 'ui.statusline'
local tabufline = require 'ui.tabufline'
local term = require 'ui.terminal'

local is_windows = fn.has 'win32' ~= 0
local sep = is_windows and '\\' or '/'
local delim = is_windows and ';' or ':'

local map = function(mode, lhs, rhs, desc, remap) vim.keymap.set(mode, lhs, rhs, { desc = desc, remap = remap or false }) end

------------------------------------ Plugins -----------------------------------
g.mapleader = ' '
g.maplocalleader = '\\'

require 'lazyconfig'

------------------------------------ Options -----------------------------------
o.laststatus = 3
o.showmode = false

o.clipboard = 'unnamedplus'
o.cursorline = true
o.cursorlineopt = 'number'

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

opt.fillchars = { eob = ' ' }
o.ignorecase = true
o.smartcase = true
o.mouse = 'a'

-- Numbers
o.number = true
o.relativenumber = true
o.numberwidth = 2
o.ruler = false

-- disable nvim intro
opt.shortmess:append 'sI'

o.signcolumn = 'yes'
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append '<>[]hl'

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
env.PATH = table.concat({ fn.stdpath 'data', 'mason', 'bin' }, sep) .. delim .. env.PATH

-- enable blinking cursor
opt.guicursor = 'n-v-c:block-blinkwait300-blinkon200-blinkoff150,i-ci:ver25-blinkwait300-blinkon200-blinkoff150'

------------------------------- UI + Highlighting ------------------------------
o.statusline = "%!v:lua.require('ui.statusline').open()"
statusline.autocmds()

require 'ui.tabufline.lazyload'
require 'ui.defaults'
require 'ui.git'
require 'ui.terminal'

--------------------------------- Auto-commands --------------------------------
-- user event that loads after UIEnter + only if file buf is there
create_autocmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
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
create_autocmd('BufWinLeave', {
	pattern = { '*.*' },
	desc = 'save view (folds), when closing file',
	command = 'mkview',
})

create_autocmd('BufWinEnter', {
	pattern = { '*.*' },
	desc = 'load view (folds), when opening file',
	command = 'silent! loadview',
})

-- Toggle Dashboard
create_usercmd('Dashboard', function()
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

	create_usercmd('MasonInstallAll', function() mason.install_all() end, {})

	colorify.run()
end)

---------------------------------- Key Mappings ---------------------------------
vim.schedule(function()
	map('n', ';', ':', 'CMD enter command mode')

	map('n', '<Esc>', '<cmd>noh<CR>', 'general clear highlights')
	map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>', 'general save file')
	map('n', '<C-c>', '<cmd>%y+<CR>', 'general copy whole file')

	map('n', '<leader>n', '<cmd>set nu!<CR>', 'toggle line number')
	map('n', '<leader>rn', '<cmd>set rnu!<CR>', 'toggle relative number')
	map('n', '<leader>/', 'gcc', 'toggle comment', true)
	map('v', '<leader>/', 'gc', 'toggle comment', true)

	-- obsession
	map('n', '<leader>ob', '<cmd>Obsession<CR>', 'Toggle Obsession session')
	map('n', '<leader>oo', function()
		vim.cmd 'silent! Obsession'
		vim.cmd 'silent! Obsession'
		vim.notify('Restarting session in Session.vim', vim.log.levels.INFO)
	end, 'Restart Obsession session')

	-- tabufline
	map('n', '<leader>b', '<cmd>enew<CR>', 'buffer new')
	map('n', '<tab>', tabufline.next, 'Buffer goto next')
	map('n', '<S-tab>', tabufline.prev, 'Buffer goto prev')
	map('n', '<leader>x', tabufline.close_buffer, 'Buffer close')

	-- nvimtree
	map('n', '<C-n>', '<cmd>NvimTreeToggle<CR><C-w>=', 'nvimtree toggle window')
	map('n', '<leader>e', '<cmd>NvimTreeFocus<CR>', 'nvimtree focus window')

	-- terminal
	map('t', '<C-x>', '<C-\\><C-N>', 'terminal escape terminal mode')

	map('n', '<leader>h', function() term.new { pos = 'sp' } end, 'terminal new horizontal term')
	map('n', '<leader>v', function() term.new { pos = 'vsp' } end, 'terminal new vertical term')

	map({ 'n', 't' }, '<A-v>', function() term.toggle { pos = 'vsp', id = 'vtoggleTerm' } end, 'terminal toggleable vertical term')
	map({ 'n', 't' }, '<A-h>', function() term.toggle { pos = 'sp', id = 'htoggleTerm' } end, 'terminal toggleable horizontal term')
	map({ 'n', 't' }, '<A-i>', function() term.toggle { pos = 'float', id = 'floatTerm' } end, 'terminal toggle floating term')

	-- telescope
	map('n', '<leader>cm', '<cmd>Telescope git_commits<CR>', 'telescope git commits')
	map('n', '<leader>fa', '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>', 'telescope find all files')
	map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', 'telescope find buffers')
	map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', 'telescope find files')
	map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', 'telescope help page')
	map('n', '<leader>fo', '<cmd>Telescope oldfiles<CR>', 'telescope find oldfiles')
	map('n', '<leader>fw', '<cmd>Telescope live_grep<CR>', 'telescope live grep')
	map('n', '<leader>fz', '<cmd>Telescope current_buffer_fuzzy_find<CR>', 'telescope find in current buffer')
	map('n', '<leader>gt', '<cmd>Telescope git_status<CR>', 'telescope git status')
	map('n', '<leader>ma', '<cmd>Telescope marks<CR>', 'telescope find marks')
	map('n', '<leader>pt', '<cmd>Telescope terms<CR>', 'telescope pick hidden term')

	-- insert mode
	map('i', '<C-b>', '<ESC>^i', 'move beginning of line')
	map('i', '<C-e>', '<End>', 'move end of line')
	map('i', '<C-h>', '<Left>', 'move left')
	map('i', '<C-l>', '<Right>', 'move right')
	map('i', '<C-j>', '<Down>', 'move down')
	map('i', '<C-k>', '<Up>', 'move up')

	-- global lsp mappings
	map('n', '<leader>ds', vim.diagnostic.setloclist, 'LSP diagnostic loclist')

	-- whichkey
	map('n', '<leader>wK', '<cmd>WhichKey <CR>', 'whichkey all keymaps')
	map('n', '<leader>wk', function() vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ') end, 'whichkey query lookup')

	-- showkey
	map('n', '<leader>sk', '<cmd>ShowkeysToggle<CR>', 'Toggle Showkeys')

	-- conform
	map('n', '<leader>fm', function() require('conform').format { lsp_fallback = true } end, 'general format file')

	-- multi-file refactoring
	map('n', '<leader>mr', function()
		-- Step 1: Open Telescope live_grep
		vim.cmd 'Telescope live_grep'

		-- Step 2: After live_grep, send results to quickfix list (manual <C-q>)
		print 'After entering your search term, press <C-q> in Telescope to send results to the quickfix list.'

		-- Step 3: Perform refactor when results are in the quickfix list
		vim.schedule(function()
			local search = vim.fn.input 'Search pattern: '
			local replace = vim.fn.input 'Replace with: '

			if search == '' or replace == '' then
				print 'Search and replace patterns cannot be empty!'
				return
			end

			-- Use cfdo to perform the substitution
			local command = string.format(':cfdo %%s/%s/%s/g | update', search, replace)
			vim.cmd(command)

			-- Close the quickfix list
			vim.cmd ':cclose'
			print 'Refactor complete!'
		end)
	end, 'Multi-file Refactor')
end)
