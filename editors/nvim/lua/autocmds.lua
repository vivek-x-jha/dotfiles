local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- [1/15] Hide line numbers in Spectre
autocmd('FileType', {
  desc = 'Hide line numbers for Spectre',
  group = augroup('SpectreAU', {}),
  pattern = 'spectre_panel',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- [2/15] Always refresh snippet list with respect to buffer
autocmd('InsertLeave', {
  desc = 'Reset Snippet',
  group = augroup('LuaSnipAU', {}),
  callback = function()
    --- @type boolean, { session: { current_nodes: table<integer, any>, jump_active: boolean }, unlink_current: fun(): nil }
    local ok, ls = pcall(require, 'luasnip')
    if not ok then return end

    if ls.session.current_nodes[vim.api.nvim_get_current_buf()] and not ls.session.jump_active then ls.unlink_current() end
  end,
})

-- [3/15] Auto-refresh NvimTree on relevant events
autocmd({ 'BufWritePost', 'BufDelete', 'BufReadPost', 'VimResized', 'FocusGained', 'ShellCmdPost', 'FileChangedShellPost' }, {
  desc = 'Auto-refresh Nvim-Tree on file, Git, and resize events',
  group = augroup('TreeAU', {}),
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

-- [4/15] Display Dashboard on blank startup
autocmd('VimEnter', {
  desc = 'Display Dashboard on blank startup',
  group = augroup('DashAU', {}),
  callback = function()
    --- @type boolean  -- true if the first (and only) line is empty
    local emptylines = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == ''

    --- @type boolean  -- true if the buffer has exactly one line
    local emptyrows = vim.api.nvim_buf_line_count(0) == 1

    --- @type boolean  -- true if buffer has no name (unsaved/unnamed)
    local untitled = vim.api.nvim_buf_get_name(0) == ''

    if emptylines and emptyrows and untitled then
      --- @type boolean, { setup: fun(): nil }
      local ok, dashboard = pcall(require, 'nvim-dashboard')
      if ok then dashboard.setup() end
    end
  end,
})

-- [5/15] Exclude quickfix buffers from buffer list
autocmd('FileType', {
  desc = 'Prevents quickfix buffers from appearing in buffer lists',
  group = augroup('BufferAU', {}),
  pattern = 'qf',
  callback = function() vim.opt_local.buflisted = false end,
})

-- [6/15] Highlight on yank
autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup('YankAU', {}),
  callback = function() vim.highlight.on_yank { higroup = 'YankFlash', timeout = 200 } end,
})

-- [7/15] Load folds
autocmd('BufWinEnter', {
  desc = 'Load folds when opening file',
  group = augroup('FoldsAU', { clear = false }),
  pattern = { '*.*' },
  command = 'silent! loadview',
})

-- [8/15] Save folds
autocmd('BufWinLeave', {
  desc = 'Save folds when closing file',
  group = augroup('FoldsAU', { clear = false }),
  pattern = { '*.*' },
  command = 'mkview',
})

-- [9/15] Fire a custom "User FilePost" once we have a real file buffer and the UI is ready
autocmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
  desc = 'Wait to load user events on non-empty buffers',
  group = augroup('FilePostAU', {}),

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

-- [10/15] Window-local highlight remaps for vim.pack update/confirm buffer
autocmd('FileType', {
  desc = 'Scope Diagnostic/Diff highlight links to only the nvim-pack window',
  group = augroup('NvimPackHighlights', {}),
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

-- [11/16] Git config niceties
autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'Treat git/config as gitconfig filetype',
  group = augroup('GitConfigFt', {}),
  pattern = '*/git/config',
  callback = function() vim.bo.filetype = 'gitconfig' end,
})

-- [12/16] SSH config highlighting
autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'Treat ssh/config as sshconfig filetype',
  group = augroup('SshConfigFt', {}),
  pattern = '*/ssh/config',
  callback = function() vim.bo.filetype = 'sshconfig' end,
})

-- [13/16] btop theme highlighting (treat as ini)
autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'Treat btop *.theme as dosini',
  group = augroup('BtopThemeFt', {}),
  pattern = '*/btop/themes/*.theme',
  callback = function() vim.bo.filetype = 'conf' end,
})

-- [14/16] Shared shell env highlighting (treat as zsh)
autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'Treat shells/env as zsh filetype',
  group = augroup('ShellEnvFt', {}),
  pattern = '*/shells/env',
  callback = function() vim.bo.filetype = 'zsh' end,
})

-- [15/16] Auto-open nvim-tree on startup
autocmd('VimEnter', {
  desc = 'Open nvim-tree when Neovim starts',
  group = augroup('TreeAutoOpen', {}),
  callback = function()
    local ok_api, api = pcall(require, 'nvim-tree.api')
    local ok_view, view = pcall(require, 'nvim-tree.view')
    if not ok_api or not ok_view then return end

    vim.schedule(function()
      api.tree.open()
      api.tree.reload()
      if view.get_winnr() ~= nil then vim.cmd 'wincmd p' end
    end)
  end,
})

-- [16/16] Rebuild blink.cmp Rust fuzzy library after install/update
autocmd('PackChanged', {
  desc = 'Build blink.cmp fuzzy matcher with cargo after plugin updates',
  group = augroup('BlinkBuildAU', {}),
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if name ~= 'blink.cmp' or (kind ~= 'install' and kind ~= 'update') then return end

    vim.notify('Building blink.cmp (cargo build --release)...', vim.log.levels.INFO)
    vim.system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path, text = true }, function(out)
      if out.code == 0 then
        vim.schedule(function() vim.notify('blink.cmp build complete', vim.log.levels.INFO) end)
      else
        vim.schedule(
          function()
            vim.notify(
              'blink.cmp build failed: ' .. ((out.stderr and out.stderr ~= '') and out.stderr or ('exit code ' .. out.code)),
              vim.log.levels.ERROR
            )
          end
        )
      end
    end)
  end,
})
