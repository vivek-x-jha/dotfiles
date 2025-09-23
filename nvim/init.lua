------------------------------------ [1/5] Options ------------------------------------

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

-- Set highlights
vim.cmd.colorscheme 'sourdiesel'

------------------------------------ [2/5] LSP ------------------------------------

vim.cmd.packadd 'icons'

--- @type table<string, string> Custom icons
local icons = require 'icons'

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'single' },
  virtual_lines = { current_line = true },
  virtual_text = { current_line = true, prefix = icons.virtualcircle },

  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.error,
      [vim.diagnostic.severity.WARN] = icons.warn,
      [vim.diagnostic.severity.HINT] = icons.hint,
      [vim.diagnostic.severity.INFO] = icons.info,
    },
  },
}

---@type string[] language server configs
local servers = {}

---@type string language server configs path
local lspconfigs = vim.fs.joinpath(vim.fn.stdpath 'config', 'lsp')

for name, kind in vim.fs.dir(lspconfigs) do
  ---@type boolean flag for lua file
  local is_lua_file = name:sub(-4) == '.lua' and kind == 'file'

  if is_lua_file then table.insert(servers, name:sub(1, -5)) end
end

-- Initialize language servers
vim.lsp.enable(servers)

------------------------------------ [3/5] Plugins ------------------------------------

vim.pack.add {
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/L3MON4D3/LuaSnip' }, -- blink snippets
  { src = 'https://github.com/kylechui/nvim-surround' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
  { src = 'https://github.com/nvim-pack/nvim-spectre' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' }, -- spectre dependency
  { src = 'https://github.com/folke/noice.nvim' },
  { src = 'https://github.com/MunifTanjim/nui.nvim' }, -- noice dependency
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' }, -- noice syntax parsing
  { src = 'https://github.com/rcarriga/nvim-notify' },
  { src = 'https://github.com/brenoprata10/nvim-highlight-colors' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' }, -- nvim-tree + statusline icons
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/christoomey/vim-tmux-navigator' },
}

-- Color Previews
require('nvim-highlight-colors').setup { render = 'virtual', virtual_symbol = icons.virtual_block }

-- LuaSnip: loaders + basic setup (mirrors the Lazy `dependencies.opts`)
require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_snipmate').lazy_load()
require('luasnip.loaders.from_lua').lazy_load()

require('luasnip').setup { history = true, updateevents = 'TextChanged,TextChangedI' }

-- Autocompletion: https://cmp.saghen.dev/installation
require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },

  completion = {
    documentation = { auto_show = false },
    menu = {
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

-- Multi Modal Picker
require('fzf-lua').setup {
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
      title = table.concat { ' ', icons.search, ' files ' },
      title_flags = false,
    },
  },

  oldfiles = {
    header = ':FzfLua oldfiles',
    include_current_session = true,
    cwd_only = true,
    winopts = {
      title = table.concat { ' ', icons.recent, ' recent files ' },
      title_flags = false,
    },
  },

  autocmds = {
    header = ':autocmd',
    winopts = {
      title = table.concat { ' ', icons.warn, ' event triggers ' },
      title_flags = false,
    },
  },

  buffers = {
    header = ':ls',
    winopts = {
      title = table.concat { ' ', icons.file, ' buffers ' },
      title_flags = false,
    },
  },

  commands = {
    header = ':command',
    winopts = {
      title = table.concat { ' ', icons.vim, ' commands ' },
      title_flags = false,
    },
  },

  command_history = {
    header = ':history',
    winopts = {
      title = table.concat { ' ', icons.cmd_hist, ' command history ' },
      title_flags = false,
    },
  },

  git = {
    files = {
      header = ':!git ls-files --exclude-standard',
      winopts = {
        title = table.concat { ' ', icons.git, ' ', icons.file, ' files (git) ' },
      },
    },

    branches = {
      header = ':!git branch --all --color && git switch',
      winopts = {
        title = table.concat { ' ', icons.branch, ' branches ' },
      },
    },

    status = {
      header = ':!git -c color.status=false --no-optional-locks status --porcelain=v1 -u',
      winopts = {
        title = table.concat { ' ', icons.status, ' git status ' },
      },
    },

    commits = {
      header = ':!git log --color --pretty=format:"..."',
      winopts = {
        title = table.concat { ' ', icons.log, '  git commits ' },
      },
    },
  },

  grep = {
    header = ':!rg --vimgrep',
    winopts = {
      title = table.concat { ' ', icons.fuzzy, ' fuzzy search' },
      title_flags = false,
    },
  },
}

---@type table<string, { text: string }> Git sign column icons
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
        modified = icons.modified,
        folder = {
          default = icons.folder,
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
      hint = icons.hint,
      info = icons.info,
      warning = icons.warn,
      error = icons.error,
    },
  },

  modified = { enable = true },
  filters = { git_ignored = false },
  live_filter = { prefix = icons.search .. ' ' },
  help = { sort_by = 'desc' },
}

