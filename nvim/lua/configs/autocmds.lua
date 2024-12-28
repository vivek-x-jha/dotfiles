local api = vim.api
local g = vim.g
local lsp = vim.lsp
local wo = vim.wo

local augroup = function(name, clear) return api.nvim_create_augroup(name, { clear = clear or true }) end

---------------------------- Initialization ----------------------------------

api.nvim_create_autocmd('VimEnter', {
  group = augroup 'DashAU',
  desc = 'Display Dashboard on blank startup',
  callback = function()
    local buf_lines = api.nvim_buf_get_lines(0, 0, 1, false)
    local no_buf_content = buf_lines[1] == '' and api.nvim_buf_line_count(0) == 1
    local empty_buf = no_buf_content and api.nvim_buf_get_name(0) == ''

    if empty_buf then vim.cmd 'Dashboard' end
  end,
})

api.nvim_create_autocmd('VimEnter', {
  group = augroup 'ShowkeysAU',
  desc = 'Initialize Showkeys on startup',
  callback = function() vim.cmd 'ShowkeysToggle' end,
})

---------------------------- UI Preparation ----------------------------------

api.nvim_create_autocmd('TextYankPost', {
  group = augroup 'YankAU',
  desc = 'Highlight when yanking (copying) text',
  callback = function() vim.highlight.on_yank { higroup = 'YankFlash', timeout = 200 } end,
})

api.nvim_create_autocmd('FileType', {
  group = augroup 'Spectre',
  pattern = 'spectre_panel',
  desc = 'Hide line numbers for Spectre',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

api.nvim_create_autocmd('BufWinEnter', {
  group = augroup('Folds', false),
  pattern = { '*.*' },
  desc = 'Load folds when opening file',
  command = 'silent! loadview',
})

api.nvim_create_autocmd('BufWinLeave', {
  group = augroup('FoldsAU', false),
  pattern = { '*.*' },
  desc = 'Save folds when closing file',
  command = 'mkview',
})

api.nvim_create_autocmd('TermOpen', {
  group = augroup('TerminalAU', false),
  desc = 'Disable cursorline in terminal buffers',
  callback = function() wo.cursorline = false end,
})

api.nvim_create_autocmd('TermLeave', {
  group = augroup('TerminalAU', false),
  desc = 'Re-enable cursorline after leaving terminal buffers',
  callback = function() wo.cursorline = true end,
})

api.nvim_create_autocmd('TermClose', {
  group = augroup('TerminalAU', false),
  desc = 'Save terminal state on close',
  callback = function(args) require('ui.terminal').save(args.buf, nil) end,
})

api.nvim_create_autocmd({
  'BufWritePost',
  'BufDelete',
  'BufReadPost',
  'VimResized',
  'FocusGained',
  'ShellCmdPost',
  'FileChangedShellPost',
}, {
  group = augroup 'TreeAU',
  pattern = '*',
  desc = 'Auto-refresh Nvim-Tree on file, Git, and resize events',
  callback = function()
    local nvt = require('nvim-tree.api').tree
    if nvt.is_visible() then nvt.reload() end
  end,
})

-- Load LSP Progress bar
require('ui.statusline').autocmds()

---------------------------- Deferred ----------------------------------

api.nvim_create_autocmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
  group = augroup 'FilePostAU',
  desc = 'Wait to load user events on non-empty buffers',
  callback = function(args)
    local file = api.nvim_buf_get_name(args.buf)
    local buftype = api.nvim_get_option_value('buftype', { buf = args.buf })

    if not g.ui_entered and args.event == 'UIEnter' then g.ui_entered = true end

    if file ~= '' and buftype ~= 'nofile' and g.ui_entered then
      api.nvim_exec_autocmds('User', { pattern = 'FilePost', modeline = false })
      api.nvim_del_augroup_by_name 'FilePostAU'

      vim.schedule(function()
        api.nvim_exec_autocmds('FileType', {})

        if g.editorconfig then require('editorconfig').config(args.buf) end
      end)
    end
  end,
})

vim.schedule(function()
  api.nvim_create_autocmd({
    'TextChanged',
    'TextChangedI',
    'TextChangedP',
    'VimResized',
    'LspAttach',
    'WinScrolled',
    'BufEnter',
  }, {
    group = augroup 'ColorifyAU',
    desc = 'Initialize Colorify Virtual Text',
    callback = function(args)
      local state = require 'ui.state'
      state.ns = api.nvim_create_namespace 'Colorify'

      if vim.bo[args.buf].bl then require('ui.colorify').attach(args.buf, args.event) end
    end,
  })

  api.nvim_create_autocmd('LspAttach', {
    group = augroup 'LspAttachAU',
    desc = 'Initialize LSP config',
    callback = function(args)
      local client = lsp.get_client_by_id(args.data.client_id)

      if client then
        local signatureProvider = client.server_capabilities.signatureHelpProvider

        if signatureProvider and signatureProvider.triggerCharacters then
          local lsp_sig_au = augroup('LspSignatureAU', false)
          local triggerChars = client.server_capabilities.signatureHelpProvider.triggerCharacters

          lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, {
            border = 'rounded',
            focusable = false,
            silent = true,
            max_height = 7,
          })

          api.nvim_clear_autocmds { group = lsp_sig_au, buffer = args.buf }

          api.nvim_create_autocmd('TextChangedI', {
            group = lsp_sig_au,
            desc = 'Detects Trigger Characters on Insert',
            buffer = args.buf,
            callback = function()
              local cur_line = api.nvim_get_current_line()
              local pos = api.nvim_win_get_cursor(0)[2]
              local prev_char = cur_line:sub(pos - 1, pos - 1)
              local cur_char = cur_line:sub(pos, pos)

              for _, char in ipairs(triggerChars) do
                if cur_char == char or prev_char == char then lsp.buf.signature_help() end
              end
            end,
          })
        end
      end
    end,
  })
end)
