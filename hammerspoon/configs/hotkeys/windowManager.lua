local move = require('utils').move_app

return {
  {
    desc = 'Left Half',
    mods = CTRL_ALT,
    key = 'Left',
    command = function() move { x = 0, y = 0, w = 0.5, h = 1 } end,
  },

  {
    desc = 'Right Half',
    mods = CTRL_ALT,
    key = 'Right',
    command = function() move { x = 0.5, y = 0, w = 0.5, h = 1 } end,
  },

  {
    desc = 'Center Half',
    mods = CTRL_ALT,
    key = 'C',
    command = function() move { x = 0.25, y = 0.25, w = 0.5, h = 0.5 } end,
  },

  {
    desc = 'Top Half',
    mods = CTRL_ALT,
    key = 'Up',
    command = function() move { x = 0, y = 0, w = 1, h = 0.5 } end,
  },

  {
    desc = 'Bottom Half',
    mods = CTRL_ALT,
    key = 'Down',
    command = function() move { x = 0, y = 0.5, w = 1, h = 0.5 } end,
  },

  {
    desc = 'Top Left',
    mods = CTRL_ALT,
    key = 'U',
    command = function() move { x = 0, y = 0, w = 0.5, h = 0.5 } end,
  },

  {
    desc = 'Top Right',
    mods = CTRL_ALT,
    key = 'I',
    command = function() move { x = 0.5, y = 0, w = 0.5, h = 0.5 } end,
  },

  {
    desc = 'Bottom Left',
    mods = CTRL_ALT,
    key = 'J',
    command = function() move { x = 0, y = 0.5, w = 0.5, h = 0.5 } end,
  },

  {
    desc = 'Bottom Right',
    mods = CTRL_ALT,
    key = 'K',
    command = function() move { x = 0.5, y = 0.5, w = 0.5, h = 0.5 } end,
  },

  {
    desc = 'Maximize',
    mods = CTRL_ALT,
    key = 'F',
    command = function() move 'maximize' end,
  },

  {
    desc = 'Left Display',
    mods = HYPER,
    key = 'Left',
    command = function() move 'next' end,
  },

  {
    desc = 'Right Display',
    mods = HYPER,
    key = 'Right',
    command = function() move 'previous' end,
  },

  {
    desc = 'Almost Maximize',
    mods = CTRL_ALT,
    key = 'A',
    command = function()
      local win = hs.window.focusedWindow()
      if win then
        local screenFrame = win:screen():frame()
        local margin = 30 -- Adjust this value for the desired margin size
        win:setFrame {
          x = screenFrame.x + margin,
          y = screenFrame.y + margin,
          w = screenFrame.w - (3 * margin),
          h = screenFrame.h - (3 * margin),
        }
        print('Almost Maximized ' .. win:title())
      else
        hs.alert.show 'No window to almost maximize'
      end
    end,
  },
}