------------------------------------ [4/5] Auto-Commands (Event Triggers) ------------------------------------

------------------------------------ Vendor Auto-commands ------------------------------------

-- Enable git icons in editor gutter
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, { callback = function(args) require('gitsigns').attach(args.buf) end })

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

-- Always refresh snippet list with respect to buffer
vim.api.nvim_create_autocmd('InsertLeave', {
  desc = 'Reset Snippet',
  group = vim.api.nvim_create_augroup('LuaSnipAU', {}),
  callback = function()
    local ls = require 'luasnip'

    if ls.session.current_nodes[vim.api.nvim_get_current_buf()] and not ls.session.jump_active then ls.unlink_current() end
  end,
})

-- Auto-refresh NvimTree on relevant events
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufDelete', 'BufReadPost', 'VimResized', 'FocusGained', 'ShellCmdPost', 'FileChangedShellPost' }, {
  desc = 'Auto-refresh Nvim-Tree on file, Git, and resize events',
  group = vim.api.nvim_create_augroup('TreeAU', {}),
  pattern = '*',
  callback = function()
    local nvt = require('nvim-tree.api').tree
    if nvt.is_visible() then nvt.reload() end
  end,
})

------------------------------------ Local Auto-commands ------------------------------------

-- Display Dashboard on blank startup
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Display Dashboard on blank startup',
  group = vim.api.nvim_create_augroup('DashAU', {}),
  callback = function()
    local emptylines = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == ''
    local emptyrows = vim.api.nvim_buf_line_count(0) == 1
    local untitled = vim.api.nvim_buf_get_name(0) == ''

    vim.cmd.packadd 'dashboard'
    if emptylines and emptyrows and untitled then require('dashboard').setup() end
  end,
})

-- Exclude quickfix buffers from buffer list
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Prevents quickfix buffers from appearing in buffer lists',
  group = vim.api.nvim_create_augroup('BufferAU', {}),
  pattern = 'qf',
  callback = function() vim.opt_local.buflisted = false end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('YankAU', {}),
  callback = function() vim.highlight.on_yank { higroup = 'YankFlash', timeout = 200 } end,
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
vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
  desc = 'Remove deleted buffer from buffer list',
  group = vim.api.nvim_create_augroup('BufferAU', { clear = true }),
  callback = function(args)
    -- Run after Neovim finishes closing windows/tabs for this deletion.
    vim.schedule(function()
      for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        if vim.api.nvim_tabpage_is_valid(tab) then
          local vars = vim.t[tab]
          local bufs = vars and vars.bufs

          if type(bufs) == 'table' then
            -- remove in reverse to be extra safe
            for i = #bufs, 1, -1 do
              if bufs[i] == args.buf then
                table.remove(bufs, i)
                break
              end
            end
          end
        end
      end
    end)
  end,
})

-- LSP progress indicator
vim.api.nvim_create_autocmd('LspProgress', {
  desc = 'Show LSP Progress bar',
  group = vim.api.nvim_create_augroup('LspProgressAU', {}),
  pattern = { 'begin', 'end' },
  callback = function(args)
    ---@type { kind: 'begin'|'report'|'end', title?: string, message?: string, percentage?: number }
    local data = args.data.params.value

    ---@type string progress spinner + percent + trailing space (or empty)
    local progress = ''

    if data.percentage then
      ---@type string[] all spinner shapes
      local spinners = { '', '', '', '󰪞', '󰪟', '󰪠', '󰪢', '󰪣', '󰪤', '󰪥' }

      ---@type integer index into spinners (1..#spinners), map 0..100 -> 1..10
      local idx = math.max(1, math.floor(data.percentage / 10))

      progress = table.concat { spinners[idx], ' ', data.percentage, '%% ' }
    end

    ---@type string LSP progress message
    local msg = table.concat { progress, data.message or '', ' ', data.title or '' }

    -- update LSP message in statusline
    require('statusline').state.lsp_msg = data.kind ~= 'end' and msg or ''
    vim.cmd.redrawstatus()
  end,
})

-- Initialize LSP on insert mode
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Initialize LSP config',
  group = vim.api.nvim_create_augroup('LspAttachAU', {}),
  callback = function(args)
    vim.schedule(function()
      --- @type vim.lsp.Client|nil LSP client object
      local client = vim.lsp.get_client_by_id(args.data.client_id)

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
                if cur_char == char or prev_char == char then vim.lsp.buf.signature_help() end
              end
            end,
          })
        end
      end
    end)
  end,
})

------------------------------------ [5/5] Keymaps ------------------------------------

