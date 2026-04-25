local devicons = require 'nvim-web-devicons'
local icons = require 'icons'

local palette = {
  black = vim.env.BLACK_HEX or '#cccccc',
  red = vim.env.RED_HEX or '#ffc7c7',
  green = vim.env.GREEN_HEX or '#ceffc9',
  yellow = vim.env.YELLOW_HEX or '#fdf7cd',
  blue = vim.env.BLUE_HEX or '#c4effa',
  magenta = vim.env.MAGENTA_HEX or '#eccef0',
  cyan = vim.env.CYAN_HEX or '#8ae7c5',
  brightblack = vim.env.BRIGHTBLACK_HEX or '#5c617d',
  brightred = vim.env.BRIGHTRED_HEX or '#f096b7',
  brightgreen = vim.env.BRIGHTGREEN_HEX or '#d2fd9d',
  brightyellow = vim.env.BRIGHTYELLOW_HEX or '#f3b175',
  brightblue = vim.env.BRIGHTBLUE_HEX or '#80d7fe',
  brightmagenta = vim.env.BRIGHTMAGENTA_HEX or '#c9ccfb',
  brightcyan = vim.env.BRIGHTCYAN_HEX or '#47e7b1',
  brightwhite = vim.env.BRIGHTWHITE_HEX or '#ffffff',
}

