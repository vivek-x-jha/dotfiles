local icn = require 'icons'
local M = {}
local utl = {}

---Format plugin statistics from lazy.nvim
---@return string -- "  Loaded 20/30 plugins in 50ms"
local plugin_stats = function()
  local stats = require('lazy').stats()
  return table.concat { '  Loaded ', stats.loaded, '/', stats.count, ' plugins in ', math.floor(stats.startuptime), 'ms' }
end

---Create an fzf-lua command string
---@param cmd string  -- the fzf-lua method name (e.g., "files", "buffers")
---@return string -- a Lua command string to run
local fzf = function(cmd) return table.concat { 'lua require("fzf-lua").', cmd, '()' } end

local header = {
  '                                                       ',
  ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
  ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
  ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
  ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
  ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
  ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
  '                                                       ',
  '                  󰛩  Time to Build! 󰛩                  ',
  '                                                       ',
}

local buttons = {
  { txt = '─', hl = 'DashLine', no_gap = true, rep = true },
  -- { txt = plugin_stats(), hl = 'DashPlugins', no_gap = true },
  { txt = '─', hl = 'DashLine', no_gap = true, rep = true },
  { txt = icn.search .. '  Files', hl = 'DashFiles', keys = 'ff', cmd = fzf 'files' },
  { txt = icn.recent .. '  Recent Files', hl = 'DashRecent', keys = 'fo', cmd = fzf 'oldfiles' },
  { txt = icn.warn .. '  Event Triggers', hl = 'DashTrigger', keys = 'fa', cmd = fzf 'autocmds' },
  { txt = icn.gear .. '  Settings', hl = 'DashSettings', keys = 's', cmd = table.concat { 'edit ', vim.fn.stdpath 'config', '/init.lua' } },
  { txt = icn.fuzzy .. '  Search Word', hl = 'DashWord', keys = 'fw', cmd = fzf 'live_grep' },
  { txt = icn.cmd_hist .. '  Command History', hl = 'DashCmdHist', keys = 'fc', cmd = fzf 'command_history' },
  { txt = icn.file .. '  Buffers', hl = 'DashBuffers', keys = 'fb', cmd = fzf 'buffers' },
  { txt = icn.vim .. '  Neovim Commands', hl = 'DashNvimCmds', keys = 'fn', cmd = fzf 'commands' },
  { txt = icn.git .. '  Git Files', hl = 'DashGitFiles', keys = 'fg', cmd = fzf 'git_files' },
  { txt = icn.log .. '  Git Log', hl = 'DashGitLog', keys = 'glg', cmd = fzf 'git_commits' },
  { txt = icn.status .. '  Git Status', hl = 'DashGitStatus', keys = 'gst', cmd = fzf 'git_status' },
  { txt = icn.branch .. '  Git Switch', hl = 'DashGitSwitch', keys = 'gsw', cmd = fzf 'git_branches' },
}

utl.remap = function(keys, action, buf)
  for _, val in ipairs(keys) do
    vim.keymap.set('n', val, action, { buffer = buf })
  end
end

utl.txt_pad = function(str, max_str_w)
  local av = math.floor((max_str_w - vim.api.nvim_strwidth(str)) / 2)
  local spacing = string.rep(' ', av)

  return spacing .. str .. spacing
end

utl.btn_gap = function(txt1, txt2, max_str_w)
  local nonbuttonlength = max_str_w - vim.api.nvim_strwidth(txt1) - #txt2
  local spacing = string.rep(' ', nonbuttonlength)

  return txt1 .. spacing .. txt2
end

