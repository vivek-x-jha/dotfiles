--- @class StatusLine
--- @field setup fun(): string Aggregates all statusline modules
local M = {}

--- @type table<string, string> Custom icons
local icons = require 'icons'

--- @type table Store state of any LSP messages
local lspmsg = { lsp_msg = '' }

--- @type fun(): integer Statusline Buffer id
local stbufnr = function() return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0) or 0 end

--- @class StatusLineModules
--- @field mode fun(): string
--- @field git_branch fun(): string
--- @field lsp fun(): string
--- @field diagnostics fun(): string
--- @field file fun(): string
--- @field git_diff fun(): string
--- @field lsp_msg fun(): string
--- @field cwd fun(): string
--- @field git_status fun(): string
--- @field cursor fun(): string
local modules = {
  mode = function()
    if not vim.api.nvim_get_current_win() == vim.g.statusline_winid then return '' end

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

    local vmode = modes[vim.api.nvim_get_mode().mode]
    return table.concat { '%#St_', vmode[2], 'mode#', icons.vim, ' ', vmode[1], ' ', '%#Normal#%*' }
  end,

  git_branch = function()
    local buf = vim.b[stbufnr()]
    return buf.gitsigns_head and table.concat { '%#St_GitBranch#', icons.branch, ' ', buf.gitsigns_head, ' ', '%#Normal#%*' } or ''
  end,

  lsp = function()
    for _, client in ipairs(vim.lsp.get_clients()) do
      if client.attached_buffers[stbufnr()] then return table.concat { '%#St_lsp#', icons.lightbulb, ' ', client.name, ' ', '%#Normal#%*' } end
    end

    return ''
  end,

  diagnostics = function()
    local lsp_diagnostics = {}
    local lsp_info = {
      { level = 'ERROR', text = '%#St_lspError#E ' },
      { level = 'WARN', text = '%#St_lspWarning#W ' },
      { level = 'HINT', text = '%#St_lspHints#H ' },
      { level = 'INFO', text = '%#St_lspInfo#I ' },
    }
    local bufid = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0) or 0

    for _, opts in ipairs(lsp_info) do
      local count = #vim.diagnostic.get(bufid, { severity = vim.diagnostic.severity[opts.level] })
      if count > 0 then table.insert(lsp_diagnostics, table.concat { opts.text, count, '%#Normal#%* ' }) end
    end

    return table.concat(lsp_diagnostics)
  end,

  file = function()
    local path = vim.api.nvim_buf_get_name(stbufnr())
    local suppress = {
      path == '',
      vim.bo.buftype == 'terminal',
      vim.bo.buftype == 'nofile',
    }

    if vim.tbl_contains(suppress, true) then return '' end

    local name = path:match '([^/\\]+)[/\\]*$'
    local devicons_present, devicons = pcall(require, 'nvim-web-devicons')
    local icon = devicons_present and devicons.get_icon(name) or icons.file
    local hl_icon = vim.bo.modified and '%#St_filemod#' .. icons.modified or '%#St_file#' .. icon

    return table.concat { hl_icon, ' ', name, '%#Normal#%*', ' ' }
  end,

  git_diff = function()
    local modifications = {}
    local buf = vim.b[stbufnr()]

    if not buf.gitsigns_head or buf.gitsigns_git_status then return '' end

    local statuses = {
      { cnt = buf.gitsigns_status_dict.added, hl = '%#St_GitAdded#', icon = '+' },
      { cnt = buf.gitsigns_status_dict.changed, hl = '%#St_GitChanged#', icon = '~' },
      { cnt = buf.gitsigns_status_dict.removed, hl = '%#St_GitRemoved#', icon = '-' },
    }

    for _, mod in ipairs(statuses) do
      local count = mod.cnt or 0
      if count > 0 then table.insert(modifications, table.concat { mod.hl, mod.icon, count, ' ', '%#Normal#%*' }) end
    end

    return table.concat(modifications)
  end,

  lsp_msg = function() return table.concat { '%#St_lspMsg#', lspmsg.lsp_msg, '%#Normal#%*' } end,

  cwd = function()
    local threshold = 70
    local path = vim.uv.cwd()
    if not path then return '' end

    path = path:gsub('^' .. vim.env.HOME, '~')
    if #path > threshold then path = '.../' .. path:match '([^/\\]+)[/\\]*$' end

    return table.concat { '%#St_cwd#', icons.folder, ' ', path, ' ', '%#Normal#%*' }
  end,

  git_status = function()
    local git_dir = vim.fn.systemlist('git rev-parse --is-inside-work-tree')[1]
    if git_dir ~= 'true' then return '' end

    local ahead, behind, staged, modified, untracked, conflicted = 0, 0, 0, 0, 0, 0
    local upstream = vim.fn.systemlist('git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null')[1]

    if upstream then
      local a, b = upstream:match '(%d+)%s+(%d+)'
      ahead = tonumber(a) or 0
      behind = tonumber(b) or 0
    end

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

    local statuses = {
      { cnt = ahead, hl = '%#St_GitAhead#', icon = icons.up .. ' ' },
      { cnt = behind, hl = '%#St_GitBehind#', icon = icons.down .. ' ' },
      { cnt = staged, hl = '%#St_GitAdded#', icon = '+' },
      { cnt = modified, hl = '%#St_GitChanged#', icon = '~' },
      { cnt = untracked, hl = '%#St_GitUntracked#', icon = '?' },
      { cnt = conflicted, hl = '%#St_GitConflicted#', icon = '!' },
    }
    local git_elements = {}

    for _, status in ipairs(statuses) do
      local count = status.cnt or 0
      if count > 0 then table.insert(git_elements, table.concat { status.hl, status.icon, count, ' ', '%#Normal#%*' }) end
    end

    return table.concat(git_elements)
  end,

  cursor = function() return table.concat { '%#St_cursor#', icons.cursor, ' ', '%l:%c', '%#Normal#%*' } end,
}

M.state = lspmsg

M.setup = function()
  local statusline = {}
  local is_term_buf = vim.tbl_contains({ 't', 'nt' }, vim.api.nvim_get_mode().mode)
  local term_buf_mods = { 'mode', '%=', 'cwd', 'cursor' }

  local default_mods = {
    'mode',
    'git_branch',
    'git_status',
    'file',
    'git_diff',
    '%=',
    'lsp_msg',
    '%=',
    'diagnostics',
    'lsp',
    'cwd',
    'cursor',
  }

  for _, mod in ipairs(is_term_buf and term_buf_mods or default_mods) do
    table.insert(statusline, mod == '%=' and mod or modules[mod]())
  end

  return table.concat(statusline)
end

return M