local devicon_overrides = {
  -- Defaults we lean on
  ['sh'] = { icon = icons.shell, name = 'sh' },
  ['bash'] = { icon = icons.shell, name = 'bash' },
  ['zsh'] = { icon = icons.shell, name = 'zsh' },
  ['default_icon'] = { icon = icons.file, name = 'Default' },
  ['js'] = { icon = icons.javascript, name = 'js' },
  ['ts'] = { icon = icons.typescript, name = 'ts' },
  ['lua'] = { icon = icons.lua, name = 'lua', color = palette.brightwhite },
  ['py'] = { icon = icons.python, name = 'py', color = palette.brightwhite },
  ['lock'] = { icon = icons.lock, name = 'lock' },
  ['.gitignore'] = { icon = icons.branch, name = 'git', color = palette.black },
  ['.cz.toml'] = { icon = icons.branch, name = '.cz.toml', color = palette.black },
  ['Makefile'] = { icon = icons.makefile, name = 'Makefile' },
  ['txt'] = { icon = icons.file, name = 'txt' },
  ['config'] = { icon = icons.gear, name = 'config', color = palette.magenta },
  ['md'] = { icon = icons.markdown, name = 'md', color = palette.brightyellow },

  -- Zsh helpers (autoload + wrappers)
  ['aliases'] = { icon = icons.command, name = 'aliases' },
  ['cheatsheet'] = { icon = icons.command, name = 'cheatsheet' },
  ['commit-and-sync'] = { icon = icons.command, name = 'commit-and-sync' },
  ['edit-all'] = { icon = icons.command, name = 'edit-all' },
  ['fix-tmux-remotes'] = { icon = icons.command, name = 'fix-tmux-remotes' },
  ['list-256'] = { icon = icons.command, name = 'list-256' },
  ['list-colors'] = { icon = icons.command, name = 'list-colors' },
  ['take'] = { icon = icons.command, name = 'take' },
  ['update-all'] = { icon = icons.command, name = 'update-all' },
  ['update-branches'] = { icon = icons.command, name = 'UpdateBranches' },
  ['update-icons'] = { icon = icons.command, name = 'update-icons' },
  ['uvi'] = { icon = icons.command, name = 'uvi' },
  ['work'] = { icon = icons.command, name = 'work' },

  -- Dotfiles + environment helpers
  ['.dircolors'] = { icon = icons.gear, name = '.dircolors', color = palette.magenta },
  ['.hushlogin'] = { icon = icons.file, name = '.hushlogin', color = palette.brightblack },
  ['.python-version'] = { icon = icons.gear, name = '.python-version', color = palette.black },
  ['.ruff.toml'] = { icon = icons.gear, name = '.ruff.toml', color = palette.black },
  ['config.sh'] = { icon = icons.shell, name = 'config.sh' },
  ['fzf.sh'] = { icon = icons.shell, name = 'fzf.sh', color = palette.magenta },
  ['.bashrc'] = { icon = icons.shell, name = '.bashrc', color = palette.magenta },
  ['.bash_profile'] = { icon = icons.shell, name = '.bash_profile', color = palette.magenta },
  ['.blerc'] = { icon = icons.shell, name = 'Blerc', color = palette.magenta },
  ['.zshenv'] = { icon = icons.key, name = '.zshenv', color = palette.brightred },
  ['.zshrc'] = { icon = icons.shell, name = '.zshrc', color = palette.magenta },
  ['.zprofile'] = { icon = icons.shell, name = '.zprofile', color = palette.magenta },
  ['.p10k.zsh'] = { icon = icons.shell, name = '.p10k.zsh', color = palette.magenta },
  ['.env'] = { icon = icons.key, name = '.env', color = palette.brightred },
  ['env'] = { icon = icons.key, name = 'Env', color = palette.brightred },
  ['sourdiesel'] = { icon = icons.color, name = 'Sourdiesel', color = palette.cyan },
  ['sourdiesel.json'] = { icon = icons.color, name = 'SourdieselJson', color = palette.cyan },
  ['sourdiesel.toml'] = { icon = icons.color, name = 'SourdieselToml', color = palette.cyan },
  ['sourdiesel.terminal'] = { icon = icons.color, name = 'SourdieselTerminal', color = palette.cyan },
  ['theme.yml'] = { icon = icons.color, name = 'theme.yml', color = palette.cyan },
  ['session.vim'] = { icon = icons.vim, name = 'Session.vim', color = palette.brightblack },
  ['bootstrap.sh'] = { icon = icons.sync, name = 'bootstrap.sh', color = palette.brightgreen },
  ['.state.itermexport'] = { icon = icons.gear, name = '.state.itermexport', color = palette.black },
  ['.localized'] = { icon = icons.file, name = '.localized', color = palette.brightblack },
  ['.dbxignore'] = { icon = icons.file, name = '.dbxignore' },
  ['.DS_Store'] = { icon = icons.macos, name = '.DS_Store', color = palette.brightblack },
  ['icon\r'] = { icon = icons.file, name = 'Icon', color = palette.brightblack },
  ['.bash_history'] = { icon = icons.log, name = '.bash_history', color = palette.red },
  ['.histfile'] = { icon = icons.log, name = '.histfile', color = palette.red },
  ['.history'] = { icon = icons.log, name = '.history', color = palette.red },
  ['.zsh_history'] = { icon = icons.log, name = '.zsh_history', color = palette.red },
  ['allowed_signers'] = { icon = icons.signature, name = 'allowed_signers', color = palette.brightblue },
  ['known_hosts'] = { icon = icons.host, name = 'known_hosts', color = palette.brightblue },
  ['.luarc.json'] = { icon = icons.gear, name = '.luarc.json', color = palette.black },
  ['.netrwhist'] = { icon = icons.netrwhist, name = '.netrwhist', color = palette.brightblack },
  ['.stylua.toml'] = { icon = icons.gear, name = '.stylua.toml', color = palette.black },
  ['agent.toml'] = { icon = icons.gear, name = 'agent.toml', color = palette.magenta },
  ['btop.conf'] = { icon = icons.gear, name = 'btop.conf', color = palette.magenta },
  ['btop.log'] = { icon = icons.log, name = 'btop.log', color = palette.red },
  ['config.yml'] = { icon = icons.gear, name = 'config.yml', color = palette.magenta },
  ['config.toml'] = { icon = icons.gear, name = 'config.toml', color = palette.magenta },
  ['extensions.json'] = { icon = icons.gear, name = 'extensions.json', color = palette.magenta },
  ['glow.yml'] = { icon = icons.gear, name = 'glow.yml', color = palette.magenta },
  ['hist'] = { icon = icons.log, name = 'hist', color = palette.red },
  ['histfile'] = { icon = icons.log, name = 'histfile', color = palette.red },
  ['history'] = { icon = icons.log, name = 'history', color = palette.red },
  ['lesshst'] = { icon = icons.log, name = 'lesshst', color = palette.red },
  ['init.lua'] = { icon = icons.lua, name = 'init.lua', color = palette.magenta },
  ['karabiner.json'] = { icon = icons.gear, name = 'karabiner.json', color = palette.magenta },
  ['settings.json'] = { icon = icons.gear, name = 'settings.json', color = palette.magenta },
  ['starship.toml'] = { icon = icons.gear, name = 'starship.toml', color = palette.magenta },
  ['wezterm.lua'] = { icon = icons.lua, name = 'wezterm.lua', color = palette.magenta },
  ['AGENTS.md'] = { icon = icons.robot, name = 'AGENTS', color = palette.brightyellow },
  ['CLAUDE.md'] = { icon = icons.robot, name = 'CLAUDE', color = palette.brightyellow },
  ['README.md'] = { icon = icons.markdown, name = 'README', color = palette.brightyellow },
  ['LICENSE'] = { icon = icons.markdown, name = 'LICENSE', color = palette.brightyellow },
  ['CONTRIBUTING.md'] = { icon = icons.markdown, name = 'CONTRIBUTING', color = palette.brightyellow },
  ['SECURITY.md'] = { icon = icons.markdown, name = 'SECURITY', color = palette.brightyellow },

  -- Generic config formats
  ['conf'] = { icon = icons.gear, name = 'conf', color = palette.black },
  ['json'] = { icon = icons.gear, name = 'json', color = palette.black },
  ['jsonc'] = { icon = icons.gear, name = 'jsonc', color = palette.black },
  ['log'] = { icon = icons.log, name = 'log', color = palette.red },
  ['terminal'] = { icon = icons.color, name = 'terminal', color = palette.cyan },
  ['toml'] = { icon = icons.gear, name = 'toml', color = palette.black },
  ['tmtheme'] = { icon = icons.color, name = 'tmTheme', color = palette.cyan },
  ['tmux.conf'] = { icon = icons.gear, name = 'tmux.conf', color = palette.magenta },
  ['theme'] = { icon = icons.color, name = 'theme', color = palette.cyan },
  ['sublime-syntax'] = { icon = icons.syntax, name = 'sublime-syntax', color = palette.brightblue },
  ['yaml'] = { icon = icons.gear, name = 'yaml', color = palette.black },
  ['yml'] = { icon = icons.gear, name = 'yml', color = palette.black },
  ['xml'] = { icon = icons.gear, name = 'xml', color = palette.black },

  -- Package / lock manifests
  ['apt-packages.txt'] = { icon = icons.package, name = 'apt-packages', color = palette.brightmagenta },
  ['Brewfile'] = { icon = icons.package, name = 'Brewfile', color = palette.brightmagenta },
  ['Brewfile.lock.json'] = { icon = icons.package, name = 'Brewfile.lock', color = palette.brightmagenta },
  ['dnf-packages.txt'] = { icon = icons.package, name = 'dnf-packages', color = palette.brightmagenta },
  ['package.lock'] = { icon = icons.package, name = 'package.lock', color = palette.brightmagenta },
  ['package-lock.json'] = { icon = icons.package, name = 'package-lock', color = palette.brightmagenta },
  ['pnpm-lock.yaml'] = { icon = icons.package, name = 'pnpm-lock', color = palette.brightmagenta },
  ['yarn.lock'] = { icon = icons.package, name = 'yarn.lock', color = palette.brightmagenta },
  ['package.json'] = { icon = icons.package, name = 'package.json', color = palette.brightmagenta },
  ['bun.lockb'] = { icon = icons.package, name = 'bun.lockb', color = palette.brightmagenta },
  ['uv.lock'] = { icon = icons.package, name = 'uv.lock', color = palette.brightmagenta },
  ['requirements.txt'] = { icon = icons.package, name = 'requirements', color = palette.brightmagenta },
  ['poetry.lock'] = { icon = icons.package, name = 'poetry.lock', color = palette.brightmagenta },
  ['Pipfile'] = { icon = icons.package, name = 'Pipfile', color = palette.brightmagenta },
  ['Pipfile.lock'] = { icon = icons.package, name = 'Pipfile.lock', color = palette.brightmagenta },
  ['pyproject.toml'] = { icon = icons.package, name = 'pyproject', color = palette.brightmagenta },
  ['Cargo.toml'] = { icon = icons.package, name = 'Cargo.toml', color = palette.brightmagenta },
  ['Cargo.lock'] = { icon = icons.package, name = 'Cargo.lock', color = palette.brightmagenta },
  ['go.mod'] = { icon = icons.package, name = 'go.mod', color = palette.brightmagenta },
  ['go.sum'] = { icon = icons.package, name = 'go.sum', color = palette.brightmagenta },
  ['Gemfile'] = { icon = icons.package, name = 'Gemfile', color = palette.brightmagenta },
  ['Gemfile.lock'] = { icon = icons.package, name = 'Gemfile.lock', color = palette.brightmagenta },
  ['pom.xml'] = { icon = icons.package, name = 'pom.xml', color = palette.brightmagenta },
  ['build.gradle'] = { icon = icons.package, name = 'build.gradle', color = palette.brightmagenta },
  ['build.gradle.kts'] = { icon = icons.package, name = 'build.gradle.kts', color = palette.brightmagenta },
  ['gradle.lockfile'] = { icon = icons.package, name = 'gradle.lockfile', color = palette.brightmagenta },
  ['composer.json'] = { icon = icons.package, name = 'composer.json', color = palette.brightmagenta },
  ['composer.lock'] = { icon = icons.package, name = 'composer.lock', color = palette.brightmagenta },
  ['mix.exs'] = { icon = icons.package, name = 'mix.exs', color = palette.brightmagenta },
  ['mix.lock'] = { icon = icons.package, name = 'mix.lock', color = palette.brightmagenta },
  ['stack.yaml'] = { icon = icons.package, name = 'stack.yaml', color = palette.brightmagenta },
  ['cabal.project'] = { icon = icons.package, name = 'cabal.project', color = palette.brightmagenta },
  ['cabal.project.freeze'] = { icon = icons.package, name = 'cabal.project.freeze', color = palette.brightmagenta },
  ['pubspec.yaml'] = { icon = icons.package, name = 'pubspec.yaml', color = palette.brightmagenta },
  ['pubspec.lock'] = { icon = icons.package, name = 'pubspec.lock', color = palette.brightmagenta },
  ['Package.swift'] = { icon = icons.package, name = 'Package.swift', color = palette.brightmagenta },
  ['Package.resolved'] = { icon = icons.package, name = 'Package.resolved', color = palette.brightmagenta },
  ['packages.config'] = { icon = icons.package, name = 'packages.config', color = palette.brightmagenta },
  ['project.assets.json'] = { icon = icons.package, name = 'project.assets', color = palette.brightmagenta },
  ['nvim-pack-lock.json'] = { icon = icons.package, name = 'nvim-pack-lock', color = palette.brightmagenta },
}

