------------------------------------ [1/6] Options ------------------------------------

-- Set leader key(s)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Disable providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Set scoped opts
vim.opt.fillchars = { eob = ' ' } -- remove trailing ~ on buffers
vim.opt.guicursor = 'n-v-c:block-blinkwait300-blinkon200-blinkoff150,i-ci:ver25-blinkwait300-blinkon200-blinkoff150' -- enable blinking cursor
vim.opt.shortmess:append 'sI' -- disable nvim intro
vim.opt.swapfile = false -- disable swap files
vim.opt.termguicolors = true -- Ensure termguicolors is enabled if not already
vim.opt.whichwrap:append '<>[]hl' -- go to previous/next line with h,l,left arrow and right arrow when cursor reaches EOL or BOL

-- Set global opts
vim.o.number = true -- print line number in front of each line
vim.o.relativenumber = true -- show relative line numbers
vim.o.numberwidth = 2 -- minimal number of columns for line number
vim.o.ruler = false -- hide the line/column position

vim.o.expandtab = true -- use spaces instead of tabs
vim.o.shiftwidth = 2 -- spaces per indent
vim.o.smartindent = true -- autoindent smartly
vim.o.tabstop = 2 -- spaces per tab
vim.o.softtabstop = 2 -- editing width of a tab

vim.o.ignorecase = true -- ignore case in search
vim.o.smartcase = true -- override ignorecase if uppercase in search

vim.o.clipboard = 'unnamedplus' -- use system clipboard
vim.o.cursorline = true -- highlight the current line
vim.o.laststatus = 3 -- global statusline
vim.o.mouse = 'a' -- enable mouse support
vim.o.showmode = false -- don't show --INSERT--
vim.o.signcolumn = 'yes' -- always show sign column
vim.o.splitbelow = true -- new horizontal splits below
vim.o.splitright = true -- new vertical splits to the right
vim.o.timeoutlen = 400 -- keymap timeout
vim.o.undofile = true -- persistent undo
vim.o.updatetime = 250 -- swap write & CursorHold delay
vim.o.winborder = 'single'

------------------------------------ [2/6] Highlights ------------------------------------

-- Set colorscheme
vim.cmd.colorscheme 'sourdiesel'

------------------------------------ [3/6] Plugins ------------------------------------

-- Install plugins
vim.pack.add {
  -- 🔧 Editing
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/L3MON4D3/LuaSnip' }, -- used by blink for lua snippets
  { src = 'https://github.com/kylechui/nvim-surround' },

  -- 📝 Formatting / Linting
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },

  -- 🔍 Search / Replace
  { src = 'https://github.com/nvim-pack/nvim-spectre' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' }, -- dependency of spectre

  -- 🪄 UI Enhancements
  { src = 'https://github.com/folke/noice.nvim' },
  { src = 'https://github.com/MunifTanjim/nui.nvim' }, -- dependency of noice
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' }, -- used by noice for syntax parsing
  { src = 'https://github.com/rcarriga/nvim-notify' },
  { src = 'https://github.com/brenoprata10/nvim-highlight-colors' },

  -- 🌲 File Explorer
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' }, -- used by tree and statusline

  -- 🌀 Git
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },

  -- 🔎 Fuzzy Finder
  { src = 'https://github.com/ibhagwan/fzf-lua' },

  -- 🧰 LSP / Tools
  { src = 'https://github.com/williamboman/mason.nvim' },

  -- 🪟 Navigation
  { src = 'https://github.com/christoomey/vim-tmux-navigator' },
}

-- Lazy load local plugins
vim.cmd.packadd 'dashboard'
vim.cmd.packadd 'terminal'

local dashboard = require 'dashboard'
local statusline = require 'statusline'
local term = require 'terminal'

-- Load lua modules
local icn = require 'icons'
local masonames = require 'masonames'

