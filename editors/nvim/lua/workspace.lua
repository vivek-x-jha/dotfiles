local M = {}

---@type string[]
local excludes = {
  '.cache',
  '.direnv',
  '.git',
  '.github',
  '.idea',
  '.terraform',
  '.venv',
  'Icon?',
  'Session.vim',
  '__pycache__',
  'dist',
  'node_modules',
  'target',
  'vendor',
}

---@type table<string, boolean>
local text_mimes = {
  ['application/javascript'] = true,
  ['application/json'] = true,
  ['application/toml'] = true,
  ['application/x-sh'] = true,
  ['application/x-yaml'] = true,
  ['application/xml'] = true,
  ['application/yaml'] = true,
}

---@type any
local timer = nil

---@type boolean
local syncing = false

--- Run a shell command and return stdout when it succeeds
--- @param cmd string[]
--- @return string|nil
local run = function(cmd)
  ---@type string
  local output = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then return nil end
  return output
end

--- Check whether a path matches edit-all's text-ish MIME filter
--- @param path string
--- @return boolean
local is_text_file = function(path)
  ---@type string|nil
  local mime = run { 'file', '-b', '--mime-type', '--', path }
  if not mime then return false end

  mime = vim.trim(mime)
  return mime:match '^text/' ~= nil or text_mimes[mime] == true
end

--- Return edit-all eligible files keyed by absolute path
--- @return table<string, boolean>
local project_files = function()
  ---@type string[]
  local cmd = { 'fd', '-HItf' }

  for _, pattern in ipairs(excludes) do
    cmd[#cmd + 1] = '--exclude'
    cmd[#cmd + 1] = pattern
  end

  ---@type string|nil
  local output = run(cmd)
  if not output then return {} end

  ---@type table<string, boolean>
  local files = {}

  ---@type string
  local cwd = assert(vim.uv.cwd())

  for file in output:gmatch '[^\r\n]+' do
    ---@type string
    local path = vim.fs.normalize(vim.fs.joinpath(cwd, file))

    if is_text_file(path) then files[path] = true end
  end

  return files
end

--- Add newly discovered files and remove buffers for deleted files
--- @param files table<string, boolean>
local sync_buffers = function(files)
  ---@type table<string, integer>
  local existing = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    ---@type string
    local name = vim.api.nvim_buf_get_name(buf)

    if name ~= '' then existing[vim.fs.normalize(name)] = buf end
  end

  for path in pairs(files) do
    if not existing[path] then vim.cmd.badd(vim.fn.fnameescape(path)) end
  end

  for path, buf in pairs(existing) do
    ---@type string
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })

    ---@type boolean
    local listed = vim.api.nvim_get_option_value('buflisted', { buf = buf })

    ---@type boolean
    local modified = vim.api.nvim_get_option_value('modified', { buf = buf })

    ---@type boolean
    local removed_file_buffer = listed and buftype == '' and not files[path] and vim.uv.fs_stat(path) == nil

    if removed_file_buffer and not modified then vim.api.nvim_buf_delete(buf, { force = false }) end
  end
end

--- Save the root Session.vim file
--- @param opts? { silent?: boolean }
M.save_session = function(opts)
  opts = opts or {}
  vim.cmd 'silent! mksession! Session.vim'

  if not opts.silent then vim.notify('Updating workspace state: Session.vim', vim.log.levels.INFO) end
end

--- Refresh edit-all buffers and save Session.vim
--- @param opts? { silent?: boolean }
M.sync_session = function(opts)
  opts = opts or {}

  if syncing or vim.fn.executable 'fd' ~= 1 or vim.fn.executable 'file' ~= 1 then
    M.save_session { silent = true }
    return
  end

  syncing = true

  local ok, err = pcall(function()
    ---@type table<string, boolean>
    local files = project_files()

    sync_buffers(files)
    M.save_session(opts)
  end)

  syncing = false

  if not ok then vim.notify('Workspace session sync failed: ' .. tostring(err), vim.log.levels.ERROR) end
end

--- Debounce workspace session refreshes after file events
M.schedule_session_sync = function()
  if timer then timer:stop() end

  timer = timer or vim.uv.new_timer()
  timer:start(500, 0, function()
    vim.schedule(function() M.sync_session { silent = true } end)
  end)
end

return M
