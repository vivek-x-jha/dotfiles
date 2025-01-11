local icn = require 'ui.icons'
local utl = require 'configs.utils'

local lspservers = {
  'lua_ls',
  'pyright',
}

return {
  -- https://github.com/williamboman/mason.nvim
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonInstallAll', 'MasonUpdate' },
    opts = {
      PATH = 'skip',
      ui = {
        icons = {
          package_pending = icn.download,
          package_installed = icn.checkmark,
          package_uninstalled = icn.dotted_circle,
        },
      },
      max_concurrent_installers = 10,
    },
  },

  -- https://github.com/williamboman/mason-lspconfig.nvim
  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      ensure_installed = lspservers,
    },
  },

  -- https://github.com/neovim/nvim-lspconfig
  {
    'neovim/nvim-lspconfig',
    event = 'User FilePost',
    config = function()
      -- configure diagnostics
      vim.diagnostic.config {
        virtual_text = { prefix = icn.virtualcircle },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icn.error,
            [vim.diagnostic.severity.WARN] = icn.warn,
            [vim.diagnostic.severity.HINT] = icn.hint,
            [vim.diagnostic.severity.INFO] = icn.info,
          },
        },
        severity_sort = true,
        float = { border = 'single' },
      }

      -- configure language servers
      for _, server in ipairs(lspservers) do
        require('lspconfig')[server].setup {
          on_attach = function(_, bufnr)
            local mappings = {
              {
                desc = 'LSP Go to declaration',
                buffer = bufnr,
                mode = 'n',
                keys = 'gD',
                command = vim.lsp.buf.declaration,
              },

              {
                desc = 'LSP Go to definition',
                buffer = bufnr,
                mode = 'n',
                keys = 'gd',
                command = vim.lsp.buf.definition,
              },

              {
                desc = 'LSP Go to implementation',
                buffer = bufnr,
                mode = 'n',
                keys = 'gi',
                command = vim.lsp.buf.implementation,
              },

              {
                desc = 'LSP Show signature help',
                buffer = bufnr,
                mode = 'n',
                keys = '<leader>sh',
                command = vim.lsp.buf.signature_help,
              },

              {
                desc = 'LSP Add workspace folder',
                buffer = bufnr,
                mode = 'n',
                keys = '<leader>wa',
                command = vim.lsp.buf.add_workspace_folder,
              },

              {
                desc = 'LSP Remove workspace folder',
                buffer = bufnr,
                mode = 'n',
                keys = '<leader>wr',
                command = vim.lsp.buf.remove_workspace_folder,
              },

              {
                desc = 'LSP Go to type definition',
                buffer = bufnr,
                mode = 'n',
                keys = '<leader>D',
                command = vim.lsp.buf.type_definition,
              },

              {
                desc = 'LSP Code action',
                buffer = bufnr,
                mode = { 'n', 'v' },
                keys = '<leader>ca',
                command = vim.lsp.buf.code_action,
              },

              {
                desc = 'LSP Show references',
                buffer = bufnr,
                mode = 'n',
                keys = 'gr',
                command = vim.lsp.buf.references,
              },

              {
                desc = 'LSP List workspace folders',
                buffer = bufnr,
                mode = 'n',
                keys = '<leader>wl',
                command = function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
              },

              {
                desc = 'LSP NvRenamer',
                buffer = bufnr,
                mode = 'n',
                keys = '<leader>ra',
                command = function()
                  local buf = vim.api.nvim_create_buf(false, true)
                  local var = vim.fn.expand '<cword>'
                  local win = vim.api.nvim_open_win(buf, true, {
                    height = 1,
                    style = 'minimal',
                    border = 'single',
                    row = 1,
                    col = 1,
                    relative = 'cursor',
                    width = #var + 15,
                    title = { { ' Renamer ', '@comment.danger' } },
                    title_pos = 'center',
                  })

                  vim.wo[win].winhl = 'Normal:Normal,FloatBorder:Removed'
                  vim.api.nvim_set_current_win(win)

                  vim.api.nvim_buf_set_lines(buf, 0, -1, true, { ' ' .. var })
                  vim.api.nvim_input 'A'

                  utl.set_keymap {
                    desc = 'Exit LSP rename operation',
                    buffer = buf,
                    mode = { 'i', 'n' },
                    keys = '<Esc>',
                    command = '<cmd>q<CR>',
                  }

                  utl.set_keymap {
                    desc = 'Send an LSP rename request',
                    buffer = buf,
                    mode = 'i',
                    keys = '<CR>',
                    command = function()
                      local newName = vim.trim(vim.api.nvim_get_current_line())
                      vim.api.nvim_win_close(win, true)

                      if #newName > 0 and newName ~= var then
                        local params = vim.lsp.util.make_position_params()
                        params.newName = newName
                        vim.lsp.buf_request(0, 'textDocument/rename', params)
                      end
                    end,
                  }
                end,
              },
            }

            for _, keymap in ipairs(mappings) do
              utl.set_keymap(keymap)
            end
          end,

          capabilities = vim.lsp.protocol.make_client_capabilities(),

          on_init = function(client, _)
            if client.supports_method 'textDocument/semanticTokens' then client.server_capabilities.semanticTokensProvider = nil end
          end,

          settings = require('lsp.' .. server),
        }
      end
    end,
  },
}
