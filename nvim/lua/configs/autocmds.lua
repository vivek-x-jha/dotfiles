local aucmds = {
  -- -- Showkeys
  -- {
  --   'VimEnter',
  --   {
  --     desc = 'Initialize Showkeys on startup',
  --     group = vim.api.nvim_create_augroup('ShowkeysAU', {}),
  --     callback = function() vim.cmd 'ShowkeysToggle' end,
  --   },
  -- },

  -- Display Dashboard on blank startup
  {
    'VimEnter',
    {
      desc = 'Display Dashboard on blank startup',
      group = vim.api.nvim_create_augroup('DashAU', {}),
      callback = function()
        local emptylines = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == ''
        local emptyrows = vim.api.nvim_buf_line_count(0) == 1
        local untitled = vim.api.nvim_buf_get_name(0) == ''

        if emptylines and emptyrows and untitled then require('ui.dashboard').setup() end
      end,
    },
  },

  -- Highlight on yank
  {
    'TextYankPost',
    {
      desc = 'Highlight when yanking (copying) text',
      group = vim.api.nvim_create_augroup('YankAU', {}),
      callback = function() vim.highlight.on_yank { higroup = 'YankFlash', timeout = 200 } end,
    },
  },

  -- Hide line numbers in Spectre
  {
    'FileType',
    {
      desc = 'Hide line numbers for Spectre',
      group = vim.api.nvim_create_augroup('SpectreAU', {}),
      pattern = 'spectre_panel',
      callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
      end,
    },
  },

  -- Load/Save folds
  {
    'BufWinEnter',
    {
      desc = 'Load folds when opening file',
      group = vim.api.nvim_create_augroup('FoldsAU', { clear = false }),
      pattern = { '*.*' },
      command = 'silent! loadview',
    },
  },

  {
    'BufWinLeave',
    {
      desc = 'Save folds when closing file',
      group = vim.api.nvim_create_augroup('FoldsAU', { clear = false }),
      pattern = { '*.*' },
      command = 'mkview',
    },
  },

  -- Auto-refresh NvimTree on relevant events
  {
    {
      'BufWritePost',
      'BufDelete',
      'BufReadPost',
      'VimResized',
      'FocusGained',
      'ShellCmdPost',
      'FileChangedShellPost',
    },
    {
      desc = 'Auto-refresh Nvim-Tree on file, Git, and resize events',
      group = vim.api.nvim_create_augroup('TreeAU', {}),
      pattern = '*',
      callback = function()
        local nvt = require('nvim-tree.api').tree
        if nvt.is_visible() then nvt.reload() end
      end,
    },
  },

  -- Trigger user FilePost event
  {
    { 'UIEnter', 'BufReadPost', 'BufNewFile' },
    {
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
    },
  },

  -- Manage buffer list
  {
    { 'BufAdd', 'BufEnter', 'tabnew' },
    {
      desc = 'Manages tab-local buffer lists and tracks buffer history for dynamic navigation and cleanup',
      group = vim.api.nvim_create_augroup('BufferAU', {}),
      callback = function(args)
        local bufs = vim.t.bufs
        local is_curbuf = vim.api.nvim_get_current_buf() == args.buf

        local get_opt = function(opt, buf) return vim.api.nvim_get_option_value(opt, { buf = buf }) end

        if bufs == nil then
          bufs = is_curbuf and {} or { args.buf }
        elseif
          not vim.tbl_contains(bufs, args.buf)
          and (args.event == 'BufEnter' or not is_curbuf or get_opt('buflisted', args.buf))
          and vim.api.nvim_buf_is_valid(args.buf)
          and get_opt('buflisted', args.buf)
        then
          table.insert(bufs, args.buf)
        end

        if args.event == 'BufAdd' then
          if #vim.api.nvim_buf_get_name(bufs[1]) == 0 and not get_opt('modified', bufs[1]) then table.remove(bufs, 1) end
        end

        vim.t.bufs = bufs

        if args.event == 'BufEnter' then
          local buf_history = vim.g.buf_history or {}
          table.insert(buf_history, args.buf)
          vim.g.buf_history = buf_history
        end
      end,
    },
  },

  -- Clean up buffer list on deletion
  {
    'BufDelete',
    {
      desc = 'Remove deleted buffer from buffer list',
      group = vim.api.nvim_create_augroup('BufferAU', {}),
      callback = function(args)
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
          local bufs = vim.t[tab].bufs
          if bufs then
            for i, bufnr in ipairs(bufs) do
              if bufnr == args.buf then
                table.remove(bufs, i)
                vim.t[tab].bufs = bufs
                break
              end
            end
          end
        end
      end,
    },
  },

  -- Exclude quickfix buffers from buffer list
  {
    'FileType',
    {
      desc = 'Prevents quickfix buffers from appearing in buffer lists',
      group = vim.api.nvim_create_augroup('BufferAU', {}),
      pattern = 'qf',
      callback = function() vim.opt_local.buflisted = false end,
    },
  },

  {
    'InsertLeave',
    {
      desc = 'Reset Snippet',
      group = vim.api.nvim_create_augroup('LuaSnipAU', {}),
      callback = function()
        local ls = require 'luasnip'

        if ls.session.current_nodes[vim.api.nvim_get_current_buf()] and not ls.session.jump_active then ls.unlink_current() end
      end,
    },
  },

  -- LSP progress indicator
  {
    'LspProgress',
    {
      desc = 'Show LSP Progress bar',
      group = vim.api.nvim_create_augroup('LspProgressAU', {}),
      pattern = { 'begin', 'end' },
      callback = function(args)
        local data = args.data.params.value
        local progress = ''

        local state = require('ui.statusline').state

        if data.percentage then
          local spinners = { '', '', '', '󰪞', '󰪟', '󰪠', '󰪢', '󰪣', '󰪤', '󰪥' }
          local idx = math.max(1, math.floor(data.percentage / 10))
          local icon = spinners[idx]
          progress = table.concat { icon, ' ', data.percentage, '%% ' }
        end

        state.lsp_msg = data.kind == 'end' and ''
          or table.concat {
            progress,
            data.message or '',
            ' ',
            data.title or '',
          }

        vim.cmd.redrawstatus()
      end,
    },
  },
}

