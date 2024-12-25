-- https://github.com/neovim/nvim-lspconfig
return {
  'neovim/nvim-lspconfig',
  event = 'User FilePost',
  config = function()
    local M = {}
    local api = vim.api
    local fn = vim.fn
    local lspbuf = vim.lsp.buf
    local lspconfig = require 'lspconfig'
    local diag = vim.diagnostic
    local sev = diag.severity
    local icons = require 'ui.icons'

    local remap = function(mode, keys, action, bufnr, desc)
      local opts = { buffer = bufnr, desc = desc }
      return vim.keymap.set(mode, keys, action, opts)
    end

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

    -- set diagnostics options
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

    -- export on_attach & capabilities
    M.on_attach = function(_, bufnr)
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
    end

    -- disable semanticTokens
    M.on_init = function(client, _)
      if client.supports_method 'textDocument/semanticTokens' then client.server_capabilities.semanticTokensProvider = nil end
    end

    M.capabilities = vim.lsp.protocol.make_client_capabilities()

    M.capabilities.textDocument.completion.completionItem = {
      documentationFormat = { 'markdown', 'plaintext' },
      snippetSupport = true,
      preselectSupport = true,
      insertReplaceSupport = true,
      labelDetailsSupport = true,
      deprecatedSupport = true,
      commitCharactersSupport = true,
      tagSupport = { valueSet = { 1 } },
      resolveSupport = { properties = { 'documentation', 'detail', 'additionalTextEdits' } },
    }

    -- setup language servers
    lspconfig.lua_ls.setup {
      on_attach = M.on_attach,
      capabilities = M.capabilities,
      on_init = M.on_init,

      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = {
              fn.expand '$VIMRUNTIME/lua',
              fn.expand '$VIMRUNTIME/lua/vim/lsp',
              fn.stdpath 'data' .. '/lazy/lazy.nvim/lua/lazy',
              '${3rd}/luv/library',
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
          },
        },
      },
    }

    lspconfig.pyright.setup {
      on_attach = M.on_attach,
      on_init = M.on_init,
      capabilities = M.capabilities,
      settings = {
        python = {
          analysis = {
            typeCheckingMode = 'strict',
            autoSearchPaths = true,
            diagnosticMode = 'workspace',
            useLibraryCodeForTypes = true,
          },
        },
      },
    }
  end,
}
