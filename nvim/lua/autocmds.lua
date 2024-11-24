local vapi = vim.api
local g = vim.g

-- user event that loads after UIEnter + only if file buf is there
vapi.nvim_create_autocmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
  group = vapi.nvim_create_augroup('NvFilePost', { clear = true }),
  callback = function(args)
    local file = vapi.nvim_buf_get_name(args.buf)
    local buftype = vapi.nvim_get_option_value('buftype', { buf = args.buf })

    if not g.ui_entered and args.event == 'UIEnter' then
      g.ui_entered = true
    end

    if file ~= '' and buftype ~= 'nofile' and g.ui_entered then
      vapi.nvim_exec_autocmds('User', { pattern = 'FilePost', modeline = false })
      vapi.nvim_del_augroup_by_name 'NvFilePost'

      vim.schedule(function()
        vapi.nvim_exec_autocmds('FileType', {})

        if g.editorconfig then
          require('editorconfig').config(args.buf)
        end
      end)
    end
  end,
})

-- Maintains fold state on reopen
vapi.nvim_create_autocmd({ 'BufWinLeave' }, {
  pattern = { '*.*' },
  desc = 'save view (folds), when closing file',
  command = 'mkview',
})

vapi.nvim_create_autocmd({ 'BufWinEnter' }, {
  pattern = { '*.*' },
  desc = 'load view (folds), when opening file',
  command = 'silent! loadview',
})
