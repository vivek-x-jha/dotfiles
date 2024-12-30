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
utl.stbufnr = function() return api.nvim_win_get_buf(g.statusline_winid or 0) end
utl.is_activewin = function() return api.nvim_get_current_win() == g.statusline_winid end

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

modules.mode = function()
  if not utl.is_activewin() then return '' end

  local modes = utl.modes
  local m = api.nvim_get_mode().mode
  return '%#St_' .. modes[m][2] .. 'mode#' .. ' ' .. modes[m][1] .. ' %#Normal#%*'
end

modules.git_branch = function()
  local bufnr = utl.stbufnr() or 0
  if not b[bufnr].gitsigns_head or b[bufnr].gitsigns_git_status then return '' end
  local git_status = b[bufnr].gitsigns_status_dict

  return '%#St_GitBranch# ' .. git_status.head .. ' '
end

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

modules.diagnostics = function()
  if not rawget(vim, 'lsp') then return '' end

  local disp_diag = function(level, hlgroup, icon)
    local bufnr = utl.stbufnr() or 0
    local cnt = #diag.get(bufnr, { severity = diag.severity[level] })
    local lsp_diagnostics = '%#' .. hlgroup .. '#' .. icon .. ' ' .. tostring(cnt) .. ' %#Normal#%*'

    return cnt > 0 and lsp_diagnostics or ''
  end

  local err = disp_diag('ERROR', 'St_lspError', icn.error)
  local warn = disp_diag('WARN', 'St_lspWarning', icn.warn)
  local hints = disp_diag('HINT', 'St_lspHints', icn.hint)
  local info = disp_diag('INFO', 'St_lspInfo', icn.info)

  return err .. warn .. hints .. info
end

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

--- @class GitSignsStatusTbl
--- @field added integer Number of added lines
--- @field changed integer Number of changed lines
--- @field removed integer Number of removed lines
--- @field head string Current branch name
--- @field root string Git repository root directory

--- Creates statusline module: git modification
--- @return string Formatted git modifications for statusline
modules.git_mod = function()
  --- @type integer Buffer ID
  local bufnr = utl.stbufnr() or 0
  if not b[bufnr].gitsigns_head or b[bufnr].gitsigns_git_status then return '' end

  --- @type GitSignsStatusTbl Git status information for the buffer
  local git_status = b[bufnr].gitsigns_status_dict

  --- @class GitModTbl
  --- @field count integer Number of git modifications
  --- @field hl string Highlight group suffix for styling
  --- @field icon string Symbol representing the type of modification

  --- Creates a formatted string for git modifications
  --- @param opts GitModTbl Dictionary of git status count, highlight group, and icon
  --- @return string Formatted string for a git modification
  local disp_changes = function(opts)
    --- @type integer Number of git modifications
    local cnt = opts.count or 0
    --- @type string Formatted git modification element
    local git_info = '%#' .. opts.hl .. '#' .. opts.icon .. tostring(cnt) .. ' %#Normal#%*'
    return cnt > 0 and git_info or ''
  end

  --- @type GitModTbl[] Table of all git add, changed, and removed modifications
  local statuses = {
    { count = git_status.added, hl = 'St_GitAdded', icon = '+' },
    { count = git_status.changed, hl = 'St_GitChanged', icon = '~' },
    { count = git_status.removed, hl = 'St_GitRemoved', icon = '-' },
  }

  --- @type string[] Formatted statusline elements for each modification type
  local git_mod_result = {}

  for _, mod in ipairs(statuses) do
    table.insert(git_mod_result, disp_changes(mod))
  end

  return table.concat(git_mod_result)
end

modules['%='] = '%='

modules.lsp_msg = function() return o.columns > 100 and '%#St_lspMsg#' .. utl.state.lsp_msg .. '%#Normal#%*' or '' end

modules.cwd = function()
  local name = vim.uv.cwd()
  if not name then return '' end

  name = '%#St_cwd# ' .. (name:match '([^/\\]+)[/\\]*$' or name) .. ' %#Normal#%*'
  return o.columns > 85 and name or ''
end

modules.cursor = function() return '%#St_cursor#' .. '󰓾 %l:%c' .. '%#Normal#%*' end

M.setup = function()
  local result = {}

  for _, v in ipairs(orders) do
    local module = modules[v]
    module = type(module) == 'string' and module or module()
    table.insert(result, module)
  end

  return table.concat(result)
end

M.autocmds = function()
  api.nvim_create_autocmd('LspProgress', {
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
  })
end

return M
