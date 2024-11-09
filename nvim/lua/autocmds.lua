local vapi = vim.api
local ui_entered = vim.g.ui_entered
local editorconfig = vim.g.editorconfig

-- user event that loads after UIEnter + only if file buf is there
vapi.nvim_create_autocmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
  group = vapi.nvim_create_augroup('NvFilePost', { clear = true }),
  callback = function(args)
    local file = vapi.nvim_buf_get_name(args.buf)
    local buftype = vapi.nvim_get_option_value('buftype', { buf = args.buf })

    if not ui_entered and args.event == 'UIEnter' then
      ui_entered = true
    end

    if file ~= '' and buftype ~= 'nofile' and ui_entered then
      vapi.nvim_exec_autocmds('User', { pattern = 'FilePost', modeline = false })
      vapi.nvim_del_augroup_by_name 'NvFilePost'

      vim.schedule(function()
        vapi.nvim_exec_autocmds('FileType', {})

        if editorconfig then
          require('editorconfig').config(args.buf)
        end
      end)
    end
  end,
})
