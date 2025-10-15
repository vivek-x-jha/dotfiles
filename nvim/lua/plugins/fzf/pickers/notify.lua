--- @type table<string, string> -- Custom icons
local icons = require 'icons'

local M = {}

local function time_hms(sec)
  if type(sec) ~= 'number' then return '' end
  return os.date('%H:%M:%S', math.floor(sec))
end

local function oneline(v)
  if type(v) == 'table' then return table.concat(v, ' ') end
  return tostring(v or '')
end

local function to_lines(msg)
  if type(msg) == 'table' then
    local out = {}
    for _, x in ipairs(msg) do
      out[#out + 1] = tostring(x)
    end
    return out
  end
  return { tostring(msg or '') }
end

local function make_reverse_log_levels()
  local rev = {}
  for name, val in pairs(vim.log.levels or {}) do
    rev[val] = name
  end
  return rev
end

local REVERSE_LOG = make_reverse_log_levels()

local function level_name_any(lvl)
  if lvl == nil then return '' end
  local t = type(lvl)
  if t == 'number' then
    return REVERSE_LOG[lvl] or tostring(lvl)
  elseif t == 'string' then
    return lvl:upper()
  else
    return tostring(lvl)
  end
end

local function level_col(lvl)
  local s = level_name_any(lvl)
  if #s > 7 then s = s:sub(1, 7) end
  return string.format('%-7s', s)
end

local function write_scratch(bufnr, lines)
  vim.bo[bufnr].buftype = 'nofile'
  vim.bo[bufnr].bufhidden = 'wipe'
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.bo[bufnr].modifiable = false
end

M.history = function()
  local ok_notify, notify = pcall(require, 'notify')
  if not ok_notify then
    vim.notify('notify module not found', vim.log.levels.ERROR)
    return
  end
  local ok_fzf, fzf = pcall(require, 'fzf-lua')
  if not ok_fzf then
    vim.notify('fzf-lua module not found', vim.log.levels.ERROR)
    return
  end

  local history = notify.history() ---@type NotifyEntry[]
  if #history == 0 then
    vim.notify('No notifications in history', vim.log.levels.INFO)
    return
  end

  local rows = {}
  for i, n in ipairs(history) do
    rows[#rows + 1] = string.format('[%d] %s  %s  %s', i, time_hms(n.time), level_col(n.level), oneline(n.message))
  end

  fzf.fzf_exec(rows, {
    prompt = icons.search .. '  ',
    fzf_opts = {
      ['--no-sort'] = true,
      ['--ansi'] = true,
      ['--tiebreak'] = 'index',
      ['--with-nth'] = '1..',
    },
    winopts = {
      preview = { layout = 'vertical', horizontal = 'right:60%' },
    },

    fn_preview = function(item)
      local idx = tonumber(item:match '^%[(%d+)%]') or 1
      local n = history[idx]
      local meta = {
        '── Notification ─────────────────────',
        'Index : ' .. idx,
        'Time  : ' .. time_hms(n.time),
        'Level : ' .. level_name_any(n.level),
        'Title : ' .. oneline(n.title),
        'Icon  : ' .. (n.icon or ''),
        '',
        'Message:',
        '',
      }
      return vim.list_extend(meta, to_lines(n.message))
    end,

    actions = {
      ['default'] = function(selected)
        local s = selected and selected[1]
        if not s then return end
        local idx = tonumber(s:match '^%[(%d+)%]') or 1
        local n = history[idx]

        vim.cmd 'new'
        local buf = vim.api.nvim_get_current_buf()
        local header = {
          'Level : ' .. level_name_any(n.level),
          'Title : ' .. oneline(n.title),
          'Time  : ' .. time_hms(n.time),
          'Icon  : ' .. (n.icon or ''),
          '',
          'Message:',
          '',
        }
        write_scratch(buf, vim.list_extend(header, to_lines(n.message)))
        vim.api.nvim_buf_set_name(buf, ('notify://%d'):format(idx))
        vim.cmd 'normal! gg'
      end,

      ['ctrl-y'] = function(selected)
        local s = selected and selected[1]
        if not s then return end
        local idx = tonumber(s:match '^%[(%d+)%]') or 1
        local n = history[idx]
        vim.fn.setreg('+', table.concat(to_lines(n.message), '\n'))
        vim.notify('Notification message yanked to clipboard', vim.log.levels.INFO)
      end,
    },
  })
end

return M
