local icn = require 'ui.icons'

-- https://github.com/ibhagwan/fzf-lua
return {
  {
    'ibhagwan/fzf-lua',
    keys = {
      { '<leader>ff', '<cmd>FzfLua files<CR>', { desc = '[F]ind [F]iles' } },
      { '<leader>fo', '<cmd>FzfLua oldfiles<CR>', { desc = '[R]ecent [B]uffers' } },
      { '<leader>fa', '<cmd>FzfLua autocmds<cr>', { desc = '[F]ind Neovim [A]uto-commands' } },
      { '<leader>fw', '<cmd>FzfLua live_grep<CR>', { desc = '[F]ind [W]ord' } },
      { '<leader>fc', '<cmd>FzfLua command_history<cr>', { desc = '[F]ind [C]ommands' } },
      { '<leader>fb', '<cmd>FzfLua buffers<CR>', { desc = '[F]ind [B]uffers' } },
      { '<leader>fn', '<cmd>FzfLua commands<cr>', { desc = '[F]ind Neovim [C]ommands' } },
      { '<leader>fg', '<cmd>FzfLua git_files<cr>', { desc = '[F]ind [G]it Files' } },
      { '<leader>glg', '<cmd>FzfLua git_commits<cr>', { desc = '[G]it [L]og Graph' } },
      { '<leader>gst', '<cmd>FzfLua git_status<cr>', { desc = '[G]it [St]atus' } },
      { '<leader>gsw', '<cmd>FzfLua git_branches<cr>', { desc = '[G]it [S]witch' } },
    },
    opts = {
      winopts = {
        preview = {
          winopts = {
            number = false,
            signcolumn = 'yes',
          },
        },
      },

      files = {
        header = 'fd --type f',
        winopts = {
          title = table.concat { ' ', icn.search, ' files ' },
          title_flags = false,
        },
      },

      oldfiles = {
        header = ':FzfLua oldfiles',
        include_current_session = true,
        cwd_only = true,
        winopts = {
          title = table.concat { ' ', icn.recent, ' recent files ' },
          title_flags = false,
        },
      },

      autocmds = {
        header = ':autocmd',
        winopts = {
          title = table.concat { ' ', icn.warn, ' event triggers ' },
          title_flags = false,
        },
      },

      buffers = {
        header = ':ls',
        winopts = {
          title = table.concat { ' ', icn.file, ' buffers ' },
          title_flags = false,
        },
      },

      commands = {
        header = ':command',
        winopts = {
          title = table.concat { ' ', icn.vim, ' commands ' },
          title_flags = false,
        },
      },

      command_history = {
        header = ':history',
        winopts = {
          title = table.concat { ' ', icn.cmd_hist, ' command history ' },
          title_flags = false,
        },
      },

      git = {
        files = {
          header = ':!git ls-files --exclude-standard',
          winopts = {
            title = table.concat { ' ', icn.git, ' ', icn.file, ' files (git) ' },
          },
        },

        branches = {
          header = ':!git branch --all --color && git switch',
          winopts = {
            title = table.concat { ' ', icn.branch, ' branches ' },
          },
        },

        status = {
          header = ':!git -c color.status=false --no-optional-locks status --porcelain=v1 -u',
          winopts = {
            title = table.concat { ' ', icn.status, ' git status ' },
          },
        },

        commits = {
          header = ':!git log --color --pretty=format:"..."',
          winopts = {
            title = table.concat { ' ', icn.log, '  git commits ' },
          },
        },
      },

      grep = {
        header = ':!rg --vimgrep',
        winopts = {
          title = table.concat { ' ', icn.fuzzy, ' fuzzy search' },
          title_flags = false,
        },
      },
    },
  },
}
