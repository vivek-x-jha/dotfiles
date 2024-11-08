local highlight = vim.api.nvim_set_hl
local notify_opts = {
  background_colour = "#000000",
  fps = 60,
  stages = "fade",
}

highlight(0, "NotifyERRORIcon", { fg = "#f096b7" })
highlight(0, "NotifyWARNIcon", { fg = "#f3b175" })
highlight(0, "NotifyINFOIcon", { fg = "#d2fd9d" })
highlight(0, "NotifyDEBUGIcon", { fg = "#c9ccfb" })
highlight(0, "NotifyTRACEIcon", { fg = "#47e7b1" })

highlight(0, "NotifyERRORTitle", { fg = "#f096b7" })
highlight(0, "NotifyWARNTitle", { fg = "#f3b175" })
highlight(0, "NotifyINFOTitle", { fg = "#d2fd9d" })
highlight(0, "NotifyDEBUGTitle", { fg = "#c9ccfb" })
highlight(0, "NotifyTRACETitle", { fg = "#47e7b1" })

require("notify").setup(notify_opts)
