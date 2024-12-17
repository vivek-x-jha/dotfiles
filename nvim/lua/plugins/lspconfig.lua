-- https://github.com/neovim/nvim-lspconfig
return {
	'neovim/nvim-lspconfig',
	event = 'User FilePost',
	config = function()
		local M = {}
		local lspconfig = require 'lspconfig'
		local lspbuf = vim.lsp.buf
		local lspproto = vim.lsp.protocol
		local listfolders = function() print(vim.inspect(lspbuf.list_workspace_folders())) end

		-- Run diagnostics
		local diag = vim.diagnostic
		local sev = diag.severity
		local diagnostic_config = function()
			diag.config {
				virtual_text = { prefix = '' },
				signs = {
					text = {
						[sev.ERROR] = '󰯈',
						[sev.WARN] = '',
						[sev.HINT] = '',
						[sev.INFO] = '',
					},
				},
				underline = true,
				float = { border = 'single' },
			}

			-- Default border style
			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = 'rounded'
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
			end
		end

		diagnostic_config()

		-- export on_attach & capabilities
		M.on_attach = function(_, bufnr)
			local lsprename = function()
				local api = vim.api
				local var = vim.fn.expand '<cword>'
				local buf = api.nvim_create_buf(false, true)
				local opts = { height = 1, style = 'minimal', border = 'single', row = 1, col = 1 }

				opts.relative, opts.width = 'cursor', #var + 15
				opts.title, opts.title_pos = { { ' Renamer ', '@comment.danger' } }, 'center'

				local win = api.nvim_open_win(buf, true, opts)
				vim.wo[win].winhl = 'Normal:Normal,FloatBorder:Removed'
				api.nvim_set_current_win(win)

				api.nvim_buf_set_lines(buf, 0, -1, true, { ' ' .. var })
				api.nvim_input 'A'

				vim.keymap.set({ 'i', 'n' }, '<Esc>', '<cmd>q<CR>', { buffer = buf })

				vim.keymap.set('i', '<CR>', function()
					local newName = vim.trim(api.nvim_get_current_line())
					api.nvim_win_close(win, true)

					if #newName > 0 and newName ~= var then
						local params = vim.lsp.util.make_position_params()
						params.newName = newName
						vim.lsp.buf_request(0, 'textDocument/rename', params)
					end

					vim.cmd.stopinsert()
				end, { buffer = buf })
			end

			local map = function(mode, lhs, rhs, desc) return vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = 'LSP ' .. desc }) end

			map('n', 'gD', lspbuf.declaration, 'Go to declaration')
			map('n', 'gd', lspbuf.definition, 'Go to definition')
			map('n', 'gi', lspbuf.implementation, 'Go to implementation')
			map('n', '<leader>sh', lspbuf.signature_help, 'Show signature help')
			map('n', '<leader>wa', lspbuf.add_workspace_folder, 'Add workspace folder')
			map('n', '<leader>wr', lspbuf.remove_workspace_folder, 'Remove workspace folder')
			map('n', '<leader>wl', listfolders, 'List workspace folders')
			map('n', '<leader>D', lspbuf.type_definition, 'Go to type definition')
			map('n', '<leader>ra', lsprename, 'NvRenamer')
			map({ 'n', 'v' }, '<leader>ca', lspbuf.code_action, 'Code action')
			map('n', 'gr', lspbuf.references, 'Show references')
		end

		-- disable semanticTokens
		M.on_init = function(client, _)
			if client.supports_method 'textDocument/semanticTokens' then client.server_capabilities.semanticTokensProvider = nil end
		end

		M.capabilities = lspproto.make_client_capabilities()

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

		M.defaults = function()
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
								vim.fn.expand '$VIMRUNTIME/lua',
								vim.fn.expand '$VIMRUNTIME/lua/vim/lsp',
								vim.fn.stdpath 'data' .. '/lazy/ui/nvchad_types',
								vim.fn.stdpath 'data' .. '/lazy/lazy.nvim/lua/lazy',
								'${3rd}/luv/library',
							},
							maxPreload = 100000,
							preloadFileSize = 10000,
						},
					},
				},
			}
		end

		M.defaults()

		-- lsps with default configurations
		local servers = {
			'html',
			'cssls',
			'pyre',
		}

		for _, lsp in ipairs(servers) do
			lspconfig[lsp].setup {
				on_attach = M.on_attach,
				on_init = M.on_init,
				capabilities = M.capabilities,
			}
		end
	end,
}
