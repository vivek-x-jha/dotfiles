local api = vim.api
local fn = vim.fn
local g = vim.g
local utils = require 'ui.tabufline.utils'
local txt = utils.txt
local btn = utils.btn
local style_buf = utils.style_buf
local cur_buf = api.nvim_get_current_buf
local config = {
	enabled = true,
	lazyload = true,
	order = { 'treeOffset', 'buffers', 'tabs', 'btns' },
	modules = nil,
}

g.toggle_theme_icon = '   '

local b16 = require 'ui.base16'

require('ui.utils').highlight {
	-- Buffers
	TbFill = { bg = 'NONE' },

	TbBufOn = { fg = b16.brightyellow, bg = 'NONE' },
	TbBufOff = { fg = b16.brightblack, bg = 'NONE' },

	TbBufOnClose = { fg = b16.white, bg = 'NONE' },
	TbBufOffClose = { fg = b16.brightblack, bg = 'NONE' },

	TbBufOnModified = { fg = b16.brightred, bg = 'NONE' },
	TbBufOffModified = { fg = b16.red, bg = 'NONE' },

	-- Tabs
	TbTabOn = { fg = b16.red, bg = 'NONE' },
	TbTabOff = { fg = b16.white, bg = 'NONE' },

	TbTabNewBtn = { fg = b16.white, bg = 'NONE' },
	TbTabCloseBtn = { fg = b16.black, bg = 'NONE' },
	TBTabTitle = { fg = b16.black, bg = 'NONE' },

	-- Other UI
	TbThemeToggleBtn = { fg = b16.white, bg = 'NONE' },
	TbCloseAllBufsBtn = { fg = b16.brightred, bg = 'NONE' },
}

---------------------------------------------------------- btn actions functions ----------------------------------------------

vim.cmd "function! TbGoToBuf(bufnr,b,c,d) \n execute 'b'..a:bufnr \n endfunction"

vim.cmd [[
   function! TbKillBuf(bufnr,b,c,d) 
        call luaeval('require("ui.tabufline").close_buffer(_A)', a:bufnr)
  endfunction]]

vim.cmd 'function! TbNewTab(a,b,c,d) \n tabnew \n endfunction'
vim.cmd "function! TbGotoTab(tabnr,b,c,d) \n execute a:tabnr ..'tabnext' \n endfunction"
vim.cmd "function! TbCloseAllBufs(a,b,c,d) \n lua require('ui.tabufline').closeAllBufs() \n endfunction"
-- vim.cmd "function! TbToggle_theme(a,b,c,d) \n lua require('base46').toggle_theme() \n endfunction"
vim.cmd 'function! TbToggleTabs(a,b,c,d) \n let g:TbTabsToggled = !g:TbTabsToggled | redrawtabline \n endfunction'

-------------------------------------------------------- functions ------------------------------------------------------------

local function getNvimTreeWidth()
	for _, win in pairs(api.nvim_tabpage_list_wins(0)) do
		if vim.bo[api.nvim_win_get_buf(win)].ft == 'NvimTree' then return api.nvim_win_get_width(win) + 1 end
	end
	return 0
end

------------------------------------- modules -----------------------------------------
local M = {}

local function available_space()
	local str = ''

	for _, key in ipairs(config.order) do
		if key ~= 'buffers' then str = str .. M[key]() end
	end

	local modules = api.nvim_eval_statusline(str, { use_tabline = true })
	return vim.o.columns - modules.width
end

M.treeOffset = function() return '%#NvimTreeNormal#' .. string.rep(' ', getNvimTreeWidth()) end

M.buffers = function()
	local buffers = {}
	local has_current = false -- have we seen current buffer yet?

	for i, nr in ipairs(vim.t.bufs) do
		if ((#buffers + 1) * 23) > available_space() then
			if has_current then break end

			table.remove(buffers, 1)
		end

		has_current = cur_buf() == nr or has_current
		table.insert(buffers, style_buf(nr, i))
	end

	return table.concat(buffers) .. txt('%=', 'Fill') -- buffers + empty space
end

g.TbTabsToggled = 0

M.tabs = function()
	local result, tabs = '', fn.tabpagenr '$'

	if tabs > 1 then
		for nr = 1, tabs, 1 do
			local tab_hl = 'TabO' .. (nr == fn.tabpagenr() and 'n' or 'ff')
			result = result .. btn(' ' .. nr .. ' ', tab_hl, 'GotoTab', nr)
		end

		local new_tabtn = btn(' 󰐕 ', 'TabNewBtn', 'NewTab')
		local tabstoggleBtn = btn(' TABS ', 'TabTitle', 'ToggleTabs')
		local small_btn = btn(' 󰅁 ', 'TabTitle', 'ToggleTabs')

		return g.TbTabsToggled == 1 and small_btn or new_tabtn .. tabstoggleBtn .. result
	end

	return ''
end

M.btns = function()
	local toggle_theme = btn(g.toggle_theme_icon, 'ThemeToggleBtn', 'Toggle_theme')
	local closeAllBufs = btn(' 󰅖 ', 'CloseAllBufsBtn', 'CloseAllBufs')
	return toggle_theme .. closeAllBufs
end

return function()
	local result = {}

	if config.modules then
		for key, value in pairs(config.modules) do
			M[key] = value
		end
	end

	for _, v in ipairs(config.order) do
		table.insert(result, M[v]())
	end

	return table.concat(result)
end