-- Load vendor plugins
local autopairs = require 'nvim-autopairs'
local blink = require 'blink.cmp'
local conform = require 'conform'
local fzf = require 'fzf-lua'
local gitsigns = require 'gitsigns'
local highlight_colors = require 'nvim-highlight-colors'
local ibl = require 'ibl'
local luasnip = require 'luasnip'
local luasnip_lua = require 'luasnip.loaders.from_lua'
local luasnip_snipmate = require 'luasnip.loaders.from_snipmate'
local luasnip_vscode = require 'luasnip.loaders.from_vscode'
local mason = require 'mason'
local mason_registry = require 'mason-registry'
local noice = require 'noice' ---@type any  -- quiets “undefined field setup”
local notify = require 'notify' ---@type any  -- quiets “undefined field setup”
local spectre = require 'spectre'
local surround = require 'nvim-surround'
local tree = require 'nvim-tree'
local tree_api = require 'nvim-tree.api'
local treesitter = require 'nvim-treesitter.configs'
local web_devicons = require 'nvim-web-devicons'

-- Autopair quotes, paranthesis, brackets, braces
autopairs.setup { fast_wrap = {}, disable_filetype = { 'vim' } }

-- LuaSnip: loaders + basic setup (mirrors the Lazy `dependencies.opts`)
luasnip_vscode.lazy_load()
luasnip_snipmate.lazy_load()
luasnip_lua.lazy_load()

luasnip.setup { history = true, updateevents = 'TextChanged,TextChangedI' }

-- Autocompletion: https://cmp.saghen.dev/installation
blink.setup {
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },

  completion = {
    documentation = { auto_show = false },
    menu = {
      draw = {
        components = {
          kind_icon = {
            text = function(ctx)
              -- default kind icon
              local icon = ctx.kind_icon
              -- colorized kind for LSP items via nvim-highlight-colors (if present)
              if ctx.item.source_name == 'LSP' then
                local ok, nhc = pcall(require, 'nvim-highlight-colors')
                if ok then
                  local color_item = nhc.format(ctx.item.documentation, { kind = ctx.kind })
                  if color_item and color_item.abbr ~= '' then icon = color_item.abbr end
                end
              end
              return icon .. ctx.icon_gap
            end,
            highlight = function(ctx)
              -- default highlight group
              local hl = 'BlinkCmpKind' .. ctx.kind
              -- colorized highlight (if available)
              if ctx.item.source_name == 'LSP' then
                local ok, nhc = pcall(require, 'nvim-highlight-colors')
                if ok then
                  local color_item = nhc.format(ctx.item.documentation, { kind = ctx.kind })
                  if color_item and color_item.abbr_hl_group then hl = color_item.abbr_hl_group end
                end
              end
              return hl
            end,
          },
        },
      },
    },
  },

  snippets = { preset = 'luasnip' },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  fuzzy = {
    implementation = 'prefer_rust_with_warning',
    prebuilt_binaries = {
      force_version = 'v1.6.0', -- TODO find way to make this dynamic
    },
  },
}

-- Formatters
conform.setup {
  format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },

  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff' },
    bash = { 'shfmt' },
    zsh = { 'shfmt' },
    sh = { 'shfmt' },
  },
}

vim.api.nvim_create_autocmd('BufWritePre', { callback = function(args) conform.format { bufnr = args.buf } end })
vim.keymap.set('n', '<leader>fm', function() conform.format { lsp_fallback = true } end, { desc = '[f]or[m]at file with linter' })

-- Multi Modal Picker
fzf.setup {
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
}

vim.keymap.set('n', '<leader>ff', function() fzf.files() end, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fo', function() fzf.oldfiles() end, { desc = '[R]ecent [B]uffers' })
vim.keymap.set('n', '<leader>fa', function() fzf.autocmds() end, { desc = '[F]ind Neovim [A]uto-commands' })
vim.keymap.set('n', '<leader>fw', function() fzf.live_grep() end, { desc = '[F]ind [W]ord' })
vim.keymap.set('n', '<leader>fc', function() fzf.command_history() end, { desc = '[F]ind [C]ommands' })
vim.keymap.set('n', '<leader>fb', function() fzf.buffers() end, { desc = '[F]ind [B]uffers' })
vim.keymap.set('n', '<leader>fn', function() fzf.commands() end, { desc = '[F]ind Neovim [C]ommands' })
vim.keymap.set('n', '<leader>fg', function() fzf.git_files() end, { desc = '[F]ind [G]it Files' })
vim.keymap.set('n', '<leader>glg', function() fzf.git_commits() end, { desc = '[G]it [L]og Graph' })
vim.keymap.set('n', '<leader>gst', function() fzf.git_status() end, { desc = '[G]it [St]atus' })
vim.keymap.set('n', '<leader>gsw', function() fzf.git_branches() end, { desc = '[G]it [S]witch' })

-- Git buffer icons
local signs = {
  add = { text = '+' },
  change = { text = '~' },
  delete = { text = 'x' },
  topdelete = { text = 'x' },
  changedelete = { text = 'x' },
  untracked = { text = '?' },
}

gitsigns.setup { signs = signs, signs_staged = signs }

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, { callback = function(args) gitsigns.attach(args.buf) end })
vim.keymap.set('n', '<leader>gb', function() gitsigns.toggle_current_line_blame() end, { desc = 'Toggle [g]itsigns current line [b]lame' })

