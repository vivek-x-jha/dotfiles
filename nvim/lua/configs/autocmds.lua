--- @class M
local M = {}
local api = vim.api
local utl = require 'configs.utils'
local aucmd = utl.create_auto_command
local augroup = utl.create_auto_group

--- Auto commands to immediately prepare for execution
--- @type table[]
M.main_cmds = {
  {
    event = 'VimEnter',
    group = augroup 'DashAU',
    desc = 'Display Dashboard on blank startup',
    callback = function()
      local buf_lines = api.nvim_buf_get_lines(0, 0, 1, false)
      local buf_empty = buf_lines[1] == '' and api.nvim_buf_line_count(0) == 1 and api.nvim_buf_get_name(0) == ''

      if buf_empty then vim.cmd 'Dashboard' end
    end,
  },

  {
    event = 'VimEnter',
    group = augroup 'ShowkeysAU',
    desc = 'Initialize Showkeys on startup',
    callback = function() vim.cmd 'ShowkeysToggle' end,
  },

  {
    event = 'TextYankPost',
    group = augroup 'YankAU',
    desc = 'Highlight when yanking (copying) text',
    callback = function() vim.highlight.on_yank { higroup = 'YankFlash', timeout = 200 } end,
  },

  {
    event = 'FileType',
    group = augroup 'SpectreAU',
    pattern = 'spectre_panel',
    desc = 'Hide line numbers for Spectre',
    callback = function()
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
    end,
  },

  {
    event = 'BufWinEnter',
    group = augroup { 'FoldsAU', false },
    pattern = { '*.*' },
    desc = 'Load folds when opening file',
    command = 'silent! loadview',
  },

  {
    event = 'BufWinLeave',
    group = augroup { 'FoldsAU', false },
    pattern = { '*.*' },
    desc = 'Save folds when closing file',
    command = 'mkview',
  },

  {
    event = 'TermOpen',
    group = augroup { 'TermAU', false },
    desc = 'Disable cursorline in terminal buffers',
    callback = function() vim.wo.cursorline = false end,
  },

  {
    event = 'TermLeave',
    group = augroup { 'TermAU', false },
    desc = 'Re-enable cursorline after leaving terminal buffers',
    callback = function() vim.wo.cursorline = true end,
  },

  {
    event = 'TermClose',
    group = augroup { 'TermAU', false },
    desc = 'Save terminal state on close',
    callback = function(args) require('ui.terminal').save(args.buf, nil) end,
  },

  {
    event = {
      'BufWritePost',
      'BufDelete',
      'BufReadPost',
      'VimResized',
      'FocusGained',
      'ShellCmdPost',
      'FileChangedShellPost',
    },
    group = augroup 'TreeAU',
    pattern = '*',
    desc = 'Auto-refresh Nvim-Tree on file, Git, and resize events',
    callback = function()
      local nvt = require('nvim-tree.api').tree
      if nvt.is_visible() then nvt.reload() end
    end,
  },

  {
    event = {
      'UIEnter',
      'BufReadPost',
      'BufNewFile',
    },
    group = augroup 'FilePostAU',
    desc = 'Wait to load user events on non-empty buffers',
    callback = function(args)
      local g = vim.g
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
  },
}

--- Auto commands to schedule for execution
--- @type table[]
M.deferred_cmds = {
  {
    event = {
      'TextChanged',
      'TextChangedI',
      'TextChangedP',
      'VimResized',
      'LspAttach',
      'WinScrolled',
      'BufEnter',
    },
    group = augroup 'ColorifyAU',
    desc = 'Initialize Colorify Virtual Text',
    callback = function(args)
      local state = require 'ui.state'
      state.ns = api.nvim_create_namespace 'Colorify'

      if vim.bo[args.buf].bl then require('ui.colorify').attach(args.buf, args.event) end
    end,
  },

  {
    event = 'LspAttach',
    group = augroup 'LspAttachAU',
    desc = 'Initialize LSP config',
    callback = function(args)
      local lsp = vim.lsp
      --- @type vim.lsp.Client|nil LSP client object
      local client = lsp.get_client_by_id(args.data.client_id)

      if client then
        --- @type table|nil Signature provider details
        local signatureProvider = client.server_capabilities.signatureHelpProvider

        if signatureProvider and signatureProvider.triggerCharacters then
          local lsp_sig_au = augroup { 'LspSignatureAU', false }
          --- @type string[] Trigger characters
          local triggerChars = client.server_capabilities.signatureHelpProvider.triggerCharacters or {}

          lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, {
            border = 'rounded',
            focusable = false,
            silent = true,
            max_height = 7,
          })

          api.nvim_clear_autocmds { group = lsp_sig_au, buffer = args.buf }

          aucmd {
            event = 'TextChangedI',
            group = lsp_sig_au,
            buffer = args.buf,
            desc = 'Detects Trigger Characters on Insert',
            callback = function()
              local cur_line = api.nvim_get_current_line()
              local pos = api.nvim_win_get_cursor(0)[2]
              local prev_char = cur_line:sub(pos - 1, pos - 1)
              local cur_char = cur_line:sub(pos, pos)

              for _, char in ipairs(triggerChars) do
                if cur_char == char or prev_char == char then lsp.buf.signature_help() end
              end
            end,
          }
        end
      end
    end,
  },
}

return M