for _, trigger in ipairs(aucmds) do
  vim.api.nvim_create_autocmd(unpack(trigger))
end

-- Autocommands to be delayed on main loop
vim.schedule(function()
  local later_aucmds = {
    {
      {
        'TextChanged',
        'TextChangedI',
        'TextChangedP',
        'VimResized',
        'LspAttach',
        'WinScrolled',
        'BufEnter',
      },
      {
        desc = 'Initialize Colorify Virtual Text',
        group = vim.api.nvim_create_augroup('ColorifyAU', {}),
        callback = function(args)
          require('ui.state').ns = vim.api.nvim_create_namespace 'Colorify'

          if vim.bo[args.buf].bl then require('ui.colorify').attach(args.buf, args.event) end
        end,
      },
    },

    {
      'LspAttach',
      {
        desc = 'Initialize LSP config',
        group = vim.api.nvim_create_augroup('LspAttachAU', {}),
        callback = function(args)
          local lsp = vim.lsp
          --- @type vim.lsp.Client|nil LSP client object
          local client = lsp.get_client_by_id(args.data.client_id)

          if client then
            --- @type table|nil Signature provider details
            local signatureProvider = client.server_capabilities.signatureHelpProvider

            if signatureProvider and signatureProvider.triggerCharacters then
              local lsp_sig_au = vim.api.nvim_create_augroup('LspSignatureAU', { clear = false })

              vim.api.nvim_clear_autocmds { group = lsp_sig_au, buffer = args.buf }

              vim.api.nvim_create_autocmd('TextChangedI', {
                desc = 'Detects Trigger Characters on Insert',
                group = lsp_sig_au,
                buffer = args.buf,
                callback = function()
                  local cur_line = vim.api.nvim_get_current_line()
                  local pos = vim.api.nvim_win_get_cursor(0)[2]
                  local prev_char = cur_line:sub(pos - 1, pos - 1)
                  local cur_char = cur_line:sub(pos, pos)

                  --- @type string[] Trigger characters
                  local triggers = client.server_capabilities.signatureHelpProvider.triggerCharacters or {}

                  for _, char in ipairs(triggers) do
                    if cur_char == char or prev_char == char then lsp.buf.signature_help() end
                  end
                end,
              })
            end
          end
        end,
      },
    },
  }

  for _, trigger in ipairs(later_aucmds) do
    vim.api.nvim_create_autocmd(unpack(trigger))
  end
end)
