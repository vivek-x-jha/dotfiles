-- TODO add annotations
-- TODO fix git info only updating on reload
-- TODO fix lsp info only updating on reload
local M = {}
local utl = {}
local modules = {}
local api = vim.api
local b = vim.b
local bo = vim.bo
local diag = vim.diagnostic
local g = vim.g
local o = vim.o

local icn = require 'ui.icons'
local aucmd = require('configs.utils').create_auto_command
local augroup = require('configs.utils').create_auto_group

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

utl.state = { lsp_msg = '' }

-- 2nd item is highlight groupname St_NormalMode
utl.modes = {
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

--- Gets current buffer ID
--- @return integer
utl.stbufnr = function() return api.nvim_win_get_buf(g.statusline_winid or 0) end

--- Checks if statusline is on current window
---@return boolean
utl.is_activewin = function() return api.nvim_get_current_win() == g.statusline_winid end

--- Creates a formatted string for git modifications
--- @param opts GitMod Dictionary of git status count, highlight group, and icon
--- @return string
utl.git_mod_display = function(opts)
  --- @type integer Number of git modifications
  local cnt = opts.count or 0

  --- @type string Formatted git modification element
  local git_info = '%#' .. opts.hl .. '#' .. opts.icon .. tostring(cnt) .. ' %#Normal#%*'
  return cnt > 0 and git_info or ''
end

--- Creates a formatted string for LSP diagnostics
---@param opts LspDiag
---@return string
utl.lsp_diag_disp = function(opts)
  --- @type integer Buffer ID
  local bufnr = utl.stbufnr() or 0

  --- @type integer LSP diagnostic count
  local count = #diag.get(bufnr, { severity = diag.severity[opts.level] })

  --- @type string Formatted LSP diagnostic count
  local lsp_diag_info = '%#' .. opts.hl .. '#' .. opts.icon .. ' ' .. tostring(count) .. ' %#Normal#%*'

  return count > 0 and lsp_diag_info or ''
end

--- Creates statusline module: mode indicator
--- @return string
modules.mode = function()
  if not utl.is_activewin() then return '' end

  local modes = utl.modes
  local m = api.nvim_get_mode().mode
  return '%#St_' .. modes[m][2] .. 'mode#' .. ' ' .. modes[m][1] .. ' %#Normal#%*'
end

--- @class GitSignsStatus
--- @field added integer Number of added lines
--- @field changed integer Number of changed lines
--- @field removed integer Number of removed lines
--- @field head string Current branch name
--- @field root string Git repository root directory

--- Creates statusline module: git branch
--- @return string
modules.git_branch = function()
  --- @type integer Buffer ID
  local bufnr = utl.stbufnr() or 0

  if not b[bufnr].gitsigns_head or b[bufnr].gitsigns_git_status then return '' end

  --- @type GitSignsStatus Git status information for the buffer
  local git_status = b[bufnr].gitsigns_status_dict

  return '%#St_GitBranch# ' .. git_status.head .. ' '
end

--- Creates statusline module: language server name
--- @return string
modules.lsp = function()
  if rawget(vim, 'lsp') then
    for _, client in ipairs(vim.lsp.get_clients()) do
      if client.attached_buffers[utl.stbufnr()] then
        local server = o.columns > 100 and icn.gear .. ' ' .. client.name or icn.gear
        return '%#St_lsp#' .. server .. ' %#Normal#%*'
      end
    end
  end

  return ''
end

--- Creates statusline module: LSP diagnostics
--- @return string
modules.diagnostics = function()
  if not rawget(vim, 'lsp') then return '' end

  --- @type LspDiag[] Table of all LSP diagnostics
  local lsp_info = {
    { level = 'ERROR', hl = 'St_lspError', icon = icn.error },
    { level = 'WARN', hl = 'St_lspWarning', icon = icn.warn },
    { level = 'HINT', hl = 'St_lspHints', icon = icn.hint },
    { level = 'INFO', hl = 'St_lspInfo', icon = icn.info },
  }

  --- @type string[] Formatted statusline elements for each diagnostic
  local diagnostics_result = {}

  for _, diagnostic in ipairs(lsp_info) do
    table.insert(diagnostics_result, utl.lsp_diag_disp(diagnostic))
  end

  return table.concat(diagnostics_result)
end

--- Creates statusline module: current file
--- @return string
modules.file = function()
  local icon = icn.file
  local path = api.nvim_buf_get_name(utl.stbufnr())
  local empty = path == ''
  local nvimtree = bo.filetype:match '^NvimTree'
  local terminal = bo.buftype == 'terminal'

  -- Suppress
  if empty or nvimtree or terminal then return '' end

  local name = path:match '([^/\\]+)[/\\]*$'

  -- Replace icon with devicon
  local devicons_present, devicons = pcall(require, 'nvim-web-devicons')

  if devicons_present then
    local ft_icon = devicons.get_icon(name)
    icon = ft_icon ~= nil and ft_icon or icon
  end

  -- Format checks if any unsaved modifications
  local highlight = '%#St_file#' .. icon
  if bo.modified then highlight = '%#St_filemod#' .. icn.modified end

  return highlight .. ' ' .. name .. '%#Normal#%* '
end

--- Creates statusline module: git modification
--- @return string
modules.git_mod = function()
  --- @type integer Buffer ID
  local bufnr = utl.stbufnr() or 0

  if not b[bufnr].gitsigns_head or b[bufnr].gitsigns_git_status then return '' end

  --- @type GitSignsStatus Git status information for the buffer
  local git_status = b[bufnr].gitsigns_status_dict

  --- @type GitMod[] Table of all git add, changed, and removed modifications
  local statuses = {
    { count = git_status.added, hl = 'St_GitAdded', icon = '+' },
    { count = git_status.changed, hl = 'St_GitChanged', icon = '~' },
    { count = git_status.removed, hl = 'St_GitRemoved', icon = '-' },
  }

  --- @type string[] Formatted statusline elements for each modification type
  local git_mod_result = {}

  for _, mod in ipairs(statuses) do
    table.insert(git_mod_result, utl.git_mod_display(mod))
  end

  return table.concat(git_mod_result)
end

--- Creates statusline module: Separator
modules['%='] = '%='

--- Creates statusline module: LSP message
--- @return string
modules.lsp_msg = function() return o.columns > 100 and '%#St_lspMsg#' .. utl.state.lsp_msg .. '%#Normal#%*' or '' end

--- Creates statusline module: current working directory
--- @return string
modules.cwd = function()
  --- @type integer Max column size to display full path
  local col_threshold = 50

  --- @type string|nil Path name to display
  local path = vim.uv.cwd()

  -- handle nil path
  if not path then return '' end

  -- truncated cwd
  if #path > col_threshold then path = '.../' .. path:match '([^/\\]+)[/\\]*$' end

  return '%#St_cwd# ' .. path .. ' %#Normal#%*'
end

--- Creates statusline module: row and column counter
--- @return string
modules.cursor = function() return '%#St_cursor#' .. '󰓾 %l:%c' .. '%#Normal#%*' end

--- Aggregates all statusline modules
--- @return string
M.setup = function()
  --- @type string[] Aggregated statusline modules
  local statusline = {}

  for _, v in ipairs(orders) do
    --- @type string|function Statusline module to load
    local module = modules[v]

    --- @type string|function Formatted statusline module
    local stl_mod = type(module) == 'string' and module or module()

    table.insert(statusline, stl_mod)
  end

  return table.concat(statusline)
end

--- Creates auto comand to display LSP progress bar
M.autocmds = function()
  aucmd {
    desc = 'Show LSP Progress bar',
    group = augroup 'LspProgressAU',
    event = 'LspProgress',
    pattern = { 'begin', 'end' },
    callback = function(args)
      local data = args.data.params.value
      local progress = ''

      if data.percentage then
        local spinners = { '', '', '', '󰪞', '󰪟', '󰪠', '󰪢', '󰪣', '󰪤', '󰪥' }
        local idx = math.max(1, math.floor(data.percentage / 10))
        local icon = spinners[idx]
        progress = icon .. ' ' .. data.percentage .. '%% '
      end

      local str = progress .. (data.message or '') .. ' ' .. (data.title or '')
      utl.state.lsp_msg = data.kind == 'end' and '' or str
      vim.cmd.redrawstatus()
    end,
  }
end

return M
