-- Configure options
require 'opts'

-- Configure diagnostics and LSP servers
require 'lsp'

-- Set event triggers
require 'autocmds'

-- Configure plugins
require 'plugins'

-- Initialize statusline
_G.sourdiesel_statusline = function()
  local ok, statusline = pcall(require, 'nvim-statusline')
  return ok and statusline.setup() or ''
end
vim.o.statusline = '%!v:lua.sourdiesel_statusline()'

-- Set highlights
vim.cmd.colorscheme 'sourdiesel' -- use shell theme colors

-- Set keymaps - defer to next event loop to prevent unwanted remappings
vim.schedule(function() require 'keymaps' end)
