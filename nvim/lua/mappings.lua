local diag = vim.diagnostic

local conform = require 'conform'
local colorschemes = require 'nvchad.themes'
local tabufline = require 'nvchad.tabufline'
local term = require 'nvchad.term'

local map = function(mode, lhs, rhs, desc, remap)
	vim.keymap.set(mode, lhs, rhs, { desc = desc, remap = remap or false })
end

--------------------------- user mapping functions ----------------------------

local fn = {
	restartSession = function()
		vim.cmd 'silent! Obsession'
		vim.cmd 'silent! Obsession'
		vim.notify('Restarting session in Session.vim', vim.log.levels.INFO)
	end,

	nextBuffer = function()
		tabufline.next()
	end,

	prevBuffer = function()
		tabufline.prev()
	end,

	closeBuffer = function()
		tabufline.close_buffer()
	end,

	hsplitTerm = function()
		term.new { pos = 'sp' }
	end,

	vsplitTerm = function()
		term.new { pos = 'vsp' }
	end,

	htoggleTerm = function()
		term.toggle { pos = 'sp', id = 'htoggleTerm' }
	end,

	vtoggleTerm = function()
		term.toggle { pos = 'vsp', id = 'vtoggleTerm' }
	end,

	floatTerm = function()
		term.toggle { pos = 'float', id = 'floatTerm' }
	end,

	switchTheme = function()
		colorschemes.open()
	end,

	queryWhichKey = function()
		vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ')
	end,

	generalFormat = function()
		conform.format { lsp_fallback = true }
	end,
}

--------------------------- general -------------------------------------------

map('n', ';', ':', 'CMD enter command mode')

map('n', '<Esc>', '<cmd>noh<CR>', 'general clear highlights')
map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>', 'general save file')
map('n', '<C-c>', '<cmd>%y+<CR>', 'general copy whole file')

map('n', '<leader>n', '<cmd>set nu!<CR>', 'toggle line number')
map('n', '<leader>rn', '<cmd>set rnu!<CR>', 'toggle relative number')
map('n', '<leader>/', 'gcc', 'toggle comment', true)
map('v', '<leader>/', 'gc', 'toggle comment', true)

--------------------------- workspace -----------------------------------------

-- obsession
map('n', '<leader>ob', '<cmd>Obsession<CR>', 'Toggle Obsession session')
map('n', '<leader>oo', fn.restartSession, 'Restart Obsession session')

-- tabufline
map('n', '<leader>b', '<cmd>enew<CR>', 'buffer new')
map('n', '<tab>', fn.nextBuffer, 'Buffer goto next')
map('n', '<S-tab>', fn.prevBuffer, 'Buffer goto prev')
map('n', '<leader>x', fn.closeBuffer, 'Buffer close')

-- nvimtree
map('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', 'nvimtree toggle window')
map('n', '<leader>e', '<cmd>NvimTreeFocus<CR>', 'nvimtree focus window')

-- terminal
map('t', '<C-x>', '<C-\\><C-N>', 'terminal escape terminal mode')

map('n', '<leader>h', fn.hsplitTerm, 'terminal new horizontal term')
map('n', '<leader>v', fn.vtoggleTerm, 'terminal new vertical term')

map({ 'n', 't' }, '<A-v>', fn.vtoggleTerm, 'terminal toggleable vertical term')
map({ 'n', 't' }, '<A-h>', fn.htoggleTerm, 'terminal toggleable horizontal term')
map({ 'n', 't' }, '<A-i>', fn.floatTerm, 'terminal toggle floating term')

--------------------------- search --------------------------------------------

-- telescope
map('n', '<leader>fw', '<cmd>Telescope live_grep<CR>', 'telescope live grep')
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', 'telescope find buffers')
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', 'telescope help page')
map('n', '<leader>ma', '<cmd>Telescope marks<CR>', 'telescope find marks')
map('n', '<leader>fo', '<cmd>Telescope oldfiles<CR>', 'telescope find oldfiles')
map('n', '<leader>fz', '<cmd>Telescope current_buffer_fuzzy_find<CR>', 'telescope find in current buffer')
map('n', '<leader>cm', '<cmd>Telescope git_commits<CR>', 'telescope git commits')
map('n', '<leader>gt', '<cmd>Telescope git_status<CR>', 'telescope git status')
map('n', '<leader>pt', '<cmd>Telescope terms<CR>', 'telescope pick hidden term')

map('n', '<leader>th', fn.switchTheme, 'telescope nvchad themes')

map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', 'telescope find files')
map('n', '<leader>fa', '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>', 'telescope find all files')

--------------------------- navigation ----------------------------------------

-- insert mode
map('i', '<C-b>', '<ESC>^i', 'move beginning of line')
map('i', '<C-e>', '<End>', 'move end of line')
map('i', '<C-h>', '<Left>', 'move left')
map('i', '<C-l>', '<Right>', 'move right')
map('i', '<C-j>', '<Down>', 'move down')
map('i', '<C-k>', '<Up>', 'move up')

--------------------------- lsp -----------------------------------------------

-- global lsp mappings
map('n', '<leader>ds', diag.setloclist, 'LSP diagnostic loclist')

--------------------------- keymeta -------------------------------------------

-- cheatsheet
map('n', '<leader>ch', '<cmd>NvCheatsheet<CR>', 'toggle nvcheatsheet')

-- whichkey
map('n', '<leader>wK', '<cmd>WhichKey <CR>', 'whichkey all keymaps')
map('n', '<leader>wk', fn.queryWhichKey, 'whichkey query lookup')

-- showkey
map('n', '<leader>sk', '<cmd>ShowkeysToggle<CR>', 'Toggle Showkeys')

--------------------------- format --------------------------------------------

-- conform
map('n', '<leader>fm', fn.generalFormat, 'general format file')
