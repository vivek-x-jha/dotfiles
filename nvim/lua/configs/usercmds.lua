local mason_registry = require 'mason-registry'
local spectre = require 'spectre'
local conform_exists, conform = pcall(require, 'conform')
local lint_exists, lint = pcall(require, 'lint')

local utl = require 'configs.utils'

utl.create_user_command {
  name = 'Dashboard',
  desc = 'Toggle Dashboard',
  command = function()
    if vim.g.dashboard_displayed then
      require('ui.buffers').close()
    else
      require('ui.dashboard').open()
    end
  end,
}

utl.create_user_command {
  name = 'SpectreToggle',
  desc = 'Toggle Spectre search and replace',
  command = function() spectre.toggle() end,
}

utl.create_user_command {
  name = 'SpectreCurrWord',
  desc = 'Open Spectre in visual mode or with the current word in normal mode',
  command = function()
    if vim.fn.mode() == 'v' then
      spectre.open_visual()
    else
      spectre.open_visual { select_word = true }
    end
  end,
}

utl.create_user_command {
  name = 'SpectreCurrFile',
  desc = 'Open Spectre file search with the current word',
  command = function() spectre.open_file_search { select_word = true } end,
}

vim.schedule(function()
  utl.create_user_command {
    name = 'MasonInstallAll',
    desc = 'Install all language servers',
    command = function()
      local pkgs = {}
      local tools = {}

      vim.list_extend(tools, require('lspconfig.util').available_servers())

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
    end,
  }
end)
