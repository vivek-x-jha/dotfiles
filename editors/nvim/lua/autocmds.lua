-- [1/13] Auto-open nvim-tree on startup when editing real buffers
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Open nvim-tree when Neovim starts with a real buffer',
  group = vim.api.nvim_create_augroup('TreeOpenAU', {}),
  callback = function()
    local emptylines = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == ''
    local emptyrows = vim.api.nvim_buf_line_count(0) == 1
    local untitled = vim.api.nvim_buf_get_name(0) == ''

    -- Blank startup is owned by the dashboard; do not open nvim-tree beside it.
    if emptylines and emptyrows and untitled then return end

    local ok_api, api = pcall(require, 'nvim-tree.api')
    local ok_view, view = pcall(require, 'nvim-tree.view')
    if not ok_api or not ok_view then return end

    vim.schedule(function()
      if vim.g.dashboard_displayed then return end
      api.tree.open()
      api.tree.reload()
      if view.get_winnr() ~= nil then vim.cmd 'wincmd p' end
    end)
  end,
})

-- [2/13] Auto-refresh NvimTree on relevant events
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufDelete', 'BufReadPost', 'VimResized', 'FocusGained', 'ShellCmdPost', 'FileChangedShellPost' }, {
  desc = 'Auto-refresh Nvim-Tree on file, Git, and resize events',
  group = vim.api.nvim_create_augroup('TreeAU', {}),
  pattern = '*',
  callback = function(args)
    local ok, api = pcall(require, 'nvim-tree.api')
    if not ok then return end

    -- Skip special buffers that are being deleted (e.g. nvim-pack://*) to avoid E937
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })
    if buftype ~= '' then return end

    local name = vim.api.nvim_buf_get_name(args.buf)
    if name == '' or name:match '^nvim%-pack://' then return end

    vim.schedule(function() api.tree.reload() end)
  end,
})

-- [3/13] Display Dashboard on blank startup
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Display Dashboard on blank startup',
  group = vim.api.nvim_create_augroup('DashAU', {}),
  callback = function()
    --- @type boolean  -- true if the first (and only) line is empty
    local emptylines = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == ''

    --- @type boolean  -- true if the buffer has exactly one line
    local emptyrows = vim.api.nvim_buf_line_count(0) == 1

    --- @type boolean  -- true if buffer has no name (unsaved/unnamed)
    local untitled = vim.api.nvim_buf_get_name(0) == ''

    if emptylines and emptyrows and untitled then
      --- @type boolean, { setup: fun(): nil }
      local ok, dashboard = pcall(require, 'ui.dashboard')
      if ok then dashboard.setup() end
    end
  end,
})

local hide_dashboard_chrome = function(buf)
  if not buf or not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= 'dashboard' then return end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    pcall(vim.api.nvim_set_option_value, 'number', false, { win = win })
    pcall(vim.api.nvim_set_option_value, 'relativenumber', false, { win = win })
    pcall(vim.api.nvim_set_option_value, 'signcolumn', 'no', { win = win })
    pcall(vim.api.nvim_set_option_value, 'statuscolumn', '', { win = win })
    pcall(vim.api.nvim_set_option_value, 'list', false, { win = win })
    pcall(vim.api.nvim_set_option_value, 'wrap', false, { win = win })
    pcall(vim.api.nvim_set_option_value, 'cursorline', false, { win = win })
    pcall(vim.api.nvim_set_option_value, 'colorcolumn', '0', { win = win })
    pcall(vim.api.nvim_set_option_value, 'foldcolumn', '0', { win = win })
    pcall(vim.api.nvim__redraw, { win = win, valid = false })
  end
end

vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter', 'WinEnter' }, {
  desc = 'Keep dashboard chrome hidden',
  group = vim.api.nvim_create_augroup('DashboardChromeAU', {}),
  callback = function(args)
    hide_dashboard_chrome(args.buf)
    vim.schedule(function() hide_dashboard_chrome(args.buf) end)
  end,
})

-- [4/13] Redraw dashboard on resize
vim.api.nvim_create_autocmd({ 'WinResized', 'VimResized' }, {
  desc = 'Redraw dashboard when Neovim resizes',
  group = vim.api.nvim_create_augroup('DashboardResizeAU', {}),
  callback = function()
    if
      vim.g.dashboard_displayed
      and vim.g.dashboard_buf
      and vim.g.dashboard_win
      and vim.api.nvim_buf_is_valid(vim.g.dashboard_buf)
      and vim.api.nvim_win_is_valid(vim.g.dashboard_win)
    then
      vim.bo[vim.g.dashboard_buf].ma = true
      require('ui.dashboard').setup(vim.g.dashboard_buf, vim.g.dashboard_win, 'redraw')
    end
  end,
})

