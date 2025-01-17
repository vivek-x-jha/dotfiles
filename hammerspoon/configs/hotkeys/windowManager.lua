local ctrl_alt = { 'ctrl', 'alt' }
local ctrl_alt_cmd = { 'ctrl', 'alt', 'cmd' }

return {
  {
    desc = 'Left Half',
    mods = ctrl_alt,
    key = 'Left',
    command = function()
      local win = hs.window.focusedWindow()
      if win then
        win:moveToUnit(hs.layout.left50)
      else
        hs.alert.show 'No window to move to left half'
      end
    end,
  },

  {
    desc = 'Right Half',
    mods = ctrl_alt,
    key = 'Right',
    command = function()
      local win = hs.window.focusedWindow()
      if win then
        win:moveToUnit(hs.layout.right50)
      else
        hs.alert.show 'No window to move to right half'
      end
    end,
  },

  {
    desc = 'Center Half',
    mods = ctrl_alt,
    key = 'C',
    command = function()
      local win = hs.window.focusedWindow()
      if win then
        win:moveToUnit(hs.geometry.rect(0.25, 0.25, 0.5, 0.5))
      else
        hs.alert.show 'No window to center'
      end
    end,
  },

  {
    desc = 'Top Half',
    mods = ctrl_alt,
    key = 'Up',
    command = function()
      local win = hs.window.focusedWindow()
      if win then
        win:moveToUnit(hs.geometry.rect(0, 0, 1, 0.5))
      else
        hs.alert.show 'No window to move to top half'
      end
    end,
  },

  {
    desc = 'Bottom Half',
    mods = ctrl_alt,
    key = 'Down',
    command = function()
      local win = hs.window.focusedWindow()
      if win then
        win:moveToUnit(hs.geometry.rect(0, 0.5, 1, 0.5))
      else
        hs.alert.show 'No window to move to bottom half'
      end
    end,
  },

  {
    desc = 'Top Left',
    mods = ctrl_alt,
    key = 'U',
    command = function()
      local win = hs.window.focusedWindow()
      if win then
        win:moveToUnit(hs.geometry.rect(0, 0, 0.5, 0.5))
      else
        hs.alert.show 'No window to move to top left'
      end
    end,
  },

  {
    desc = 'Top Right',
    mods = ctrl_alt,
    key = 'I',
    command = function()
      local win = hs.window.focusedWindow()
      if win then
        win:moveToUnit(hs.geometry.rect(0.5, 0, 0.5, 0.5))
      else
        hs.alert.show 'No window to move to top right'
      end
    end,
  },

  {
    desc = 'Bottom Left',
    mods = ctrl_alt,
    key = 'J',
    command = function()
      local win = hs.window.focusedWindow()
      if win then
        win:moveToUnit(hs.geometry.rect(0, 0.5, 0.5, 0.5))
      else
        hs.alert.show 'No window to move to bottom left'
      end
    end,
  },

  {
    desc = 'Bottom Right',
    mods = ctrl_alt,
    key = 'K',
    command = function()
      local win = hs.window.focusedWindow()
      if win then
        win:moveToUnit(hs.geometry.rect(0.5, 0.5, 0.5, 0.5))
      else
        hs.alert.show 'No window to move to bottom right'
      end
    end,
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
