local M = {}
local utl = {}
local fn = vim.fn
local api = vim.api
local get_extmarks = api.nvim_buf_get_extmarks
local set_extmark = api.nvim_buf_set_extmark

local icn = require 'ui.icons'
local state = require 'ui.state'

utl.add_hl = function(hex)
  local name = 'hex_' .. hex:sub(2)

  api.nvim_set_hl(0, name, { fg = hex, bg = 'NONE', default = true })
  return name
end

utl.needs_hl = function(buf, linenr, col, hl_group, opts)
  local ms = get_extmarks(buf, state.ns, { linenr, col }, { linenr, opts.end_col }, { details = true })

  if #ms == 0 then return true end

  ms = ms[1]
  opts.id = ms[1]
  return hl_group ~= (ms[4].hl_group or ms[4].virt_text[1][2])
end

utl.hex = function(buf, line, str)
  for col, hex in str:gmatch '()(#%x%x%x%x%x%x)' do
    col = col - 1
    local hl_group = utl.add_hl(hex)
    local end_col = col + 7

    local opts = { end_col = end_col, hl_group = hl_group }

    opts.hl_group = nil
    opts.virt_text_pos = 'inline'
    opts.virt_text = { { icn.colorify, hl_group } }

    if utl.needs_hl(buf, line, col, hl_group, opts) then set_extmark(buf, state.ns, line, col, opts) end
  end
end

utl.lsp_var = function(buf, line, min, max)
  local param = { textDocument = vim.lsp.util.make_text_document_params(buf) }

  for _, client in pairs(vim.lsp.get_clients { bufnr = buf }) do
    if client.server_capabilities.colorProvider then
      client.request('textDocument/documentColor', param, function(_, resp)
        if resp and line then resp = vim.tbl_filter(function(v) return v.range['start'].line == line end, resp) end

        if resp and min then resp = vim.tbl_filter(function(v) return v.range['start'].line >= min and v.range['end'].line <= max end, resp) end

        for _, match in ipairs(resp or {}) do
          local color = match.color
          local r, g, b, a = color.red, color.green, color.blue, color.alpha
          local hex = string.format('#%02x%02x%02x', r * a * 255, g * a * 255, b * a * 255)

          local hl_group = utl.add_hl(hex)

          local range_start = match.range.start
          local range_end = match.range['end']

          local opts = { end_col = range_end.character, hl_group = hl_group }

          opts.hl_group = nil
          opts.virt_text_pos = 'inline'
          opts.virt_text = { { icn.colorify, hl_group } }

          if utl.needs_hl(buf, range_start.line, range_start.character, hl_group, opts) then
            set_extmark(buf, state.ns, range_start.line, range_start.character, opts)
          end
        end
      end, buf)
    end
  end
end

local del_extmarks_on_textchange = function(buf)
  vim.b[buf].colorify_attached = true

  api.nvim_buf_attach(buf, false, {
    -- s = start, e == end
    on_bytes = function(_, b, _, s_row, s_col, _, old_e_row, old_e_col, _, _, new_e_col, _)
      -- old_e_row = old deleted lines!
      -- new_e_col isnt 0 when cursor pos has changed
      if old_e_row == 0 and new_e_col == 0 and old_e_col == 0 then return end

      local row1, col1, row2, col2

      if old_e_row > 0 then
        row1, col1, row2, col2 = s_row, 0, s_row + old_e_row, 0
      else
        row1, col1, row2, col2 = s_row, s_col, s_row, s_col + old_e_col
      end

      if api.nvim_get_mode().mode ~= 'i' then
        col1, col2 = 0, -1
      end

      local ms = get_extmarks(b, state.ns, { row1, col1 }, { row2, col2 }, { overlap = true })

      for _, mark in ipairs(ms) do
        api.nvim_buf_del_extmark(b, state.ns, mark[1])
      end
    end,
    on_detach = function() vim.b[buf].colorify_attached = false end,
  })
end

M.attach = function(buf, event)
  local winid = vim.fn.bufwinid(buf)

  local min = fn.line('w0', winid) - 1
  local max = fn.line('w$', winid) + 1

  if event == 'TextChangedI' then
    local cur_linenr = fn.line('.', winid) - 1

    utl.hex(buf, cur_linenr, api.nvim_get_current_line())

    utl.lsp_var(buf, cur_linenr)
    return
  end

  local lines = api.nvim_buf_get_lines(buf, min, max, false)

  for i, str in ipairs(lines) do
    utl.hex(buf, min + i - 1, str)
  end

  utl.lsp_var(buf, nil, min, max)

  if event == 'BufEnter' and not vim.b[buf].colorify_attached then del_extmarks_on_textchange(buf) end
end

return M
