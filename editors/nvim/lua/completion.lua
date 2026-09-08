vim.opt.completeopt = { 'menuone', 'noselect', 'fuzzy', 'popup' }

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Enable native LSP completion',
  group = vim.api.nvim_create_augroup('LspCompletionAU', {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client or not client:supports_method 'textDocument/completion' then return end

    vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, { buffer = ev.buf, desc = 'Trigger LSP completion' })
  end,
})
