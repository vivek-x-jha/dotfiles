require "nvchad.options"

local o = vim.o

-- o.cursorlineopt ='both' -- to enable cursorline!
o.relativenumber = true

-- enable blinking cursor
vim.opt.guicursor = "n-v-c:block-blinkwait300-blinkon200-blinkoff150,i-ci:ver25-blinkwait300-blinkon200-blinkoff150"
