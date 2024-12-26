return {
  -- https://github.com/williamboman/mason.nvim
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonInstallAll', 'MasonUpdate' },
    opts = {
      PATH = 'skip',
      ui = {
        icons = {
          package_pending = ' ',
          package_installed = ' ',
          package_uninstalled = ' ',
        },
      },
      max_concurrent_installers = 10,
    },
  },

  -- https://github.com/williamboman/mason-lspconfig.nvim
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup {
        ensure_installed = { 'lua_ls', 'pyright' },
      }
    end,
  },

  -- https://github.com/neovim/nvim-lspconfig
  {
    'neovim/nvim-lspconfig',
    event = 'User FilePost',
    config = function()
      local api = vim.api
      local diag = vim.diagnostic
      local sev = diag.severity
      local fn = vim.fn
      local lspbuf = vim.lsp.buf

      local lspconfig = require 'lspconfig'
      local icons = require 'ui.icons'

      local remap = function(mode, keys, action, bufnr, desc)
        local opts = { buffer = bufnr, desc = desc }
        return vim.keymap.set(mode, keys, action, opts)
      end

      -- configure diagnostics
      diag.config {
        virtual_text = { prefix = icons.virtualcircle },
        signs = {
          text = {
            [sev.ERROR] = icons.error,
            [sev.WARN] = icons.warn,
            [sev.HINT] = icons.hint,
            [sev.INFO] = icons.info,
          },
        },
        severity_sort = true,
        float = { border = 'single' },
      }

      -- configure language servers
      local lspservers = { 'lua_ls', 'pyright' }

      for _, server in ipairs(lspservers) do
        lspconfig[server].setup {
          on_attach = function(_, bufnr)
            local listfolders = function() print(vim.inspect(lspbuf.list_workspace_folders())) end

            local lsprename = function()
              local buf = api.nvim_create_buf(false, true)
              local var = fn.expand '<cword>'
              local win = api.nvim_open_win(buf, true, {
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
              api.nvim_set_current_win(win)

              api.nvim_buf_set_lines(buf, 0, -1, true, { ' ' .. var })
              api.nvim_input 'A'

              remap({ 'i', 'n' }, '<Esc>', '<cmd>q<CR>', buf)

              remap('i', '<CR>', function()
                local newName = vim.trim(api.nvim_get_current_line())
                api.nvim_win_close(win, true)

                if #newName > 0 and newName ~= var then
                  local params = vim.lsp.util.make_position_params()
                  params.newName = newName
                  vim.lsp.buf_request(0, 'textDocument/rename', params)
                end

                vim.cmd.stopinsert()
              end, buf)
            end

            local mappings = {
              { 'n', 'gD', lspbuf.declaration, 'Go to declaration' },
              { 'n', 'gd', lspbuf.definition, 'Go to definition' },
              { 'n', 'gi', lspbuf.implementation, 'Go to implementation' },
              { 'n', '<leader>sh', lspbuf.signature_help, 'Show signature help' },
              { 'n', '<leader>wa', lspbuf.add_workspace_folder, 'Add workspace folder' },
              { 'n', '<leader>wr', lspbuf.remove_workspace_folder, 'Remove workspace folder' },
              { 'n', '<leader>wl', listfolders, 'List workspace folders' },
              { 'n', '<leader>D', lspbuf.type_definition, 'Go to type definition' },
              { 'n', '<leader>ra', lsprename, 'NvRenamer' },
              { { 'n', 'v' }, '<leader>ca', lspbuf.code_action, 'Code action' },
              { 'n', 'gr', lspbuf.references, 'Show references' },
            }

            for _, keymap in ipairs(mappings) do
              remap(keymap[1], keymap[2], keymap[3], bufnr, 'LSP ' .. keymap[4])
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
