-- Standardize Neovim logging for interactive and headless launches
vim.env.NVIM_LOG_FILE = vim.env.NVIM_LOG_FILE or (vim.fn.stdpath 'state' .. '/nvim.log')

-- Select the UI colorscheme once for palette consumers and :colorscheme
vim.g.ui_colorscheme = 'sourdiesel'

-- Configure core editor options
require 'opts'

-- Configure diagnostics and LSP servers
require 'lsp'

-- Register plugin sources
vim.pack.add {
  -- autocomplete
  { src = 'https://github.com/saghen/blink.lib' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/L3MON4D3/LuaSnip' }, -- blink snippets
  { src = 'https://github.com/brenoprata10/nvim-highlight-colors' },

  -- editing
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/kylechui/nvim-surround' },

  -- files
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' }, -- nvim-tree + statusline icons
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },

  -- format
  { src = 'https://github.com/stevearc/conform.nvim' },

  -- ui
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
  { src = 'https://github.com/MunifTanjim/nui.nvim' }, -- noice dependency
  { src = 'https://github.com/folke/noice.nvim' },
  { src = 'https://github.com/rcarriga/nvim-notify' },
  { src = 'https://github.com/christoomey/vim-tmux-navigator' },

  -- gitsigns
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },

  -- fzf
  { src = 'https://github.com/ibhagwan/fzf-lua' },
}

-- Configure nvim-notify and install it as Neovim's notification backend
local notify = require 'notify'
notify.setup { background_colour = os.getenv 'WEZTERM_BG_HEX', fps = 60, stages = 'fade' }
vim.notify = notify

-- Configure Noice command-line, message, and LSP UI behavior
require('noice').setup {
  presets = { command_palette = true, long_message_to_split = true },
  lsp = {
    signature = { enabled = false },
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
  },
}

-- Configure Formatters
require('conform').setup {
  format_on_save = { timeout_ms = 2000, lsp_fallback = true },
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff_format', 'ruff_organize_imports' },
    bash = { 'shfmt' },
    zsh = { 'shfmt' },
    sh = { 'shfmt' },
  },
}

-- Configure Autopairing tokens
require('nvim-autopairs').setup { fast_wrap = {}, disable_filetype = { 'vim' } }

-- Configure Auto-surround tokens
require('nvim-surround').setup()

-- Configure Indent Blankline guides
require('ibl').setup { indent = { char = '┊' } }

-- Configure Git Info
require 'plugins.gitsigns'

-- Configure Autocomplete
require 'plugins.blink'

-- Configure icons
require 'plugins.webdevicons'

-- Configure File Explorer
require 'plugins.tree'

-- Configure Pickers
require 'plugins.fzf'

-- Register autocommands
require 'autocmds'

-- Register user commands
require 'usercmds'

-- Initialize the local statusline
vim.o.statusline = "%!v:lua.require('ui.statusline').setup()"

-- Apply the shell-aligned base16 colorscheme
vim.cmd.colorscheme(vim.g.ui_colorscheme)

-- Defer keymaps to the next event loop to avoid unwanted remappings
vim.schedule(function() require 'keymaps' end)