-- Color Previews
highlight_colors.setup { render = 'virtual', virtual_symbol = icn.virtual_block }

-- Markers for indentation
ibl.setup { indent = { char = '┊' } }

-- LSP tool manager
mason.setup {
  ui = {
    icons = {
      package_pending = icn.download,
      package_installed = icn.checkmark,
      package_uninstalled = icn.dotted_circle,
    },
  },

  max_concurrent_installers = 10,
}

-- Syntax Highlighting
treesitter.setup {
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

-- UI for pop-ups
notify.setup {
  background_colour = '#000000',
  fps = 60,
  stages = 'fade',
}

vim.notify = notify

-- Notification + Cmd Line UI Manager
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

-- Search & Replace
spectre.setup { result_padding = '', default = { replace = { cmd = 'sed' } } }

vim.keymap.set('n', '<leader>S', function() spectre.toggle() end, { desc = 'Toggle [S]pectre' })
vim.keymap.set('n', '<leader>sw', function() spectre.open_visual { select_word = true } end, { desc = '[S]earch current [w]ord' })
vim.keymap.set('v', '<leader>sw', function() spectre.open_visual() end, { desc = '[S]earch current [w]ord' })

-- Auto bracket/paranthesis/quote wrapping
surround.setup()

-- Additional Icon set
web_devicons.setup {
  override = {
    default_icon = { icon = icn.completions.File, name = 'Default' },
    js = { icon = icn.javascript, name = 'js' },
    ts = { icon = icn.typescript, name = 'ts' },
    lock = { icon = icn.lock, name = 'lock' },
    ['robots.txt'] = { icon = icn.robot, name = 'robots' },
  },
}

-- File Explorer
tree.setup {
  hijack_cursor = true,
  disable_netrw = true,
  sync_root_with_cwd = true,
  view = { preserve_window_proportions = true },

  renderer = {
    root_folder_label = false,
    special_files = { 'README.md' },
    highlight_git = true,
    highlight_diagnostics = true,
    highlight_modified = 'icon',

    indent_markers = {
      enable = true,
      icons = {
        edge = '┊',
        item = '┊',
      },
    },

    icons = {
      modified_placement = 'signcolumn',
      diagnostics_placement = 'before',
      glyphs = {
        modified = icn.modified,
        folder = {
          default = '󰉖',
          empty = '󱧹',
          empty_open = '󰷏',
          open = '󰷏',
          symlink = '󱉆',
        },
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

  update_focused_file = { enable = true },

  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = icn.hint,
      info = icn.info,
      warning = icn.warn,
      error = icn.error,
    },
  },

  modified = { enable = true },
  filters = { git_ignored = false },
  live_filter = { prefix = ' ' },
  help = { sort_by = 'desc' },
}

vim.keymap.set('n', '<C-n>', function()
  tree_api.tree.toggle { focus = false }
  vim.cmd 'wincmd ='
end, { desc = 'Toggle file explorer' })

vim.keymap.set('n', '<leader>e', function()
  tree_api.tree.open()
  vim.cmd 'wincmd ='
end, { desc = 'Focus file [e]xplorer' })

------------------------------------ [4/6] LSP ------------------------------------

local tools = {}
local linters = { 'shellcheck' }
local formatters = conform.list_all_formatters()
local servers = vim.fs.joinpath(vim.fn.stdpath 'config', 'lsp')

-- Ensure linters + formatters + servers installed
vim.list_extend(tools, linters)

for _, v in ipairs(formatters) do
  vim.list_extend(tools, vim.split(v.name:gsub(',', ''), '%s+'))
end

for name, kind in vim.fs.dir(servers) do
  if kind == 'file' and name:sub(-4) == '.lua' then table.insert(tools, name:sub(1, -5)) end
end

mason_registry.refresh(function()
  for _, tool in ipairs(tools) do
    local tool_kebab = assert(masonames[tool])
    local pkg = mason_registry.get_package(tool_kebab)

    if not pkg:is_installed() then pkg:install() end
  end
end)

-- Configure autocompletions
vim.lsp.config('*', { capabilities = blink.get_lsp_capabilities() })

-- Configure diagnostics
vim.diagnostic.config {
  float = { border = 'single' },
  severity_sort = true,

  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icn.error,
      [vim.diagnostic.severity.WARN] = icn.warn,
      [vim.diagnostic.severity.HINT] = icn.hint,
      [vim.diagnostic.severity.INFO] = icn.info,
    },
  },

  virtual_lines = {
    current_line = true,
  },

  virtual_text = {
    current_line = true,
    prefix = icn.virtualcircle,
  },
}

