local icn = require 'ui.icons'

-- https://github.com/nvim-tree/nvim-web-devicons
return {
  'nvim-tree/nvim-web-devicons',
  opts = {
    override = {
      default_icon = { icon = icn.completions.File, name = 'Default' },
      js = { icon = icn.javascript, name = 'js' },
      ts = { icon = icn.typescript, name = 'ts' },
      lock = { icon = icn.lock, name = 'lock' },
      ['robots.txt'] = { icon = icn.robot, name = 'robots' },
    },
  },
}
