-- https://github.com/williamboman/mason.nvim
return {
  'williamboman/mason.nvim',
  cmd = { 'Mason', 'MasonInstall', 'MasonInstallAll', 'MasonUpdate' },
  opts = function()
    local icn = require 'ui.icons'

    -- TODO fix MasonInstallAll
    vim.api.nvim_create_user_command('MasonInstallAll', function()
      local conform_exists, conform = pcall(require, 'conform')
      local lint_exists, lint = pcall(require, 'lint')
      local mason_registry = require 'mason-registry'
      local pkgs = {}
      local tools = {}

      if conform_exists then
        for _, v in ipairs(conform.list_all_formatters()) do
          local fmts = vim.split(v.name:gsub(',', ''), '%s+')
          vim.list_extend(tools, fmts)
        end
      end

      if lint_exists then
        local linters = lint.linters_by_ft
        for _, v in pairs(linters) do
          vim.list_extend(tools, v)
        end
      end

      for _, v in pairs(tools) do
        table.insert(pkgs, require('ui.masonames')[v])
      end

      vim.cmd 'Mason'

      mason_registry.refresh(function()
        for _, tool in ipairs(pkgs) do
          local p = mason_registry.get_package(tool)
          if not p:is_installed() then p:install() end
        end
      end)
    end, { desc = 'Install all language servers' })

    return {
      PATH = 'skip',
      ui = {
        icons = {
          package_pending = icn.download,
          package_installed = icn.checkmark,
          package_uninstalled = icn.dotted_circle,
        },
      },
      max_concurrent_installers = 10,
    }
  end,
}