devicons.setup { override = devicon_overrides }
-- setup() is ignored if devicons loaded earlier; set_icon() keeps overrides deterministic.
devicons.set_icon(devicon_overrides)

require('nvim-tree').setup {
  hijack_cursor = true,
  disable_netrw = true,
  sync_root_with_cwd = true,
  filesystem_watchers = { enable = false },
  view = { preserve_window_proportions = true },
  update_focused_file = { enable = true },
  modified = { enable = true },
  filters = { git_ignored = false },
  live_filter = { prefix = icons.search .. ' ' },
  help = { sort_by = 'desc' },

  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = 'H',
      info = 'I',
      warning = 'W',
      error = 'E',
    },
  },

  renderer = {
    special_files = {
      'Icon\r',
      'Session.vim',
    },

    root_folder_label = false,
    highlight_git = 'icon',
    highlight_diagnostics = 'all',
    highlight_modified = 'icon',

    indent_markers = {
      enable = true,
      icons = { edge = '┊', item = '┊' },
    },

    icons = {
      modified_placement = 'signcolumn',
      diagnostics_placement = 'before',

      glyphs = {
        modified = icons.modified,

        folder = {
          default = icons.folder,
          empty = icons.folder,
          empty_open = icons.folder,
          open = icons.folder,
          symlink = icons.folder,
        },
        symlink = icons.link,

        git = {
          renamed = '𝙍',
          staged = '+',
          unmerged = '!',
          unstaged = '~',
          untracked = '?',
          ignored = '',
          deleted = '✘',
        },
      },
    },
  },
}

local function apply_nvim_tree_highlights()
  vim.api.nvim_set_hl(0, 'NvimTreeExecFile', { link = 'NvimTreeFileName' })
  vim.api.nvim_set_hl(0, 'NvimTreeSpecialFile', { fg = palette.brightblack })
end

vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Apply custom nvim-tree highlights',
  group = vim.api.nvim_create_augroup('NvimTreeCustomHighlights', {}),
  callback = apply_nvim_tree_highlights,
})

apply_nvim_tree_highlights()
