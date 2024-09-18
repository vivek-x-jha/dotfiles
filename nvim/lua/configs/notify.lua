require("notify").setup({
  background_colour = "#000000",
  fps = 60,
  stages = "fade",
})

vim.api.nvim_set_hl(0, "NotifyERRORIcon",  { fg = "#f096b7" })
vim.api.nvim_set_hl(0, "NotifyWARNIcon",   { fg = "#f3b175" })
vim.api.nvim_set_hl(0, "NotifyINFOIcon",   { fg = "#d2fd9d" })
vim.api.nvim_set_hl(0, "NotifyDEBUGIcon",  { fg = "#c9ccfb" })
vim.api.nvim_set_hl(0, "NotifyTRACEIcon",  { fg = "#47e7b1" })

vim.api.nvim_set_hl(0, "NotifyERRORTitle", { fg = "#f096b7" })
vim.api.nvim_set_hl(0, "NotifyWARNTitle",  { fg = "#f3b175" })
vim.api.nvim_set_hl(0, "NotifyINFOTitle",  { fg = "#d2fd9d" })
vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { fg = "#c9ccfb" })
vim.api.nvim_set_hl(0, "NotifyTRACETitle", { fg = "#47e7b1" })