-- Enable LSP
vim.lsp.enable(tools)

------------------------------------ [5/6] Auto-Commands (Event Triggers) ------------------------------------

-- Display Dashboard on blank startup
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Display Dashboard on blank startup',
  group = vim.api.nvim_create_augroup('DashAU', {}),
  callback = function()
    local emptylines = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == ''
    local emptyrows = vim.api.nvim_buf_line_count(0) == 1
    local untitled = vim.api.nvim_buf_get_name(0) == ''

    if emptylines and emptyrows and untitled then dashboard.setup() end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('YankAU', {}),
  callback = function() vim.highlight.on_yank { higroup = 'YankFlash', timeout = 200 } end,
})

-- Highlight color strings with virtual text
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Highlight color strings with virtual text',
  group = vim.api.nvim_create_augroup('ColorifyAU', {}),
  callback = function()
    vim.schedule(function() highlight_colors.turnOn() end)
  end,
})

-- Hide line numbers in Spectre
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Hide line numbers for Spectre',
  group = vim.api.nvim_create_augroup('SpectreAU', {}),
  pattern = 'spectre_panel',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- Load folds
vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Load folds when opening file',
  group = vim.api.nvim_create_augroup('FoldsAU', { clear = false }),
  pattern = { '*.*' },
  command = 'silent! loadview',
})

-- Save folds
vim.api.nvim_create_autocmd('BufWinLeave', {
  desc = 'Save folds when closing file',
  group = vim.api.nvim_create_augroup('FoldsAU', { clear = false }),
  pattern = { '*.*' },
  command = 'mkview',
})

-- Auto-refresh NvimTree on relevant events
vim.api.nvim_create_autocmd({
  'BufWritePost',
  'BufDelete',
  'BufReadPost',
  'VimResized',
  'FocusGained',
  'ShellCmdPost',
  'FileChangedShellPost',
}, {
  desc = 'Auto-refresh Nvim-Tree on file, Git, and resize events',
  group = vim.api.nvim_create_augroup('TreeAU', {}),
  pattern = '*',
  callback = function()
    if tree_api.tree.is_visible() then tree_api.tree.reload() end
  end,
})

-- Trigger user FilePost event
vim.api.nvim_create_autocmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
  desc = 'Wait to load user events on non-empty buffers',
  group = vim.api.nvim_create_augroup('FilePostAU', {}),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })

    if not vim.g.ui_entered and args.event == 'UIEnter' then vim.g.ui_entered = true end

    if file ~= '' and buftype ~= 'nofile' and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds('User', { pattern = 'FilePost', modeline = false })
      vim.api.nvim_del_augroup_by_name 'FilePostAU'

      vim.schedule(function()
        vim.api.nvim_exec_autocmds('FileType', {})
        if vim.g.editorconfig then require('editorconfig').config(args.buf) end
      end)
    end
  end,
})

