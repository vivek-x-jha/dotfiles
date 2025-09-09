-- https://neovim.io/doc/user/lsp.html
local M = {}

M.setup = function(opts)
  opts = opts or {}
  local icn = require 'icons'
  local tools = {}

  -- Configure autocompletions
  vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
  })

  -- Configure diagnostics
  vim.diagnostic.config {
    float = { border = 'single' },
    severity_sort = true,

    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icn.error,
        [vim.diagnostic.severity.WARN] = icn.warn,
        [vim.diagnostic.severity.HINT] = icn.hint,
        [vim.diagnostic.severity.INFO] = icn.info,
      },
    },

    virtual_lines = {
      current_line = true,
    },

    virtual_text = {
      current_line = true,
      prefix = icn.virtualcircle,
    },
  }

  -- Add servers in ~/.config/nvim/lsp
  local fd = assert(vim.uv.fs_opendir(opts.servers))

  while true do
    local dir_entries = vim.uv.fs_readdir(fd)
    if not dir_entries then break end
    for _, entry in ipairs(dir_entries) do
      if entry.type == 'file' and entry.name:match '%.lua$' then
        local basename = vim.fn.fnamemodify(entry.name, ':r')
        table.insert(tools, basename)
      end
    end
  end

  vim.uv.fs_closedir(fd)

  -- Add linters
  vim.list_extend(tools, opts.linters)

  -- Add formatters
  for _, v in ipairs(opts.formatters) do
    vim.list_extend(tools, vim.split(v.name:gsub(',', ''), '%s+'))
  end

  -- Install all language servers, formatters, and linters
  local registry = require 'mason-registry'
  local mappings = require 'masonames'

  registry.refresh(function()
    for _, tool in ipairs(tools) do
      local tool_kebab = assert(mappings[tool])
      local pkg = registry.get_package(tool_kebab)

      if not pkg:is_installed() then pkg:install() end
    end
  end)

  vim.lsp.enable(tools)
end

return M
