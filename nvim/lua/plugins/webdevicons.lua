-- https://github.com/nvim-tree/nvim-web-devicons

local icons = require 'ui.icons'

return {
  'nvim-tree/nvim-web-devicons',
  opts = {
    override = {
      default_icon = { icon = icons.completions.File, name = 'Default' },
      js = { icon = icons.javascript, name = 'js' },
      ts = { icon = icons.typescript, name = 'ts' },
      lock = { icon = icons.lock, name = 'lock' },
      ['robots.txt'] = { icon = icons.robot, name = 'robots' },
    },
  },
}
