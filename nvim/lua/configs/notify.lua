local function set_hl(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

set_hl('NotifyERRORIcon', { fg = '#f096b7' })
set_hl('NotifyWARNIcon', { fg = '#f3b175' })
set_hl('NotifyINFOIcon', { fg = '#d2fd9d' })
set_hl('NotifyDEBUGIcon', { fg = '#c9ccfb' })
set_hl('NotifyTRACEIcon', { fg = '#47e7b1' })

set_hl('NotifyERRORTitle', { fg = '#f096b7' })
set_hl('NotifyWARNTitle', { fg = '#f3b175' })
set_hl('NotifyINFOTitle', { fg = '#d2fd9d' })
set_hl('NotifyDEBUGTitle', { fg = '#c9ccfb' })
set_hl('NotifyTRACETitle', { fg = '#47e7b1' })

return {
  background_colour = '#000000',
  fps = 60,
  stages = 'fade',
}
