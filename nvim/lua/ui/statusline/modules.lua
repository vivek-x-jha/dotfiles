local api = vim.api
local bo = vim.bo
local icn = require 'ui.icons'
local utl = require 'ui.statusline.utils'

--- Modules to be loaded by statusline
--- @type StatusLineModules
return {
  mode = function()
    if not utl.is_activewin() then return '' end

    --- @type {[1]: string, [2]: string} Vim mode and highlight group
    local m = utl.modes[api.nvim_get_mode().mode]

    return table.concat { '%#St_', m[2], 'mode#', ' ', m[1], ' %#Normal#%*' }
  end,

  git_branch = function()
    --- @type boolean, GitSignsStatus Git status information for the buffer
    local is_repo, git_status = utl:gitsigns_status()

    if not is_repo then return '' end

    return table.concat { '%#St_GitBranch# ', git_status.head, ' %#Normal#%*' }
  end,

  lsp = function()
    if rawget(vim, 'lsp') then
      for _, client in ipairs(vim.lsp.get_clients()) do
        if client.attached_buffers[utl.stbufnr()] then return table.concat { '%#St_lsp#', icn.gear, ' ', client.name, ' %#Normal#%*' } end
      end
    end

    return ''
  end,

  diagnostics = function()
    if not rawget(vim, 'lsp') then return '' end

    --- @type string[] Formatted statusline elements for each diagnostic
    local diagnostics_result = {}

    --- @type LspDiagnostic[] Table of all LSP diagnostics
    local lsp_info = {
      { level = 'ERROR', hl = 'St_lspError', icon = icn.error },
      { level = 'WARN', hl = 'St_lspWarning', icon = icn.warn },
      { level = 'HINT', hl = 'St_lspHints', icon = icn.hint },
      { level = 'INFO', hl = 'St_lspInfo', icon = icn.info },
    }

    for _, diagnostic in ipairs(lsp_info) do
      table.insert(diagnostics_result, utl:lsp_diag_disp(diagnostic))
    end

    return table.concat(diagnostics_result)
  end,

  file = function()
    --- @type string Absolute path of current buffer
    local path = api.nvim_buf_get_name(utl.stbufnr())

    --- @type boolean[] Conditions to suppress file info
    local suppress = {
      path == '', -- empty buffer
      bo.buftype == 'terminal', -- terminal
      bo.buftype == 'nofile', -- buffer unrelated to file
    }

    -- Hide if buffer matches supress condition
    if vim.tbl_contains(suppress, true) then return '' end

    --- @type string Filename
    local name = path:match '([^/\\]+)[/\\]*$'

    --- @type boolean, table
    local devicons_present, devicons = pcall(require, 'nvim-web-devicons')

    --- @type string Replace with devicon
    local icon = devicons_present and devicons.get_icon(name) or icn.file

    --- @type string Highlight and icon conditional on modified buffer
    local highlight = bo.modified and '%#St_filemod#' .. icn.modified or '%#St_file#' .. icon

    return table.concat { highlight, ' ', name, '%#Normal#%* ' }
  end,

  git_mod = function()
    --- @type boolean, GitSignsStatus Git status information for the buffer
    local is_repo, git_status = utl:gitsigns_status()

    if not is_repo then return '' end

    --- @type GitModification[] Table of all git add, changed, and removed modifications
    local statuses = {
      { cnt = git_status.added, hl = 'St_GitAdded', icon = '+' },
      { cnt = git_status.changed, hl = 'St_GitChanged', icon = '~' },
      { cnt = git_status.removed, hl = 'St_GitRemoved', icon = '-' },
    }

    --- @type string[] Formatted statusline elements for each modification type
    local git_mod_result = {}

    for _, mod in ipairs(statuses) do
      table.insert(git_mod_result, utl.git_mod_display(mod))
    end

    return table.concat(git_mod_result)
  end,

  sep = '%=',

  lsp_msg = function() return table.concat { '%#St_lspMsg#', utl.state.lsp_msg, '%#Normal#%*' } end,

  cwd = function()
    --- @type integer Max column size to display full path
    local col_threshold = 70

    --- @type string|nil Path name to display
    local path = vim.uv.cwd()

    -- handle nil path
    if not path then return '' end

    -- truncated cwd
    if #path > col_threshold then path = '.../' .. path:match '([^/\\]+)[/\\]*$' end

    return table.concat { '%#St_cwd# ', path, ' %#Normal#%*' }
  end,

  cursor = function() return '%#St_cursor#' .. '󰓾 %l:%c' .. '%#Normal#%*' end,
}
