---@class NvTerminal
---@field save fun(index: integer|string, val: TermRecord)
---@field setup fun(opts: TermSetupOpts)
---@field open fun(opts: TermOpenOpts)
---@field toggle fun(opts: TermToggleOpts)
---@field runner fun(opts: TermRunnerOpts)
local M = {}

---@type table<string, TermRecord>
vim.g.terminals = {}

-- used for initially resizing terms
---@type boolean
vim.g.nvhterm = false
---@type boolean
vim.g.nvvterm = false

---@class TerminalUtils
---@field opts_to_id fun(id: any): (TermRecord|nil)
---@field format_cmd fun(cmd: string|fun():string): string
local utl = {
  opts_to_id = function(id)
    for _, opts in pairs(vim.g.terminals) do
      if opts.id == id then return opts end
    end
  end,

  format_cmd = function(cmd) return type(cmd) == 'string' and cmd or cmd() end,
}

--- Persist a terminal record by buffer/index
--- @param index integer|string
--- @param val TermRecord
M.save = function(index, val)
  ---@type table<string, TermRecord>
  local terms_list = vim.g.terminals
  terms_list[tostring(index)] = val
  vim.g.terminals = terms_list
end

--- Create window, set up options, resize as needed, and record the terminal
--- @param opts TermSetupOpts
M.setup = function(opts)
  -- Controls floating terminal opts
  if opts.pos == 'float' then
    ---@type FloatOpts
    local default_float_opts = {
      relative = 'editor',
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
    }

    ---@type table<string, any>
    local newopts = vim.tbl_deep_extend('force', default_float_opts, opts.float_opts or {})

    newopts.width = math.ceil(newopts.width * vim.o.columns)
    newopts.height = math.ceil(newopts.height * vim.o.lines)
    newopts.row = math.ceil(newopts.row * vim.o.lines)
    newopts.col = math.ceil(newopts.col * vim.o.columns)

    vim.api.nvim_open_win(opts.buf, true, newopts)
  else
    vim.cmd(opts.pos)
  end

  ---@type integer
  local win = vim.api.nvim_get_current_win()
  opts.win = win
  ---@cast opts TermRecord

  vim.bo[opts.buf].buflisted = false
  vim.bo[opts.buf].ft = 'NvTerm_' .. opts.pos:gsub(' ', '')
  vim.cmd 'startinsert'

  -- Resize non-floating wins initially + or only when they're toggleable
  if (opts.pos == 'sp' and not vim.g.nvhterm) or (opts.pos == 'vsp' and not vim.g.nvvterm) or (opts.pos ~= 'float') then
    ---@type table<TermPos, { resize: 'height'|'width', area: 'lines'|'columns' }>
    local pos_data = {
      sp = { resize = 'height', area = 'lines' },
      vsp = { resize = 'width', area = 'columns' },
      ['bo sp'] = { resize = 'height', area = 'lines' },
      ['bo vsp'] = { resize = 'width', area = 'columns' },
    }

    ---@type { resize: 'height'|'width', area: 'lines'|'columns' }
    local pos_type = pos_data[opts.pos]

    ---@type table<TermPos, number>
    local default_split_opts = { sp = 0.3, vsp = 0.2, ['bo sp'] = 0.3, ['bo vsp'] = 0.2 }

    ---@type number
    local size = opts.size and opts.size or default_split_opts[opts.pos]
    ---@type number
    local new_size = vim.o[pos_type.area] * size
    vim.api['nvim_win_set_' .. pos_type.resize](0, math.floor(new_size))
  end

  vim.api.nvim_win_set_buf(win, opts.buf)

  ---@type table<string, boolean>
  local default_winopts = { number = false, relativenumber = false }
  ---@type table<string, any>
  local winopts = vim.tbl_deep_extend('force', default_winopts, opts.winopts or {})

  for k, v in pairs(winopts) do
    vim.wo[win][k] = v
  end

  M.save(opts.buf, opts)
end

--------------------------- User API -------------------------------

--- Open a terminal window and start term job if needed
--- @param opts TermOpenOpts
M.open = function(opts)
  ---@type boolean
  local buf_exists = opts.buf ~= nil
  opts.buf = opts.buf or vim.api.nvim_create_buf(false, true)
  ---@cast opts TermSetupOpts

  -- handle cmd opt
  ---@type string[]
  local cmd = { vim.o.shell }
  if opts.cmd and opts.buf then cmd = { vim.o.shell, '-c', utl.format_cmd(opts.cmd) .. '; ' .. vim.o.shell } end

  M.setup(opts) -- opts is refined into a TermRecord during setup
  ---@cast opts TermRecord
  M.save(opts.buf, opts)

  if not buf_exists then vim.api.nvim_call_function('termopen', { cmd, opts.termopen_opts or { detach = false } }) end

  vim.g.nvhterm = opts.pos == 'sp'
  vim.g.nvvterm = opts.pos == 'vsp'
end

--- Toggle a terminal window associated with an id
--- @param opts TermToggleOpts
M.toggle = function(opts)
  ---@type TermRecord|nil
  local x = utl.opts_to_id(opts.id)
  opts.buf = x and x.buf or nil

  if (x == nil or not vim.api.nvim_buf_is_valid(x.buf)) or vim.fn.bufwinid(x.buf) == -1 then
    M.open(opts)
  else
    vim.api.nvim_win_close(x.win, true)
  end
end

--- Spawn (or reuse) a terminal and run a command, re-running if invoked again
--- @param opts TermRunnerOpts
M.runner = function(opts)
  ---@type TermRecord|nil
  local x = utl.opts_to_id(opts.id)
  ---@type string
  local clear_cmd = opts.clear_cmd or 'clear; '
  opts.buf = x and x.buf or nil

  -- if buf doesnt exist
  if x == nil then
    M.open(opts)
  else
    -- window isnt visible
    if vim.fn.bufwinid(x.buf) == -1 then
      ---@type TermSetupOpts
      local setup_opts = vim.tbl_extend('force', opts, { buf = x.buf })
      M.setup(setup_opts)
    end

    ---@type string
    local cmd = utl.format_cmd(opts.cmd)

    if x.buf == vim.api.nvim_get_current_buf() then
      ---@type integer[]
      vim.g.buf_history = vim.g.buf_history or {}
      if #vim.g.buf_history >= 2 then vim.api.nvim_set_current_buf(vim.g.buf_history[#vim.g.buf_history - 1]) end
      cmd = utl.format_cmd(opts.cmd)
      vim.api.nvim_set_current_buf(x.buf)
    end

    ---@type integer
    local job_id = vim.b[x.buf].terminal_job_id
    vim.api.nvim_chan_send(job_id, clear_cmd .. cmd .. ' \n')
  end
end

return M
