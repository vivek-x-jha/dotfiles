vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Load annotations
require 'types.buffers'
require 'types.colors'
require 'types.statusline'

-- Lazy install path
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

-- Bootstrap lazy if not installed
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})

    vim.fn.getchar()
    os.exit(1)
  end
end

-- Prepend lazy to rtp
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require('lazy').setup(require 'configs.lazy')

-- Load LSP
require 'configs.lsp'

-- Load options
require 'configs.options'

-- Load buffer manager
require('ui.buffers').setup()

-- Load highlights and colorscheme
require('colors.highlights').setup { colorscheme = 'sourdiesel' }

-- Load statusline
vim.o.statusline = "%!v:lua.require('ui.statusline').setup()"

-- Load & schedule auto commands
require 'configs.autocmds'

-- Schedule keymaps
vim.schedule(function() require 'configs.mappings' end)