-- Manage buffer list
vim.api.nvim_create_autocmd({ 'BufAdd', 'BufEnter' }, {
  desc = 'Manages tab-local buffer lists and tracks buffer history for dynamic navigation and cleanup',
  group = vim.api.nvim_create_augroup('BufferAU', {}),
  callback = function(args)
    local bufs = vim.t.bufs
    local is_curbuf = vim.api.nvim_get_current_buf() == args.buf

    local get_opt = function(opt, buf) return vim.api.nvim_get_option_value(opt, { buf = buf }) end

    if bufs == nil then
      bufs = is_curbuf and {} or { args.buf }
    elseif
      not vim.tbl_contains(bufs, args.buf)
      and (args.event == 'BufEnter' or not is_curbuf or get_opt('buflisted', args.buf))
      and vim.api.nvim_buf_is_valid(args.buf)
      and get_opt('buflisted', args.buf)
    then
      table.insert(bufs, args.buf)
    end

    if args.event == 'BufAdd' then
      if #vim.api.nvim_buf_get_name(bufs[1]) == 0 and not get_opt('modified', bufs[1]) then table.remove(bufs, 1) end
    end

    vim.t.bufs = bufs

    if args.event == 'BufEnter' then
      local buf_history = vim.g.buf_history or {}
      table.insert(buf_history, args.buf)
      vim.g.buf_history = buf_history
    end
  end,
})

-- Clean up buffer list on deletion
vim.api.nvim_create_autocmd('BufDelete', {
  desc = 'Remove deleted buffer from buffer list',
  group = vim.api.nvim_create_augroup('BufferAU', {}),
  callback = function(args)
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
      local bufs = vim.t[tab].bufs
      if bufs then
        for i, bufnr in ipairs(bufs) do
          if bufnr == args.buf then
            table.remove(bufs, i)
            vim.t[tab].bufs = bufs
            break
          end
        end
      end
    end
  end,
})

-- Exclude quickfix buffers from buffer list
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Prevents quickfix buffers from appearing in buffer lists',
  group = vim.api.nvim_create_augroup('BufferAU', {}),
  pattern = 'qf',
  callback = function() vim.opt_local.buflisted = false end,
})

-- Always refresh snippet list with respect to buffer
vim.api.nvim_create_autocmd('InsertLeave', {
  desc = 'Reset Snippet',
  group = vim.api.nvim_create_augroup('LuaSnipAU', {}),
  callback = function()
    if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then luasnip.unlink_current() end
  end,
})

-- LSP progress indicator
vim.api.nvim_create_autocmd('LspProgress', {
  desc = 'Show LSP Progress bar',
  group = vim.api.nvim_create_augroup('LspProgressAU', {}),
  pattern = { 'begin', 'end' },
  callback = function(args)
    local data = args.data.params.value
    local progress = ''

    if data.percentage then
      local spinners = { '', '', '', '󰪞', '󰪟', '󰪠', '󰪢', '󰪣', '󰪤', '󰪥' }
      local idx = math.max(1, math.floor(data.percentage / 10))
      local icon = spinners[idx]
      progress = table.concat { icon, ' ', data.percentage, '%% ' }
    end

    statusline.state.lsp_msg = data.kind == 'end' and ''
      or table.concat {
        progress,
        data.message or '',
        ' ',
        data.title or '',
      }

    vim.cmd.redrawstatus()
  end,
})

-- Initialize LSP on insert mode
vim.schedule(function()
  vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'Initialize LSP config',
    group = vim.api.nvim_create_augroup('LspAttachAU', {}),
    callback = function(args)
      local lsp = vim.lsp
      --- @type vim.lsp.Client|nil LSP client object
      local client = lsp.get_client_by_id(args.data.client_id)

      if client then
        --- @type table|nil Signature provider details
        local signatureProvider = client.server_capabilities.signatureHelpProvider

        if signatureProvider and signatureProvider.triggerCharacters then
          local lsp_sig_au = vim.api.nvim_create_augroup('LspSignatureAU', { clear = false })

          vim.api.nvim_clear_autocmds { group = lsp_sig_au, buffer = args.buf }

          vim.api.nvim_create_autocmd('TextChangedI', {
            desc = 'Detects Trigger Characters on Insert',
            group = lsp_sig_au,
            buffer = args.buf,
            callback = function()
              local cur_line = vim.api.nvim_get_current_line()
              local pos = vim.api.nvim_win_get_cursor(0)[2]
              local prev_char = cur_line:sub(pos - 1, pos - 1)
              local cur_char = cur_line:sub(pos, pos)

              --- @type string[] Trigger characters
              local triggers = client.server_capabilities.signatureHelpProvider.triggerCharacters or {}

              for _, char in ipairs(triggers) do
                if cur_char == char or prev_char == char then lsp.buf.signature_help() end
              end
            end,
          })
        end
      end
    end,
  })
end)