vim.schedule(function()
  ------------------------------------ Vendor Hotkeys ------------------------------------

  -- Open picker
  vim.keymap.set('n', '<leader>ff', function() require('fzf-lua').files() end, { desc = '[F]ind [F]iles' })
  vim.keymap.set('n', '<leader>fo', function() require('fzf-lua').oldfiles() end, { desc = '[R]ecent [B]uffers' })
  vim.keymap.set('n', '<leader>fa', function() require('fzf-lua').autocmds() end, { desc = '[F]ind Neovim [A]uto-commands' })
  vim.keymap.set('n', '<leader>fw', function() require('fzf-lua').live_grep() end, { desc = '[F]ind [W]ord' })
  vim.keymap.set('n', '<leader>fc', function() require('fzf-lua').command_history() end, { desc = '[F]ind [C]ommands' })
  vim.keymap.set('n', '<leader>fb', function() require('fzf-lua').buffers() end, { desc = '[F]ind [B]uffers' })
  vim.keymap.set('n', '<leader>fn', function() require('fzf-lua').commands() end, { desc = '[F]ind Neovim [C]ommands' })
  vim.keymap.set('n', '<leader>fg', function() require('fzf-lua').git_files() end, { desc = '[F]ind [G]it Files' })
  vim.keymap.set('n', '<leader>glg', function() require('fzf-lua').git_commits() end, { desc = '[G]it [L]og Graph' })
  vim.keymap.set('n', '<leader>gst', function() require('fzf-lua').git_status() end, { desc = '[G]it [St]atus' })
  vim.keymap.set('n', '<leader>gsw', function() require('fzf-lua').git_branches() end, { desc = '[G]it [S]witch' })

  -- Toggle git blame
  vim.keymap.set('n', '<leader>gb', function() require('gitsigns').toggle_current_line_blame() end, { desc = 'Toggle [g]it [b]lame' })

  -- Toggle search and replace
  vim.keymap.set('n', '<leader>S', function() require('spectre').toggle() end, { desc = 'Toggle [S]pectre' })
  vim.keymap.set('n', '<leader>sw', function() require('spectre').open_visual { select_word = true } end, { desc = '[S]earch current [w]ord' })
  vim.keymap.set('v', '<leader>sw', function() require('spectre').open_visual() end, { desc = '[S]earch current [w]ord' })

  -- Toggle File Explorer
  vim.keymap.set('n', '<C-n>', function() require('nvim-tree.api').tree.toggle { focus = false } end, { desc = 'Toggle file explorer' })
  vim.keymap.set('n', '<leader>e', function() require('nvim-tree.api').tree.open() end, { desc = 'Focus file [e]xplorer' })

  -- Dismiss notifications
  vim.keymap.set('n', '<leader>nd', function() require('noice').cmd 'dismiss' end, { desc = 'Clear notifications' })

  ------------------------------------ Local Hotkeys ------------------------------------

  -- Open command line
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
  vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>write<CR>', { desc = '[S]ave file' })
  vim.keymap.set('n', '<leader>rr', '<cmd>restart<CR>', { desc = 'Reinitialize Neovim' })
  vim.keymap.set('n', '<leader>oo', function()
    vim.cmd 'silent! mksession! Session.vim'
    vim.notify('Updating workspace state: Session.vim', vim.log.levels.INFO)
  end, { desc = 'Save workspace config' })

  -- Buffers
  vim.keymap.set('n', '<leader>b', '<cmd>enew<CR>', { desc = 'Open [b]uffer' })
  vim.keymap.set('n', '<leader>x', '<cmd>bdelete<CR>', { desc = 'Close buffer' })
  vim.keymap.set('n', '<C-c>', '<cmd>%y+<CR>', { desc = '[C]opy file' })
  vim.keymap.set('n', '<Esc>', '<cmd>noh<CR>', { desc = 'Clear highlights' })

  -- Terminal
  vim.cmd.packadd 'terminal'
  local terminal = require 'terminal'

  vim.keymap.set('t', '<C-x>', '<C-\\><C-N>', { desc = 'Escape terminal mode' })
  vim.keymap.set('n', '<leader>h', function() terminal.open { pos = 'sp' } end, { desc = 'Open [h]orizontal terminal' })
  vim.keymap.set('n', '<leader>v', function() terminal.open { pos = 'vsp' } end, { desc = 'Open [v]ertical terminal' })
  vim.keymap.set({ 'n', 't' }, '<A-v>', function() terminal.toggle { pos = 'vsp', id = 'vtoggleTerm' } end, { desc = 'Toggle [v]ertical terminal' })
  vim.keymap.set({ 'n', 't' }, '<A-h>', function() terminal.toggle { pos = 'sp', id = 'htoggleTerm' } end, { desc = 'Toggle [h]orizontal terminal' })
  vim.keymap.set({ 'n', 't' }, '<A-i>', function() terminal.toggle { pos = 'float', id = 'floatTerm' } end, { desc = 'Toggle [f]loating terminal' })

  -- LSP
  vim.keymap.set('n', '<leader>ds', vim.diagnostic.setloclist, { desc = 'LSP diagnostic loclist' })

  -- Dashboard
  vim.keymap.set('n', '<leader>da', function() require('dashboard').setup() end, { desc = 'Toggle Dashboard' })
end)