-- [5/13] Exclude quickfix buffers from buffer list
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Prevents quickfix buffers from appearing in buffer lists',
  group = vim.api.nvim_create_augroup('BufferAU', {}),
  pattern = 'qf',
  callback = function() vim.opt_local.buflisted = false end,
})

-- [6/13] Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('YankAU', {}),
  callback = function() vim.highlight.on_yank { higroup = 'YankFlash', timeout = 200 } end,
})

-- [7/13] Fire a custom "User FilePost" once we have a real file buffer and the UI is ready
vim.api.nvim_create_autocmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
  desc = 'Wait to load user events on non-empty buffers',
  group = vim.api.nvim_create_augroup('FilePostAU', {}),
  callback = function(args)
    ---@type string  -- Full buffer path ('' if none)
    local file = vim.api.nvim_buf_get_name(args.buf)

    ---@type string  -- Buffer type: '', 'nofile', 'acwrite', etc.
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })

    -- Mark that the UI has fully entered (only on first UIEnter)
    if not vim.g.ui_entered and args.event == 'UIEnter' then vim.g.ui_entered = true end

    -- Only proceed for a real file buffer after UI is ready
    if file ~= '' and buftype ~= 'nofile' and vim.g.ui_entered then
      -- Fire a one-time user event for downstream listeners
      vim.api.nvim_exec_autocmds('User', { pattern = 'FilePost', modeline = false })
      vim.api.nvim_del_augroup_by_name 'FilePostAU'

      -- Re-run FileType autocommands - defer followups to avoid race/order issues
      vim.schedule(function() vim.api.nvim_exec_autocmds('FileType', {}) end)
    end
  end,
})

-- [8/13] Window-local highlight remaps for vim.pack update/confirm buffer
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Scope Diagnostic/Diff highlight links to only the nvim-pack window',
  group = vim.api.nvim_create_augroup('PackHighlightsAU', {}),
  pattern = 'nvim-pack',
  callback = function()
    ---@type table<string, string>
    local highlights = {
      DiagnosticHint = 'St_GitBranch',
      DiagnosticInfo = 'St_cwd',
      DiagnosticWarn = 'St_GitChanged',
      DiagnosticError = 'St_GitConflicted',
      Added = 'St_GitUntracked',
    }

    ---@type string[] -- Build winhl string: "Old:New,Old:New,..."
    local parts = {}

    for old_hl, new_hl in pairs(highlights) do
      parts[#parts + 1] = old_hl .. ':' .. new_hl
    end

    -- Apply only to this window
    vim.api.nvim_set_option_value('winhl', table.concat(parts, ','), { scope = 'local', win = 0 })
  end,
})

-- [9/13] Git config niceties
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'Treat repo Git config fragments as gitconfig filetype',
  group = vim.api.nvim_create_augroup('GitConfigFtAU', {}),
  pattern = { '*/git/config', '*/git/themes/*' },
  callback = function() vim.bo.filetype = 'gitconfig' end,
})

-- [10/13] SSH config highlighting
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'Treat ssh/config as sshconfig filetype',
  group = vim.api.nvim_create_augroup('SshConfigFtAU', {}),
  pattern = { '*/ssh/config', '*/ssh/config-*', '*/ssh/config.*', '*/ssh/identities/*' },
  callback = function() vim.bo.filetype = 'sshconfig' end,
})

-- [11/13] btop theme highlighting (treat as ini)
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'Treat btop *.theme as dosini',
  group = vim.api.nvim_create_augroup('BtopThemeFtAU', {}),
  pattern = '*/btop/themes/*.theme',
  callback = function() vim.bo.filetype = 'conf' end,
})

-- [12/13] Shared shell config highlighting (treat as zsh)
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'Treat shared shell config files as zsh filetype',
  group = vim.api.nvim_create_augroup('ShellConfigFtAU', {}),
  pattern = { '*/shells/env', '*/shells/profile', '*/shells/aliases', '*/shells/colors/*' },
  callback = function() vim.bo.filetype = 'zsh' end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'Treat fzf config as bash filetype',
  group = vim.api.nvim_create_augroup('FzfConfigFtAU', {}),
  pattern = '*/fzf/config',
  callback = function() vim.bo.filetype = 'bash' end,
})

-- [13/13] Keep Session.vim aligned with edit-all file membership
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufDelete', 'ShellCmdPost' }, {
  desc = 'Refresh workspace buffers and Session.vim after file membership changes',
  group = vim.api.nvim_create_augroup('WorkspaceSessionAU', {}),
  pattern = '*',
  callback = function() require('workspace').schedule_session_sync() end,
})
