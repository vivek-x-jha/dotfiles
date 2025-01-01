local api = vim.api
local g = vim.g

--- @type StatusLineUtils
return {
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

  stbufnr = function() return api.nvim_win_get_buf(g.statusline_winid or 0) or 0 end,

  is_activewin = function() return api.nvim_get_current_win() == g.statusline_winid end,

  gitsigns_status = function(self)
    --- @type table Current buffer options
    local buf = vim.b[self:stbufnr()]

    --- @type boolean Flag if a git repository
    local is_repo = true

    -- Check if it's not a Git repository
    if not buf.gitsigns_head or buf.gitsigns_git_status then is_repo = false end

    return is_repo, buf.gitsigns_status_dict
  end,

  git_mod_display = function(opts)
    --- @type integer Number of git modifications
    local count = opts.cnt or 0

    -- Surpress when none exist
    if count == 0 then return '' end

    return table.concat { '%#', opts.hl, '#', opts.icon, tostring(count), ' %#Normal#%*' }
  end,

  lsp_diag_disp = function(self, opts)
    local diag = vim.diagnostic

    --- @type integer Buffer ID
    local bufnr = self:stbufnr()

    --- @type integer Number of LSP diagnostics for given `level`
    local count = #diag.get(bufnr, { severity = diag.severity[opts.level] })

    -- Surpress when none exist
    if count == 0 then return '' end

    return table.concat { '%#', opts.hl, '#', opts.icon, ' ', tostring(count), ' %#Normal#%*' }
  end,
}
