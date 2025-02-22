local icons = require 'ui.icons'

--- @type StatusLineUtils Utility functions used to generate statusline modules
local utl = {
  state = { lsp_msg = '' },

  -- 2nd item is highlight groupname St_NormalMode
  modes = {
    ['n'] = { 'NORMAL', 'Normal' },
    ['no'] = { 'NORMAL (no)', 'Normal' },
    ['nov'] = { 'NORMAL (nov)', 'Normal' },
    ['noV'] = { 'NORMAL (noV)', 'Normal' },
    ['noCTRL-V'] = { 'NORMAL', 'Normal' },
    ['niI'] = { 'NORMAL i', 'Normal' },
    ['niR'] = { 'NORMAL r', 'Normal' },
    ['niV'] = { 'NORMAL v', 'Normal' },
    ['nt'] = { 'NTERMINAL', 'NTerminal' },
    ['ntT'] = { 'NTERMINAL (ntT)', 'NTerminal' },

    ['v'] = { 'VISUAL', 'Visual' },
    ['vs'] = { 'V-CHAR (Ctrl O)', 'Visual' },
    ['V'] = { 'V-LINE', 'Visual' },
    ['Vs'] = { 'V-LINE', 'Visual' },
    [''] = { 'V-BLOCK', 'Visual' },

    ['i'] = { 'INSERT', 'Insert' },
    ['ic'] = { 'INSERT (completion)', 'Insert' },
    ['ix'] = { 'INSERT completion', 'Insert' },

    ['t'] = { 'TERMINAL', 'Terminal' },

    ['R'] = { 'REPLACE', 'Replace' },
    ['Rc'] = { 'REPLACE (Rc)', 'Replace' },
    ['Rx'] = { 'REPLACEa (Rx)', 'Replace' },
    ['Rv'] = { 'V-REPLACE', 'Replace' },
    ['Rvc'] = { 'V-REPLACE (Rvc)', 'Replace' },
    ['Rvx'] = { 'V-REPLACE (Rvx)', 'Replace' },

    ['s'] = { 'SELECT', 'Select' },
    ['S'] = { 'S-LINE', 'Select' },
    [''] = { 'S-BLOCK', 'Select' },
    ['c'] = { 'COMMAND', 'Command' },
    ['cv'] = { 'COMMAND', 'Command' },
    ['ce'] = { 'COMMAND', 'Command' },
    ['cr'] = { 'COMMAND', 'Command' },
    ['r'] = { 'PROMPT', 'Confirm' },
    ['rm'] = { 'MORE', 'Confirm' },
    ['r?'] = { 'CONFIRM', 'Confirm' },
    ['x'] = { 'CONFIRM', 'Confirm' },
    ['!'] = { 'SHELL', 'Terminal' },
  },

  stbufnr = function() return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0) or 0 end,

  gitsigns_status = function(self)
    --- @type table Current buffer options
    local buf = vim.b[self:stbufnr()]

    --- @type boolean Flag if a git repository
    local is_repo = true

    -- Check if it's not a Git repository
    if not buf.gitsigns_head or buf.gitsigns_git_status then is_repo = false end

    return is_repo, buf.gitsigns_status_dict
  end,
}

