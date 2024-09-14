require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" }) -- Command Line w/ `;`
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>")           -- Save inCtrl + S always saves

map("n", "<C-h>", ":TmuxNavigateLeft<CR>")              -- Move left buffer/pane
map("n", "<C-j>", ":TmuxNavigateDown<CR>")              -- Move down buffer/pane
map("n", "<C-k>", ":TmuxNavigateUp<CR>")                -- Move up buffer/pane
map("n", "<C-l>", ":TmuxNavigateRight<CR>")             -- Move right buffer/pane
map("n", "<C-\\>", ":TmuxNavigateLastActive<CR>")       -- Move last buffer/pane
map("n", "<C-Space>", ":TmuxNavigateNext<CR>")          -- Move next buffer/pane
