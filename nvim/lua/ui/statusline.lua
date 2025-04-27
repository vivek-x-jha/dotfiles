--- @type table Custom icons
local icons = require 'ui.icons'

--- @type table Store state of any LSP messages
local lspmsg = { lsp_msg = '' }

--- @type fun(): integer Statusline Buffer id
local stbufnr = function() return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0) or 0 end

--- @class StatusLineModules
--- @field mode fun(): string Creates statusline module: mode indicator
--- @field git_branch fun(): string Creates statusline module: git branch
--- @field lsp fun(): string Creates statusline module: language server name
--- @field diagnostics fun(): string Creates statusline module: LSP diagnostics
--- @field file fun(): string Creates statusline module: current file
--- @field git_diff fun(): string Creates statusline module: git diff
--- @field lsp_msg fun(): string Creates statusline module: LSP message
--- @field cwd fun(): string Creates statusline module: current working directory
--- @field git_status fun(): string Creates statusline module: project git status
--- @field cursor fun(): string Creates statusline module: row and column counter
local modules = {
  mode = function()
    if not vim.api.nvim_get_current_win() == vim.g.statusline_winid then return '' end

    --- @type string[] 2nd item is highlight groupname St_NormalMode
    local modes = {
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
    }

    --- @type string[2] Vim mode and highlight group
    local vmode = modes[vim.api.nvim_get_mode().mode]

    return table.concat { '%#St_', vmode[2], 'mode#', icons.vim, ' ', vmode[1], ' ', '%#Normal#%*' }
  end,

  git_branch = function()
    --- @type table Current buffer options
    local buf = vim.b[stbufnr()]

    -- Check if it's not a Git repository
    if not buf.gitsigns_head or buf.gitsigns_git_status then return '' end

    return table.concat { '%#St_GitBranch#', icons.branch, ' ', buf.gitsigns_head, ' ', '%#Normal#%*' }
  end,

  lsp = function()
    if rawget(vim, 'lsp') then
      for _, client in ipairs(vim.lsp.get_clients()) do
        if client.attached_buffers[stbufnr()] then return table.concat { '%#St_lsp#', icons.gear, ' ', client.name, ' ', '%#Normal#%*' } end
      end
    end

    return ''
  end,

  diagnostics = function()
    if not rawget(vim, 'lsp') then return '' end

    --- @type string[] Formatted statusline elements for each diagnostic
    local lsp_diagnostics = {}

    --- @type table LSP diagnostics
    local lsp_info = {
      { level = 'ERROR', hl = '%#St_lspError#', icon = icons.error },
      { level = 'WARN', hl = '%#St_lspWarning#', icon = icons.warn },
      { level = 'HINT', hl = '%#St_lspHints#', icon = icons.hint },
      { level = 'INFO', hl = '%#St_lspInfo#', icon = icons.info },
    }

    for _, opts in ipairs(lsp_info) do
      --- @type integer Current buffer id
      local bufid = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0) or 0

      --- @type integer Number of LSP diagnostics for given `level`
      local count = #vim.diagnostic.get(bufid, { severity = vim.diagnostic.severity[opts.level] })

      --- @type string Formatted diagnostic entry
      local diagnostic = table.concat { opts.hl, opts.icon, ' ', count, ' ', '%#Normal#%*' }

      if count > 0 then table.insert(lsp_diagnostics, diagnostic) end
    end

    return table.concat(lsp_diagnostics)
  end,

  file = function()
    --- @type string Absolute path of current buffer
    local path = vim.api.nvim_buf_get_name(stbufnr())

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
    local hl_icon = vim.bo.modified and '%#St_filemod#' .. icons.modified or '%#St_file#' .. icon

    return table.concat { hl_icon, ' ', name, '%#Normal#%*', ' ' }
  end,

  git_diff = function()
    --- @type string[] Formatted statusline elements for each modification type
    local modifications = {}

    --- @type table Current buffer options
    local buf = vim.b[stbufnr()]

    -- Check if it's not a Git repository
    if not buf.gitsigns_head or buf.gitsigns_git_status then return '' end

    --- @type table All git add, changed, and removed modifications
    local statuses = {
      { cnt = buf.gitsigns_status_dict.added, hl = '%#St_GitAdded#', icon = '+' },
      { cnt = buf.gitsigns_status_dict.changed, hl = '%#St_GitChanged#', icon = '~' },
      { cnt = buf.gitsigns_status_dict.removed, hl = '%#St_GitRemoved#', icon = '-' },
    }

    for _, mod in ipairs(statuses) do
      --- @type integer Number of git modifications
      local count = mod.cnt or 0

      if count > 0 then
        --- @type string Formatted git modification
        local status = table.concat { mod.hl, mod.icon, count, ' ', '%#Normal#%*' }

        table.insert(modifications, status)
      end
    end

    return table.concat(modifications)
  end,

  lsp_msg = function() return table.concat { '%#St_lspMsg#', lspmsg.lsp_msg, '%#Normal#%*' } end,

  cwd = function()
    --- @type integer Max column size to display full path
    local threshold = 70

    --- @type string|nil Path name to display
    local path = vim.uv.cwd()

    -- handle nil path
    if not path then return '' end

    -- substitute $HOME with ~
    path = path:gsub('^' .. vim.env.HOME, '~')

    -- truncated cwd
    if #path > threshold then path = '.../' .. path:match '([^/\\]+)[/\\]*$' end

    return table.concat { '%#St_cwd#', icons.folder, ' ', path, ' ', '%#Normal#%*' }
  end,

  -- FIX does not aggregate exactly the same as powerlevel10k git status
  git_status = function()
    -- Check if inside a Git repository
    local git_dir = vim.fn.systemlist('git rev-parse --is-inside-work-tree')[1]
    if git_dir ~= 'true' then return '' end

    --- @type integer Number of changes in various git categories
    local ahead, behind, staged, modified, untracked, conflicted = 0, 0, 0, 0, 0, 0

    -- Get ahead/behind info
    local upstream = vim.fn.systemlist('git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null')[1]
    if upstream then
      local a, b = upstream:match '(%d+)%s+(%d+)'
      ahead = tonumber(a) or 0
      behind = tonumber(b) or 0
    end

    -- Get git status summary
    local status_output = vim.fn.systemlist 'git status --porcelain=v1 2>/dev/null'
    for _, line in ipairs(status_output) do
      local code = line:sub(1, 2)

      if code:match '^M' or code:match '^A' or code:match '^D' then
        staged = staged + 1
      elseif code:match '^.M' or code:match '^.D' then
        modified = modified + 1
      elseif code:match '^??' then
        untracked = untracked + 1
      elseif code:match '^UU' or code:match '^AA' or code:match '^DD' then
        conflicted = conflicted + 1
      end
    end

    --- @type table All Git statuses counts, highlights, and icons
    local statuses = {
      { cnt = ahead, hl = '%#St_GitAhead#', icon = icons.up .. ' ' },
      { cnt = behind, hl = '%#St_GitBehind#', icon = icons.down .. ' ' },
      { cnt = staged, hl = '%#St_GitAdded#', icon = '+' },
      { cnt = modified, hl = '%#St_GitChanged#', icon = '~' },
      { cnt = untracked, hl = '%#St_GitUntracked#', icon = '?' },
      { cnt = conflicted, hl = '%#St_GitConflicted#', icon = '!' },
    }

    --- @type string[] Formatted statusline elements for each git status category
    local git_elements = {}

    for _, status in ipairs(statuses) do
      --- @type integer Number of occurrences for the given Git status
      local count = status.cnt or 0

      if count > 0 then
        --- @type string Formatted git status element
        local formatted_git_status = table.concat { status.hl, status.icon, count, ' ', '%#Normal#%*' }

        table.insert(git_elements, formatted_git_status)
      end
    end

    return table.concat(git_elements)
  end,

  cursor = function() return table.concat { '%#St_cursor#', icons.cursor, ' ', '%l:%c', '%#Normal#%*' } end,
}

--- @class StatusLine
--- @field setup fun(): string Aggregates all statusline modules
local M = {}

M.state = lspmsg

M.setup = function()
  --- @type string[] Aggregated statusline modules
  local statusline = {}

  --- @type boolean flag for terminal mode
  local is_term_buf = vim.tbl_contains({ 't', 'nt' }, vim.api.nvim_get_mode().mode)

  --- @type boolean flag if current buffer is specre search & replace
  local is_spectre_buf = vim.bo.filetype == 'spectre_panel'

  --- @type string[] Order of statusline modules
  local module_order = (is_term_buf or is_spectre_buf) and { 'mode', '%=', 'cwd', 'cursor' }
    or { 'mode', 'git_branch', 'git_status', 'file', 'git_diff', '%=', 'lsp_msg', '%=', 'diagnostics', 'lsp', 'cwd', 'cursor' }

  -- Construct the statusline elements
  for _, mod in ipairs(module_order) do
    table.insert(statusline, mod == '%=' and mod or modules[mod]())
  end

  return table.concat(statusline)
end

return M
