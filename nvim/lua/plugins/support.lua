return {
  -- https://github.com/ibhagwan/smartyank.nvim
  {
    'ibhagwan/smartyank.nvim',
    opts = {
      highlight = {
        enabled = true,
        higroup = 'YankFlash',
        timeout = 2000,
      },
      clipboard = {
        enabled = true,
      },
      tmux = {
        enabled = true,
        cmd = { 'tmux', 'set-buffer', '-w' },
      },
      osc52 = {
        enabled = true,
        ssh_only = true,
        silent = false,
        echo_hl = 'Directory',
      },
    },
  },

  -- https://github.com/folke/todo-comments.nvim
  {
    'folke/todo-comments.nvim',
  },

  -- https://github.com/rcarriga/nvim-notify
  {
    'rcarriga/nvim-notify',
    module = 'notify',
    opts = {
      background_colour = '#000000',
      fps = 60,
      stages = 'fade',
    },
  },

  -- https://github.com/folke/noice.nvim
  -- TODO update colorscheme
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
        signature = { enabled = false },
      },
      presets = {
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
      },
    },
  },
}
