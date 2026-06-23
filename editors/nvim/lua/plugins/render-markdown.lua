-- Render Markdown in-buffer with Glow-aligned structure and SourDiesel colors
require('render-markdown').setup {
  html = { enabled = false },
  latex = { enabled = false },

  heading = {
    icons = { '󰼏 ', '󰼐 ', '󰼑 ', '󰼒 ', '󰼓 ', '󰼔 ' },
    width = 'block',
  },

  code = {
    width = 'block',
  },

  bullet = {
    icons = { '•' },
  },

  checkbox = {
    unchecked = { icon = '[ ] ' },
    checked = { icon = '[✓] ' },
  },
}
