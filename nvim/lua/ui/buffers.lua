local cur_buf = vim.api.nvim_get_current_buf
local set_buf = vim.api.nvim_set_current_buf

--- Finds the index of a buffer in the tab's buffer list
--- @param bufnr integer The buffer number to locate
--- @return integer|nil The index of the buffer if found, otherwise nil
local buf_index = function(bufnr)
  for i, value in ipairs(vim.t.bufs) do
    if value == bufnr then return i end
  end
end

---@class Buffer
---@field setup fun(): nil Initializes and stores listed buffers in a tab-local variable
---@field next fun(): nil Switches to the next buffer in the tab's buffer list
---@field prev fun(): nil Switches to the previous buffer in the tab's buffer list
---@field close fun(bufnr?: integer): nil Closes the specified buffer, or the current buffer if none is specified
local M = {}

M.setup = function()
  -- store listed buffers in tab local var
  vim.t.bufs = vim.t.bufs or vim.api.nvim_list_bufs()

  local listed_bufs = {}

  for _, val in ipairs(vim.t.bufs) do
    if vim.bo[val].buflisted then table.insert(listed_bufs, val) end
  end

  vim.t.bufs = listed_bufs
end

M.next = function()
  local bufs = vim.t.bufs
  local curbufIndex = buf_index(cur_buf())

  if not curbufIndex then
    set_buf(vim.t.bufs[1])
    return
  end

  set_buf((curbufIndex == #bufs and bufs[1]) or bufs[curbufIndex + 1])
end

M.prev = function()
  local bufs = vim.t.bufs
  local curbufIndex = buf_index(cur_buf())

  if not curbufIndex then
    set_buf(vim.t.bufs[1])
    return
  end

  set_buf((curbufIndex == 1 and bufs[#bufs]) or bufs[curbufIndex - 1])
end

M.close = function(bufnr)
  bufnr = bufnr or cur_buf()

  if vim.bo[bufnr].buftype == 'terminal' then
    vim.cmd(vim.bo.buflisted and 'set nobl | enew' or 'hide')
  else
    local curBufIndex = buf_index(bufnr)
    local bufhidden = vim.bo.bufhidden

    -- force close floating wins or nonbuflisted
    if (not vim.bo[bufnr].buflisted) or vim.api.nvim_win_get_config(0).zindex then
      vim.cmd 'bw'
      return

      -- handle listed bufs
    elseif curBufIndex and #vim.t.bufs > 1 then
      local newBufIndex = curBufIndex == #vim.t.bufs and -1 or 1
      vim.cmd('b' .. vim.t.bufs[curBufIndex + newBufIndex])

      -- handle unlisted
    elseif not vim.bo.buflisted then
      local tmpbufnr = vim.t.bufs[1]

      if vim.g.nv_previous_buf and vim.api.nvim_buf_is_valid(vim.g.nv_previous_buf) then tmpbufnr = vim.g.nv_previous_buf end

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