--- Modules to be loaded by statusline
--- @type StatusLineModules
local modules = {
  mode = function()
    if not vim.api.nvim_get_current_win() == vim.g.statusline_winid then return '' end

    --- @type string[2] Vim mode and highlight group
    local vmode = utl.modes[vim.api.nvim_get_mode().mode]

    return table.concat { '%#St_', vmode[2], 'mode#', icons.vim, ' ', vmode[1], ' ', '%#Normal#%*' }
  end,

  git_branch = function()
    --- @type boolean, GitSignsStatus Git status information for the buffer
    local is_repo, git_status = utl:gitsigns_status()

    if not is_repo then return '' end

    return table.concat { '%#St_GitBranch#', icons.branch, ' ', git_status.head, ' ', '%#Normal#%*' }
  end,

  lsp = function()
    if rawget(vim, 'lsp') then
      for _, client in ipairs(vim.lsp.get_clients()) do
        if client.attached_buffers[utl:stbufnr()] then return table.concat { '%#St_lsp#', icons.gear, ' ', client.name, ' ', '%#Normal#%*' } end
      end
    end

    return ''
  end,

  diagnostics = function()
    if not rawget(vim, 'lsp') then return '' end

    --- @type LspDiagnostic[] Table of all LSP diagnostics
    local lsp_info = {
      { level = 'ERROR', hl = '%#St_lspError#', icon = icons.error },
      { level = 'WARN', hl = '%#St_lspWarning#', icon = icons.warn },
      { level = 'HINT', hl = '%#St_lspHints#', icon = icons.hint },
      { level = 'INFO', hl = '%#St_lspInfo#', icon = icons.info },
    }

    --- @type integer Current buffer id
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0) or 0

    --- @type string[] Formatted statusline elements for each diagnostic
    local diagnostics_result = {}

    for _, opts in ipairs(lsp_info) do
      --- @type integer Number of LSP diagnostics for given `level`
      local count = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity[opts.level] })

      --- @type string Formatted diagnostic entry
      local formatted_lsp_info = table.concat { opts.hl, opts.icon, ' ', tostring(count), ' ', '%#Normal#%*' }

      if count > 0 then table.insert(diagnostics_result, formatted_lsp_info) end
    end

    return table.concat(diagnostics_result)
  end,

  file = function()
    --- @type string Absolute path of current buffer
    local path = vim.api.nvim_buf_get_name(utl:stbufnr())

    --- @type boolean[] Conditions to suppress file info
    local suppress = {
      path == '', -- empty buffer
      vim.bo.buftype == 'terminal', -- terminal
      vim.bo.buftype == 'nofile', -- buffer unrelated to file
    }

    -- Hide if buffer matches supress condition
    if vim.tbl_contains(suppress, true) then return '' end

    --- @type string Filename
    local name = path:match '([^/\\]+)[/\\]*$'

    --- @type boolean, table
    local devicons_present, devicons = pcall(require, 'nvim-web-devicons')

    --- @type string Replace with devicon
    local icon = devicons_present and devicons.get_icon(name) or icons.file

    --- @type string Highlight and icon conditional on modified buffer
    local highlight = vim.bo.modified and '%#St_filemod#' .. icons.modified or '%#St_file#' .. icon

    return table.concat { highlight, ' ', name, '%#Normal#%*', ' ' }
  end,

  git_mod = function()
    --- @type boolean, GitSignsStatus Git status information for the buffer
    local is_repo, git_status = utl:gitsigns_status()

    if not is_repo then return '' end

    --- @type GitModification[] Table of all git add, changed, and removed modifications
    local statuses = {
      { cnt = git_status.added, hl = '%#St_GitAdded#', icon = '+' },
      { cnt = git_status.changed, hl = '%#St_GitChanged#', icon = '~' },
      { cnt = git_status.removed, hl = '%#St_GitRemoved#', icon = '-' },
    }

    --- @type string[] Formatted statusline elements for each modification type
    local modifications = {}

    for _, mod in ipairs(statuses) do
      --- @type integer Number of git modifications
      local count = mod.cnt or 0

      --- @type string Formatted git modification
      local formatted_git_mod = table.concat { mod.hl, mod.icon, tostring(count), ' ', '%#Normal#%*' }

      if count > 0 then table.insert(modifications, formatted_git_mod) end
    end

    return table.concat(modifications)
  end,

  lsp_msg = function() return table.concat { '%#St_lspMsg#', utl.state.lsp_msg, '%#Normal#%*' } end,

  cwd = function()
    --- @type integer Max column size to display full path
    local col_threshold = 70

    --- @type string|nil Path name to display
    local path = vim.uv.cwd()

    -- handle nil path
    if not path then return '' end

    -- substitute $HOME with ~
    path = path:gsub('^' .. vim.env.HOME, '~')

    -- truncated cwd
    if #path > col_threshold then path = '.../' .. path:match '([^/\\]+)[/\\]*$' end

    return table.concat { '%#St_cwd#', icons.folder, ' ', path, ' ', '%#Normal#%*' }
  end,

  cursor = function() return table.concat { '%#St_cursor#', icons.cursor, ' ', '%l:%c', '%#Normal#%*' } end,
}

--- @type StatusLine Generates all statusline modules and auto commands
return {
  state = utl.state,

  setup = function()
    --- @type string[] Order of statusline modules
    local orders = {
      'mode',
      'git_branch',
      'lsp',
      'diagnostics',
      'file',
      'git_mod',
      '%=',
      'lsp_msg',
      '%=',
      'cwd',
      'cursor',
    }

    --- @type string[] Aggregated statusline modules
    local statusline = {}

    for _, mod in ipairs(orders) do
      table.insert(statusline, mod == '%=' and mod or modules[mod]())
    end

    return table.concat(statusline)
  end,
}