M.setup = function(buf, win, action)
  buf = buf or vim.api.nvim_create_buf(false, true)
  win = win or vim.api.nvim_get_current_win()
  action = action or 'open'

  local ns = vim.api.nvim_create_namespace 'dashboard'
  local winh = vim.api.nvim_win_get_height(win)
  local winw = vim.api.nvim_win_get_width(win)

  vim.g.dashboard_buf = buf
  vim.g.dashboard_win = win

  local dashboard_w = 0

  if action == 'open' then vim.api.nvim_win_set_buf(0, buf) end

  ------------------------ find largest string's width -----------------------------
  for _, val in ipairs(header) do
    local headerw = vim.api.nvim_strwidth(val)
    if headerw > dashboard_w then dashboard_w = headerw end
  end

  if #buttons[1] == 3 then
    vim.schedule(function() vim.notify 'nvdash buttons: each item must have a txt, and cmd' end)
    return
  end

  for _, val in ipairs(buttons) do
    local str = type(val.txt) == 'string' and val.txt or val.txt()
    str = val.keys and str .. val.keys or str
    local w = vim.api.nvim_strwidth(str)

    if dashboard_w < w then dashboard_w = w end

    if val.keys then utl.remap({ val.keys }, '<cmd>' .. val.cmd .. '<cr>', buf) end
  end
  ----------------------- save display txt -----------------------------------------
  local dashboard = {}

  for _, line in ipairs(header) do
    table.insert(dashboard, { txt = utl.txt_pad(line, dashboard_w), hl = 'DashAscii' })
  end

  for _, item in ipairs(buttons) do
    local txt

    if not item.keys then
      local str = type(item.txt) == 'string' and item.txt or item.txt()
      txt = item.rep and string.rep(str, dashboard_w) or utl.txt_pad(str, dashboard_w)
    else
      txt = utl.btn_gap(item.txt, item.keys, dashboard_w)
    end

    table.insert(dashboard, { txt = txt, hl = item.hl, cmd = item.cmd })

    if not item.no_gap then table.insert(dashboard, { txt = string.rep(' ', dashboard_w) }) end
  end

  -- if screen height is small
  if #dashboard > winh then winh = #dashboard + 10 end

  local row_i = math.floor((winh / 2) - (#dashboard / 2))
  local col_i = math.floor((winw / 2) - math.floor(dashboard_w / 2)) - 6 -- (5 is textoff)

  -- make all lines available
  local empty_str = {}

  for i = 1, winh do
    empty_str[i] = string.rep('', winw)
  end

  -- set text + highlight
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, empty_str)
  local key_lines = {}

  for i, item in ipairs(dashboard) do
    item.txt = '  ' .. item.txt .. '  '
    local opt = { virt_text_win_col = col_i, virt_text = { { item.txt, item.hl } } }
    vim.api.nvim_buf_set_extmark(buf, ns, row_i + i, 0, opt)

    if item.cmd then table.insert(key_lines, { i = row_i + i + 1, cmd = item.cmd }) end
  end

  ------------------------------------ keybinds ------------------------------------------
  vim.wo[win].virtualedit = 'all'
  local btn_start_i = row_i + #header + 2
  vim.api.nvim_win_set_cursor(win, { btn_start_i, col_i + 5 })

  utl.remap({ 'k', '<up>' }, function()
    local cur = vim.fn.line '.'
    local target_line = cur == key_lines[1].i and key_lines[#key_lines].i or cur - 2
    vim.api.nvim_win_set_cursor(win, { target_line, col_i + 5 })
  end, buf)

  utl.remap({ 'j', '<down>' }, function()
    local cur = vim.fn.line '.'
    local target_line = cur == key_lines[#key_lines].i and key_lines[1].i or cur + 2
    vim.api.nvim_win_set_cursor(win, { target_line, col_i + 5 })
  end, buf)

  utl.remap({ '<cr>' }, function()
    local key = vim.tbl_filter(function(item) return item.i == vim.fn.line '.' end, key_lines)

    if key[1] and key[1].cmd then vim.cmd(key[1].cmd) end
  end, buf)

  ------------------------------ clean buffer options ------------------------------------
  local opt_local = {
    { 'buflisted', false, { scope = 'local' } },
    { 'modifiable', false, { scope = 'local' } },
    { 'buftype', 'nofile', { buf = buf } },
    { 'number', false, { scope = 'local' } },
    { 'list', false, { scope = 'local' } },
    { 'wrap', false, { scope = 'local' } },
    { 'relativenumber', false, { scope = 'local' } },
    { 'cursorline', false, { scope = 'local' } },
    { 'colorcolumn', '0', { scope = 'local' } },
    { 'foldcolumn', '0', { scope = 'local' } },
    { 'ft', 'dashboard', { buf = buf } },
  }

  for _, optl in ipairs(opt_local) do
    vim.api.nvim_set_option_value(optl[1], optl[2], optl[3])
  end

  vim.g['dashboard_displayed'] = true

  if action == 'redraw' then return end

  ----------------------- autocmds -----------------------------
  local group_id = vim.api.nvim_create_augroup('NvdashAu', { clear = true })

  vim.api.nvim_create_autocmd('BufWinLeave', {
    group = group_id,
    buffer = buf,
    callback = function()
      vim.g.dashboard_displayed = false
      vim.api.nvim_del_augroup_by_name 'NvdashAu'
    end,
  })

  vim.api.nvim_create_autocmd({ 'WinResized', 'VimResized' }, {
    group = group_id,
    callback = function()
      vim.bo[vim.g.dashboard_buf].ma = true
      require('ui.dashboard').setup(vim.g.dashboard_buf, vim.g.dashboard_win, 'redraw')
    end,
  })
end

return M
