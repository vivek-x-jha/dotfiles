local autocmd = vim.api.nvim_create_autocmd

-- [1/9] Hide line numbers in Spectre
autocmd('FileType', {
  desc = 'Hide line numbers for Spectre',
  group = vim.api.nvim_create_augroup('SpectreAU', {}),
  pattern = 'spectre_panel',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- [2/9] Always refresh snippet list with respect to buffer
autocmd('InsertLeave', {
  desc = 'Reset Snippet',
  group = vim.api.nvim_create_augroup('LuaSnipAU', {}),
  callback = function()
    ---@type { session: { current_nodes: table<integer, any>, jump_active: boolean }, unlink_current: fun(): nil }
    local ls = require 'luasnip'

    if ls.session.current_nodes[vim.api.nvim_get_current_buf()] and not ls.session.jump_active then ls.unlink_current() end
  end,
})

-- [3/9] Auto-refresh NvimTree on relevant events
autocmd({ 'BufWritePost', 'BufDelete', 'BufReadPost', 'VimResized', 'FocusGained', 'ShellCmdPost', 'FileChangedShellPost' }, {
  desc = 'Auto-refresh Nvim-Tree on file, Git, and resize events',
  group = vim.api.nvim_create_augroup('TreeAU', {}),
  pattern = '*',
  callback = function() require('nvim-tree.api').tree.reload() end,
})

-- [4/9] Display Dashboard on blank startup
autocmd('VimEnter', {
  desc = 'Display Dashboard on blank startup',
  group = vim.api.nvim_create_augroup('DashAU', {}),
  callback = function()
    --- @type boolean  -- true if the first (and only) line is empty
    local emptylines = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == ''

    --- @type boolean  -- true if the buffer has exactly one line
    local emptyrows = vim.api.nvim_buf_line_count(0) == 1

    --- @type boolean  -- true if buffer has no name (unsaved/unnamed)
    local untitled = vim.api.nvim_buf_get_name(0) == ''

    if emptylines and emptyrows and untitled then require('nvim-dashboard').setup() end
  end,
})

-- [5/9] Exclude quickfix buffers from buffer list
autocmd('FileType', {
  desc = 'Prevents quickfix buffers from appearing in buffer lists',
  group = vim.api.nvim_create_augroup('BufferAU', {}),
  pattern = 'qf',
  callback = function() vim.opt_local.buflisted = false end,
})

-- [6/9] Highlight on yank
autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('YankAU', {}),
  callback = function() vim.highlight.on_yank { higroup = 'YankFlash', timeout = 200 } end,
})

-- [7/9] Load folds
autocmd('BufWinEnter', {
  desc = 'Load folds when opening file',
  group = vim.api.nvim_create_augroup('FoldsAU', { clear = false }),
  pattern = { '*.*' },
  command = 'silent! loadview',
})

-- [8/9] Save folds
autocmd('BufWinLeave', {
  desc = 'Save folds when closing file',
  group = vim.api.nvim_create_augroup('FoldsAU', { clear = false }),
  pattern = { '*.*' },
  command = 'mkview',
})

-- [9/9] Fire a custom "User FilePost" once we have a real file buffer and the UI is ready
autocmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
  desc = 'Wait to load user events on non-empty buffers',
  group = vim.api.nvim_create_augroup('FilePostAU', { clear = true }),

  ---@param args AutocmdCallbackArgs
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
