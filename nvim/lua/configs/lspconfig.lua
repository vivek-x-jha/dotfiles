local lspUI = require 'nvchad.lsp'
local lspconfig = require 'lspconfig'
local lsprename = require 'nvchad.lsp.renamer'
local lspbuf = vim.lsp.buf
local lspproto = vim.lsp.protocol

local listfolders = function() print(vim.inspect(lspbuf.list_workspace_folders())) end

lspUI.diagnostic_config()

local M = {}

-- export on_attach & capabilities
M.on_attach = function(_, bufnr)
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

M.setupLSP = function()
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
end

return M.setupLSP()
