local ctrl_alt = { 'ctrl', 'alt' }
local ctrl_alt_cmd = { 'ctrl', 'alt', 'cmd' }

local move = require('utils').move_app

return {
  {
    desc = 'Left Half',
    mods = ctrl_alt,
    key = 'Left',
    command = function() move { x = 0, y = 0, w = 0.5, h = 1 } end,
  },

  {
    desc = 'Right Half',
    mods = ctrl_alt,
    key = 'Right',
    command = function() move { x = 0.5, y = 0, w = 0.5, h = 1 } end,
  },

  {
    desc = 'Center Half',
    mods = ctrl_alt,
    key = 'C',
    command = function() move { x = 0.25, y = 0.25, w = 0.5, h = 0.5 } end,
  },

  {
    desc = 'Top Half',
    mods = ctrl_alt,
    key = 'Up',
    command = function() move { x = 0, y = 0, w = 1, h = 0.5 } end,
  },

  {
    desc = 'Bottom Half',
    mods = ctrl_alt,
    key = 'Down',
    command = function() move { x = 0, y = 0.5, w = 1, h = 0.5 } end,
  },

  {
    desc = 'Top Left',
    mods = ctrl_alt,
    key = 'U',
    command = function() move { x = 0, y = 0, w = 0.5, h = 0.5 } end,
  },

  {
    desc = 'Top Right',
    mods = ctrl_alt,
    key = 'I',
    command = function() move { x = 0.5, y = 0, w = 0.5, h = 0.5 } end,
  },

  {
    desc = 'Bottom Left',
    mods = ctrl_alt,
    key = 'J',
    command = function() move { x = 0, y = 0.5, w = 0.5, h = 0.5 } end,
  },

  {
    desc = 'Bottom Right',
    mods = ctrl_alt,
    key = 'K',
    command = function() move { x = 0.5, y = 0.5, w = 0.5, h = 0.5 } end,
  },

  {
    desc = 'Maximize',
    mods = ctrl_alt,
    key = 'F',
    command = function()
      local win = hs.window.focusedWindow()
      if win then
        win:maximize()
      else
        hs.alert.show 'No window to maximize'
      end
    end,
  },

  {
    desc = 'Almost Maximize',
    mods = ctrl_alt,
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

  {
    desc = 'Left Display',
    mods = ctrl_alt_cmd,
    key = 'Left',
    command = function()
      local win = hs.window.focusedWindow()
      if win then
        win:moveToScreen(win:screen():next())
      else
        hs.alert.show 'No window to move to next display'
      end
    end,
  },

  {
    desc = 'Right Display',
    mods = ctrl_alt_cmd,
    key = 'Right',
    command = function()
      local win = hs.window.focusedWindow()
      if win then
        win:moveToScreen(win:screen():previous())
      else
        hs.alert.show 'No window to move to previous display'
      end
    end,
  },
}
