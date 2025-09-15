local M = {}
vim.g.terminals = {}

-- used for initially resizing terms
vim.g.nvhterm = false
vim.g.nvvterm = false

local utl = {
  opts_to_id = function(id)
    for _, opts in pairs(vim.g.terminals) do
      if opts.id == id then return opts end
    end
  end,

  format_cmd = function(cmd) return type(cmd) == 'string' and cmd or cmd() end,
}

M.save = function(index, val)
  local terms_list = vim.g.terminals
  terms_list[tostring(index)] = val
  vim.g.terminals = terms_list
end

M.setup = function(opts)
  -- Controls floating terminal opts
  if opts.pos == 'float' then
    local default_float_opts = {
      relative = 'editor',
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
    }

    local newopts = vim.tbl_deep_extend('force', default_float_opts, opts.float_opts or {})

    newopts.width = math.ceil(newopts.width * vim.o.columns)
    newopts.height = math.ceil(newopts.height * vim.o.lines)
    newopts.row = math.ceil(newopts.row * vim.o.lines)
    newopts.col = math.ceil(newopts.col * vim.o.columns)

    vim.api.nvim_open_win(opts.buf, true, newopts)
  else
    vim.cmd(opts.pos)
  end

  local win = vim.api.nvim_get_current_win()
  opts.win = win

  vim.bo[opts.buf].buflisted = false
  vim.bo[opts.buf].ft = 'NvTerm_' .. opts.pos:gsub(' ', '')
  vim.cmd 'startinsert'

  -- Resize non-floating wins initially + or only when they're toggleable
  if (opts.pos == 'sp' and not vim.g.nvhterm) or (opts.pos == 'vsp' and not vim.g.nvvterm) or (opts.pos ~= 'float') then
    local pos_data = {
      sp = { resize = 'height', area = 'lines' },
      vsp = { resize = 'width', area = 'columns' },
      ['bo sp'] = { resize = 'height', area = 'lines' },
      ['bo vsp'] = { resize = 'width', area = 'columns' },
    }

    local pos_type = pos_data[opts.pos]
    local default_split_opts = { sp = 0.3, vsp = 0.2, ['bo sp'] = 0.3, ['bo vsp'] = 0.2 }
    local size = opts.size and opts.size or default_split_opts[opts.pos]
    local new_size = vim.o[pos_type.area] * size
    vim.api['nvim_win_set_' .. pos_type.resize](0, math.floor(new_size))
  end

  vim.api.nvim_win_set_buf(win, opts.buf)

  local default_winopts = { number = false, relativenumber = false }
  local winopts = vim.tbl_deep_extend('force', default_winopts, opts.winopts or {})

  for k, v in pairs(winopts) do
    vim.wo[win][k] = v
  end

  M.save(opts.buf, opts)
end

--------------------------- User API -------------------------------
M.open = function(opts)
  local buf_exists = opts.buf
  opts.buf = opts.buf or vim.api.nvim_create_buf(false, true)

  -- handle cmd opt
  local cmd = { vim.o.shell }
  if opts.cmd and opts.buf then cmd = { vim.o.shell, '-c', utl.format_cmd(opts.cmd) .. '; ' .. vim.o.shell } end

  M.setup(opts)
  M.save(opts.buf, opts)

  if not buf_exists then vim.api.nvim_call_function('termopen', { cmd, opts.termopen_opts or { detach = false } }) end

  vim.g.nvhterm = opts.pos == 'sp'
  vim.g.nvvterm = opts.pos == 'vsp'
end

M.toggle = function(opts)
  local x = utl.opts_to_id(opts.id)
  opts.buf = x and x.buf or nil

  if (x == nil or not vim.api.nvim_buf_is_valid(x.buf)) or vim.fn.bufwinid(x.buf) == -1 then
    M.open(opts)
  else
    vim.api.nvim_win_close(x.win, true)
  end
end

-- spawns term with *cmd & runs the *cmd if the keybind is run again
M.runner = function(opts)
  local x = utl.opts_to_id(opts.id)
  local clear_cmd = opts.clear_cmd or 'clear; '
  opts.buf = x and x.buf or nil

  -- if buf doesnt exist
  if x == nil then
    M.open(opts)
  else
    -- window isnt visible
    if vim.fn.bufwinid(x.buf) == -1 then M.setup(opts) end

    local cmd = utl.format_cmd(opts.cmd)

    if x.buf == vim.api.nvim_get_current_buf() then
      vim.api.nvim_set_current_buf(vim.g.buf_history[#vim.g.buf_history - 1])
      cmd = utl.format_cmd(opts.cmd)
      vim.api.nvim_set_current_buf(x.buf)
    end

    local job_id = vim.b[x.buf].terminal_job_id
    vim.api.nvim_chan_send(job_id, clear_cmd .. cmd .. ' \n')
  end
end

return M
