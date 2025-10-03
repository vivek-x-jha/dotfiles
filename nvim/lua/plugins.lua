--- @type table<string, string> -- Custom icons
local icons = require 'icons'

-- Color Previews
require('nvim-highlight-colors').setup { render = 'foreground' }

-- LuaSnip: loaders + basic setup (mirrors the Lazy `dependencies.opts`)
require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_snipmate').lazy_load()
require('luasnip.loaders.from_lua').lazy_load()

require('luasnip').setup { history = true, updateevents = 'TextChanged,TextChangedI' }

-- Autocompletion: https://cmp.saghen.dev/installation
require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  snippets = { preset = 'luasnip' },
  sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
  fuzzy = { implementation = 'prefer_rust_with_warning', prebuilt_binaries = { force_version = 'v1.6.0' } },
  signature = { enabled = true },

  completion = {
    documentation = { auto_show = true },
    menu = {
      auto_show = true,
      draw = {
        components = {
          kind_icon = {
            text = function(ctx)
              local color_item = ctx.item.source_name == 'LSP'
                and require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })

              local icon = color_item and color_item.abbr ~= '' and color_item.abbr or ctx.kind_icon

              return icon .. ctx.icon_gap
            end,

            highlight = function(ctx)
              local color_item = ctx.item.source_name == 'LSP'
                and require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })

              local hl = color_item and color_item.abbr_hl_group or 'BlinkCmpKind' .. ctx.kind

              return hl
            end,
          },
        },
      },
    },
  },
}

-- Autopair quotes, paranthesis, brackets, braces
require('nvim-autopairs').setup { fast_wrap = {}, disable_filetype = { 'vim' } }

-- Formatters
require('conform').setup {
  format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },

  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff' },
    bash = { 'shfmt' },
    zsh = { 'shfmt' },
    sh = { 'shfmt' },
  },
}

-- Fuzzy finder / picker
require('fzf-lua').setup {
  winopts = { preview = { winopts = { number = false, signcolumn = 'yes' } } },
  files = { header = 'fd --type f', winopts = { title = table.concat { ' ', icons.search, ' files ' }, title_flags = false } },
  autocmds = { header = ':autocmd', winopts = { title = table.concat { ' ', icons.warn, ' event triggers ' }, title_flags = false } },
  buffers = { header = ':ls', winopts = { title = table.concat { ' ', icons.file, ' buffers ' }, title_flags = false } },
  commands = { header = ':command', winopts = { title = table.concat { ' ', icons.vim, ' commands ' }, title_flags = false } },
  command_history = { header = ':history', winopts = { title = table.concat { ' ', icons.cmd_hist, ' command history ' }, title_flags = false } },
  grep = { header = ':!rg --vimgrep', winopts = { title = table.concat { ' ', icons.fuzzy, ' fuzzy search' }, title_flags = false } },

  oldfiles = {
    header = ':FzfLua oldfiles',
    include_current_session = true,
    cwd_only = true,
    winopts = { title = table.concat { ' ', icons.recent, ' recent files ' }, title_flags = false },
  },

  git = {
    files = { header = ':!git ls-files --exclude-standard', winopts = { title = table.concat { ' ', icons.git, ' ', icons.file, ' files (git) ' } } },
    branches = { header = ':!git branch --all --color && git switch', winopts = { title = table.concat { ' ', icons.branch, ' branches ' } } },
    commits = { header = ':!git log --color --pretty=format:"..."', winopts = { title = table.concat { ' ', icons.log, '  git commits ' } } },
    status = {
      header = ':!git -c color.status=false --no-optional-locks status --porcelain=v1 -u',
      winopts = { title = table.concat { ' ', icons.status, ' git status ' } },
    },
  },
}

---@type table<string, { text: string, show_count?: boolean }> Git sign column icons
local gs_icons = {
  add = { text = '+' },
  change = { text = '~' },
  delete = { text = 'x' },
  topdelete = { text = 'x' },
  changedelete = { text = 'x' },
  untracked = { text = '?' },
}

require('gitsigns').setup { signs = gs_icons, signs_staged = gs_icons }

-- Markers for indentation
require('ibl').setup { indent = { char = '┊' } }

-- Syntax Highlighting
require('nvim-treesitter.configs').setup {
  -- LuaLS type (TSConfig) expects these keys; set them explicitly:
  modules = {},
  sync_install = false,
  ignore_install = {},
  auto_install = false,
  highlight = { enable = true, use_languagetree = true },
  indent = { enable = true },

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
}

-- UI for pop-ups
vim.notify = require 'notify'
vim.notify.setup { background_colour = os.getenv 'WEZTERM_BG_HEX', fps = 60, stages = 'fade' }

-- Notification + Cmd Line UI Manager
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

-- Search & Replace
require('spectre').setup { result_padding = '', default = { replace = { cmd = 'sed' } } }

-- Auto bracket/paranthesis/quote wrapping
require('nvim-surround').setup()

-- Additional Icon set
require('nvim-web-devicons').setup {
  override = {
    default_icon = { icon = icons.file, name = 'Default' },
    js = { icon = icons.javascript, name = 'js' },
    ts = { icon = icons.typescript, name = 'ts' },
    lock = { icon = icons.lock, name = 'lock' },
    ['robots.txt'] = { icon = icons.robot, name = 'robots' },
  },
}

-- File Explorer
require('nvim-tree').setup {
  hijack_cursor = true,
  disable_netrw = true,
  sync_root_with_cwd = true,
  view = { preserve_window_proportions = true },
  update_focused_file = { enable = true },
  diagnostics = { enable = true, show_on_dirs = true, icons = { hint = 'H', info = 'I', warning = 'W', error = 'E' } },
  modified = { enable = true },
  filters = { git_ignored = false },
  live_filter = { prefix = icons.search .. ' ' },
  help = { sort_by = 'desc' },

  renderer = {
    root_folder_label = false,
    special_files = { 'README.md' },
    highlight_git = true,
    highlight_diagnostics = true,
    highlight_modified = 'icon',

    indent_markers = { enable = true, icons = { edge = '┊', item = '┊' } },

    icons = {
      modified_placement = 'signcolumn',
      diagnostics_placement = 'before',

      glyphs = {
        modified = icons.modified,
        folder = { default = icons.folder, empty = '󱧹', empty_open = '󰷏', open = '󰷏', symlink = '󱉆' },
        git = { renamed = '𝙍', staged = '+', unmerged = '!', unstaged = '~', untracked = '?', ignored = '', deleted = '✘' },
      },
    },
  },
}
