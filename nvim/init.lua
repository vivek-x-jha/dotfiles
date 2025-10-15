-- Configure options
require 'opts'

-- Configure diagnostics and LSP servers
require 'lsp'

-- Configure plugins
require 'plugins'

-- Set event triggers
require 'autocmds'

-- Set highlights
vim.cmd.colorscheme 'sourdiesel' -- use shell theme colors

-- Set keymaps - defer to next event loop to prevent unwanted remappings
vim.schedule(function() require 'keymaps' end)
