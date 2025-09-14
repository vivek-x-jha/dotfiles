-- https://neovim.io/doc/user/lsp.html
local M = {}

M.setup = function(opts)
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

  -- Add servers in ~/.config/nvim/lsp/
  local servers = vim.fs.joinpath(vim.fn.stdpath 'config', 'lsp')

  for name, kind in vim.fs.dir(servers) do
    if kind == 'file' and name:sub(-4) == '.lua' then table.insert(tools, name:sub(1, -5)) end
  end

  -- Add formatters
  local formatters = require('conform').list_all_formatters()

  for _, v in ipairs(formatters) do
    vim.list_extend(tools, vim.split(v.name:gsub(',', ''), '%s+'))
  end

  -- Add linters
  vim.list_extend(tools, opts.ensure_installed or {})

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
