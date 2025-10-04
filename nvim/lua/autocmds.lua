-- Enable git icons in editor gutter
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, { callback = function(args) require('gitsigns').attach(args.buf) end })

-- Hide line numbers in Spectre
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Hide line numbers for Spectre',
  group = vim.api.nvim_create_augroup('SpectreAU', {}),
  pattern = 'spectre_panel',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- Always refresh snippet list with respect to buffer
vim.api.nvim_create_autocmd('InsertLeave', {
  desc = 'Reset Snippet',
  group = vim.api.nvim_create_augroup('LuaSnipAU', {}),
  callback = function()
    local ls = require 'luasnip'

    if ls.session.current_nodes[vim.api.nvim_get_current_buf()] and not ls.session.jump_active then ls.unlink_current() end
  end,
})

-- Auto-refresh NvimTree on relevant events
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufDelete', 'BufReadPost', 'VimResized', 'FocusGained', 'ShellCmdPost', 'FileChangedShellPost' }, {
  desc = 'Auto-refresh Nvim-Tree on file, Git, and resize events',
  group = vim.api.nvim_create_augroup('TreeAU', {}),
  pattern = '*',
  callback = function()
    local nvt = require('nvim-tree.api').tree
    if nvt.is_visible() then nvt.reload() end
  end,
})

------------------------------------ Local Auto-commands ------------------------------------

-- Display Dashboard on blank startup
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

    if emptylines and emptyrows and untitled then require('nvim-dashboard').setup() end
  end,
})

-- Exclude quickfix buffers from buffer list
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Prevents quickfix buffers from appearing in buffer lists',
  group = vim.api.nvim_create_augroup('BufferAU', {}),
  pattern = 'qf',
  callback = function() vim.opt_local.buflisted = false end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('YankAU', {}),
  callback = function() vim.highlight.on_yank { higroup = 'YankFlash', timeout = 200 } end,
})

-- Load folds
vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Load folds when opening file',
  group = vim.api.nvim_create_augroup('FoldsAU', { clear = false }),
  pattern = { '*.*' },
  command = 'silent! loadview',
})

-- Save folds
vim.api.nvim_create_autocmd('BufWinLeave', {
  desc = 'Save folds when closing file',
  group = vim.api.nvim_create_augroup('FoldsAU', { clear = false }),
  pattern = { '*.*' },
  command = 'mkview',
})

-- Trigger user FilePost event
vim.api.nvim_create_autocmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
  desc = 'Wait to load user events on non-empty buffers',
  group = vim.api.nvim_create_augroup('FilePostAU', {}),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })

    if not vim.g.ui_entered and args.event == 'UIEnter' then vim.g.ui_entered = true end

    if file ~= '' and buftype ~= 'nofile' and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds('User', { pattern = 'FilePost', modeline = false })
      vim.api.nvim_del_augroup_by_name 'FilePostAU'

      vim.schedule(function()
        vim.api.nvim_exec_autocmds('FileType', {})
        if vim.g.editorconfig then require('editorconfig').config(args.buf) end
      end)
    end
  end,
})