------------------------------------ [6/6] Key Mappings (Deferred) ------------------------------------

vim.schedule(function()
  vim.keymap.set('n', ';', ':', { desc = 'Enter CMD mode w/o <Shift>' })

  -- Toggle line numbers
  vim.keymap.set('n', '<leader>n', '<cmd>set nu!<CR>', { desc = 'Toggle line number' })
  vim.keymap.set('n', '<leader>rn', '<cmd>set rnu!<CR>', { desc = 'Toggle relative number' })

  -- Comments
  vim.keymap.set('n', '<leader>/', 'gcc', { desc = 'Toggle comment', remap = true })
  vim.keymap.set('v', '<leader>/', 'gc', { desc = 'Toggle comment', remap = true })

  -- Indentation
  vim.keymap.set('v', '<Tab>', '>gv', { desc = 'Indent selection' })
  vim.keymap.set('v', '<S-Tab>', '<gv', { desc = 'Outdent selection' })

  -- Insert mode navigation
  vim.keymap.set('i', '<C-b>', '<ESC>I', { desc = 'Move [b]eginning of line' })
  vim.keymap.set('i', '<C-e>', '<End>', { desc = 'Move [e]nd of line' })
  vim.keymap.set('i', '<C-h>', '<Left>', { desc = 'Move left' })
  vim.keymap.set('i', '<C-l>', '<Right>', { desc = 'Move right' })
  vim.keymap.set('i', '<C-j>', '<Down>', { desc = 'Move down' })
  vim.keymap.set('i', '<C-k>', '<Up>', { desc = 'Move up' })

  -- Scrolling
  vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Page [d]own and center' })
  vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Page [u]p and center' })
  vim.keymap.set('n', 'n', 'nzz', { desc = 'Next search result and center' })
  vim.keymap.set('n', 'N', 'Nzz', { desc = 'Previous search result and center' })

  -- Moving selections
  vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
  vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

  -- Sessions
  vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>', { desc = '[S]ave file' })
  vim.keymap.set('n', '<leader>rr', '<cmd>restart<CR>', { desc = 'Reinitialize Neovim' })
  vim.keymap.set('n', '<leader>oo', function()
    vim.cmd 'silent! mksession! Session.vim'
    vim.notify('Updating workspace state: Session.vim', vim.log.levels.INFO)
  end, { desc = 'Save workspace config' })

  -- Buffers
  vim.keymap.set('n', '<leader>b', '<cmd>enew<CR>', { desc = 'Open [b]uffer' })
  vim.keymap.set('n', '<leader>x', '<cmd>bdelete<CR>', { desc = 'Close buffer' })
  vim.keymap.set('n', '<C-c>', '<cmd>%y+<CR>', { desc = '[C]opy file' })
  vim.keymap.set('n', '<leader>nd', '<cmd>NoiceDismiss<CR>', { desc = 'Clear notifications' })
  vim.keymap.set('n', '<Esc>', '<cmd>noh<CR>', { desc = 'Clear highlights' })

  -- Terminal
  vim.keymap.set('t', '<C-x>', '<C-\\><C-N>', { desc = 'Escape terminal mode' })
  vim.keymap.set('n', '<leader>h', function() term.open { pos = 'sp' } end, { desc = 'Open [h]orizontal terminal' })
  vim.keymap.set('n', '<leader>v', function() term.open { pos = 'vsp' } end, { desc = 'Open [v]ertical terminal' })
  vim.keymap.set({ 'n', 't' }, '<A-v>', function() term.toggle { pos = 'vsp', id = 'vtoggleTerm' } end, { desc = 'Toggle [v]ertical terminal' })
  vim.keymap.set({ 'n', 't' }, '<A-h>', function() term.toggle { pos = 'sp', id = 'htoggleTerm' } end, { desc = 'Toggle [h]orizontal terminal' })
  vim.keymap.set({ 'n', 't' }, '<A-i>', function() term.toggle { pos = 'float', id = 'floatTerm' } end, { desc = 'Toggle [f]loating terminal' })

  -- LSP
  vim.keymap.set('n', '<leader>ds', vim.diagnostic.setloclist, { desc = 'LSP diagnostic loclist' })

  -- Dashboard
  vim.keymap.set('n', '<leader>da', function() dashboard.setup() end, { desc = 'Toggle Dashboard' })
end)
