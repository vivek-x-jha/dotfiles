require('nvim-treesitter.configs').setup {
  -- LuaLS type (TSConfig) expects these keys; set them explicitly:
  modules = {},
  sync_install = false,
  ignore_install = {},
  auto_install = false,

  ensure_installed = {
    'bash',
    'fish',
    'lua',
    'luadoc',
    'markdown',
    'printf',
    'toml',
    'vim',
    'vimdoc',
    'yaml',
  },
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  indent = { enable = true },
}

-- notify
local notify = require 'notify' ---@type any  -- quiets “undefined field setup”
notify.setup {
  background_colour = '#000000',
  fps = 60,
  stages = 'fade',
}

vim.notify = notify

-- noice
local noice = require 'noice' ---@type any
noice.setup {
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
    signature = { enabled = false },
  },
  presets = {
    command_palette = true,
    long_message_to_split = true,
  },
}
