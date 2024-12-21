local fn = vim.fn
local g = vim.g
local usrcmd = vim.api.nvim_create_user_command

local masonreg = require 'mason-registry'
local spectre = require 'spectre'
local conform_exists, conform = pcall(require, 'conform')
local lint_exists, lint = pcall(require, 'lint')

-- Dashboard
usrcmd('Dashboard', function()
  if g.dashboard_displayed then
    require('ui.buffers').close()
  else
    require('ui.dashboard').open()
  end
end, {
  desc = 'Toggle Dashboard',
})

-- Spectre
usrcmd('SpectreToggle', function() spectre.toggle() end, {
  desc = 'Toggle Spectre search and replace',
})

usrcmd('SpectreCurrWord', function()
  if fn.mode() == 'v' then
    spectre.open_visual()
  else
    spectre.open_visual { select_word = true }
  end
end, {
  desc = 'Open Spectre in visual mode or with the current word in normal mode',
})

usrcmd('SpectreCurrFile', function() spectre.open_file_search { select_word = true } end, {
  desc = 'Open Spectre file search with the current word',
})

-- Mason
vim.schedule(function()
  usrcmd('MasonInstallAll', function()
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

    masonreg.refresh(function()
      for _, tool in ipairs(pkgs) do
        local p = masonreg.get_package(tool)

        if not p:is_installed() then p:install() end
      end
    end)
  end, {
    desc = 'Install all language servers',
  })
end)
