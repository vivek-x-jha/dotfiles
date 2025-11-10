--- @type table<string, string> -- Custom icons
local icons = require 'icons'

require('fzf-lua').setup {
  winopts = {
    preview = { winopts = { number = false, signcolumn = 'yes' } },
  },

  files = {
    header = 'fd --type f',
    winopts = { title = ' ' .. icons.search .. ' files ', title_flags = false },
  },

  autocmds = {
    header = ':autocmd',
    winopts = { title = ' ' .. icons.event .. ' event triggers ', title_flags = false },
  },

  buffers = {
    header = ':ls',
    winopts = { title = ' ' .. icons.file .. ' buffers ', title_flags = false },
  },

  commands = {
    header = ':command',
    winopts = { title = ' ' .. icons.vim .. ' commands ', title_flags = false },
  },

  command_history = {
    header = ':history',
    winopts = { title = ' ' .. icons.cmd_hist .. ' command history ', title_flags = false },
  },

  grep = {
    rg_opts = table.concat({
      '--hidden',
      '--follow',
      '--glob=!.git',
      '--glob=!node_modules',
      '--glob=!vendor',
      '--glob=!.cache',
      '--glob=!tmp',
      '--max-columns=160',
      '--max-columns-preview',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    }, ' '),

    header = ':!rg --vimgrep',
    winopts = { title = ' ' .. icons.fuzzy .. ' fuzzy search', title_flags = false },
  },

  oldfiles = {
    header = ':FzfLua oldfiles',
    include_current_session = true,
    cwd_only = true,
    winopts = { title = ' ' .. icons.recent .. ' recent files ', title_flags = false },
  },

  git = {
    files = {
      header = ':!git ls-files --exclude-standard',
      winopts = { title = ' ' .. icons.git .. ' ' .. icons.file .. ' files (git) ' },
    },

    branches = {
      header = ':!git branch --all --color && git switch',
      winopts = { title = ' ' .. icons.branch .. ' branches ' },
    },

    commits = {
      header = ':!git log --color --pretty=format:"..."',
      winopts = { title = ' ' .. icons.log .. '  git commits ' },
    },

    status = {
      header = ':!git -c color.status=false --no-optional-locks status --porcelain=v1 -u',
      winopts = { title = ' ' .. icons.status .. ' git status ' },
    },
  },
}
