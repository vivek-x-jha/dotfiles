local M = {}
local bo = vim.bo
local g = vim.g
local t = vim.t
local api = vim.api
local cur_buf = api.nvim_get_current_buf
local set_buf = api.nvim_set_current_buf

local utl = require 'configs.utils'
local aucmd = utl.create_autocmd

local buf_index = function(bufnr)
  for i, value in ipairs(t.bufs) do
    if value == bufnr then return i end
  end
end

M.setup = function()
  -- store listed buffers in tab local var
  t.bufs = t.bufs or api.nvim_list_bufs()

  local listed_bufs = {}

  for _, val in ipairs(t.bufs) do
    if vim.bo[val].buflisted then table.insert(listed_bufs, val) end
  end

  t.bufs = listed_bufs

  --------------------------- Autocmds -------------------------------

  aucmd {
    event = { 'BufAdd', 'BufEnter', 'tabnew' },
    callback = function(args)
      local bufs = t.bufs
      local is_curbuf = api.nvim_get_current_buf() == args.buf

      local get_opt = function(option, buffer) return api.nvim_get_option_value(option, { buf = buffer }) end

      if bufs == nil then
        bufs = api.nvim_get_current_buf() == args.buf and {} or { args.buf }
      else
        -- check for duplicates
        if
          not vim.tbl_contains(bufs, args.buf)
          and (args.event == 'BufEnter' or not is_curbuf or get_opt('buflisted', args.buf))
          and api.nvim_buf_is_valid(args.buf)
          and get_opt('buflisted', args.buf)
        then
          table.insert(bufs, args.buf)
        end
      end

      -- remove unnamed buffer which isnt current buf & modified
      if args.event == 'BufAdd' then
        if #api.nvim_buf_get_name(bufs[1]) == 0 and not get_opt('modified', bufs[1]) then table.remove(bufs, 1) end
      end

      t.bufs = bufs

      -- used for knowing previous active buf for term module's runner func
      if args.event == 'BufEnter' then
        local buf_history = vim.g.buf_history or {}
        table.insert(buf_history, args.buf)
        vim.g.buf_history = buf_history
      end
    end,
  }

  aucmd {
    event = 'BufDelete',
    callback = function(args)
      for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        local bufs = t[tab].bufs
        if bufs then
          for i, bufnr in ipairs(bufs) do
            if bufnr == args.buf then
              table.remove(bufs, i)
              t[tab].bufs = bufs
              break
            end
          end
        end
      end
    end,
  }

  aucmd {
    event = 'FileType',
    pattern = 'qf',
    callback = function() vim.opt_local.buflisted = false end,
  }
end

M.next = function()
  local bufs = t.bufs
  local curbufIndex = buf_index(cur_buf())

  if not curbufIndex then
    set_buf(t.bufs[1])
    return
  end

  set_buf((curbufIndex == #bufs and bufs[1]) or bufs[curbufIndex + 1])
end

M.prev = function()
  local bufs = t.bufs
  local curbufIndex = buf_index(cur_buf())

  if not curbufIndex then
    set_buf(t.bufs[1])
    return
  end

  set_buf((curbufIndex == 1 and bufs[#bufs]) or bufs[curbufIndex - 1])
end

M.close = function(bufnr)
  bufnr = bufnr or cur_buf()

  if bo[bufnr].buftype == 'terminal' then
    vim.cmd(bo.buflisted and 'set nobl | enew' or 'hide')
  else
    local curBufIndex = buf_index(bufnr)
    local bufhidden = bo.bufhidden

    -- force close floating wins or nonbuflisted
    if (not bo[bufnr].buflisted) or api.nvim_win_get_config(0).zindex then
      vim.cmd 'bw'
      return

      -- handle listed bufs
    elseif curBufIndex and #t.bufs > 1 then
      local newBufIndex = curBufIndex == #t.bufs and -1 or 1
      vim.cmd('b' .. t.bufs[curBufIndex + newBufIndex])

      -- handle unlisted
    elseif not bo.buflisted then
      local tmpbufnr = t.bufs[1]

      if g.nv_previous_buf and api.nvim_buf_is_valid(g.nv_previous_buf) then tmpbufnr = g.nv_previous_buf end

      vim.cmd('b' .. tmpbufnr .. ' | bw' .. bufnr)
      return
    else
      vim.cmd 'enew'
    end

    if not (bufhidden == 'delete') then vim.cmd('confirm bd' .. bufnr) end
  end

  vim.cmd 'redrawtabline'
end

return M
