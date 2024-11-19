dofile(vim.g.base46_cache .. 'blankline')

local hooks = require 'ibl.hooks'
hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

return {
  indent = { char = '│', highlight = 'IblChar' },
  scope = { char = '│', highlight = 'IblScopeChar' },
}
