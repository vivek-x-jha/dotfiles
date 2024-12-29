local api = vim.api
local g = vim.g
local lsp = vim.lsp
local wo = vim.wo

local utl = require 'configs.utils'

---------------------------- Initialization ----------------------------------

utl.create_autocmd {
  event = 'VimEnter',
  group = utl.create_augroup 'DashAU',
  desc = 'Display Dashboard on blank startup',
  callback = function()
    local buf_lines = api.nvim_buf_get_lines(0, 0, 1, false)
    local buf_empty = buf_lines[1] == '' and api.nvim_buf_line_count(0) == 1 and api.nvim_buf_get_name(0) == ''

    if buf_empty then vim.cmd 'Dashboard' end
  end,
}

utl.create_autocmd {
  event = 'VimEnter',
  group = utl.create_augroup 'ShowkeysAU',
  desc = 'Initialize Showkeys on startup',
  callback = function() vim.cmd 'ShowkeysToggle' end,
}

---------------------------- UI Preparation ----------------------------------

utl.create_autocmd {
  event = 'TextYankPost',
  group = utl.create_augroup 'YankAU',
  desc = 'Highlight when yanking (copying) text',
  callback = function() vim.highlight.on_yank { higroup = 'YankFlash', timeout = 200 } end,
}

utl.create_autocmd {
  event = 'FileType',
  group = utl.create_augroup 'SpectreAU',
  pattern = 'spectre_panel',
  desc = 'Hide line numbers for Spectre',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
}

utl.create_autocmd {
  event = 'BufWinEnter',
  group = utl.create_augroup { 'FoldsAU', false },
  pattern = { '*.*' },
  desc = 'Load folds when opening file',
  command = 'silent! loadview',
}

utl.create_autocmd {
  event = 'BufWinLeave',
  group = utl.create_augroup { 'FoldsAU', false },
  pattern = { '*.*' },
  desc = 'Save folds when closing file',
  command = 'mkview',
}

utl.create_autocmd {
  event = 'TermOpen',
  group = utl.create_augroup { 'TermAU', false },
  desc = 'Disable cursorline in terminal buffers',
  callback = function() wo.cursorline = false end,
}

utl.create_autocmd {
  event = 'TermLeave',
  group = utl.create_augroup { 'TermAU', false },
  desc = 'Re-enable cursorline after leaving terminal buffers',
  callback = function() wo.cursorline = true end,
}

utl.create_autocmd {
  event = 'TermClose',
  group = utl.create_augroup { 'TermAU', false },
  desc = 'Save terminal state on close',
  callback = function(args) require('ui.terminal').save(args.buf, nil) end,
}

utl.create_autocmd {
  event = {
    'BufWritePost',
    'BufDelete',
    'BufReadPost',
    'VimResized',
    'FocusGained',
    'ShellCmdPost',
    'FileChangedShellPost',
  },
  group = utl.create_augroup 'TreeAU',
  pattern = '*',
  desc = 'Auto-refresh Nvim-Tree on file, Git, and resize events',
  callback = function()
    local nvt = require('nvim-tree.api').tree
    if nvt.is_visible() then nvt.reload() end
  end,
}

-- Load LSP Progress bar
require('ui.statusline').autocmds()

---------------------------- Deferred ----------------------------------

utl.create_autocmd {
  event = {
    'UIEnter',
    'BufReadPost',
    'BufNewFile',
  },
  group = utl.create_augroup 'FilePostAU',
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
}

vim.schedule(function()
  utl.create_autocmd {
    event = {
      'TextChanged',
      'TextChangedI',
      'TextChangedP',
      'VimResized',
      'LspAttach',
      'WinScrolled',
      'BufEnter',
    },
    group = utl.create_augroup 'ColorifyAU',
    desc = 'Initialize Colorify Virtual Text',
    callback = function(args)
      local state = require 'ui.state'
      state.ns = api.nvim_create_namespace 'Colorify'

      if vim.bo[args.buf].bl then require('ui.colorify').attach(args.buf, args.event) end
    end,
  }

  utl.create_autocmd {
    event = 'LspAttach',
    group = utl.create_augroup 'LspAttachAU',
    desc = 'Initialize LSP config',
    callback = function(args)
      local client = lsp.get_client_by_id(args.data.client_id)

      if client then
        local signatureProvider = client.server_capabilities.signatureHelpProvider

        if signatureProvider and signatureProvider.triggerCharacters then
          local lsp_sig_au = utl.create_augroup { 'LspSignatureAU', false }
          local triggerChars = client.server_capabilities.signatureHelpProvider.triggerCharacters or {}

          lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, {
            border = 'rounded',
            focusable = false,
            silent = true,
            max_height = 7,
          })

          api.nvim_clear_autocmds { group = lsp_sig_au, buffer = args.buf }

          api.nvim_create_autocmd('TextChangedI', {
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
          })
        end
      end
    end,
  }
end)
