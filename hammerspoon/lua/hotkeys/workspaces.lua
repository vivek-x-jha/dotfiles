local utl = require 'utils'

return {
  {
    key = '1',
    desc = 'Set Single Monitor Workspace',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function()
      local screens = hs.screen.allScreens()

      -- Arc @ top right
      utl.positionApp('Arc', screens[1])
      utl.moveApp { x = 0.5, y = 0, w = 0.5, h = 0.5 }

      -- ChatGPT @ bottom right
      utl.positionApp('ChatGPT', screens[1])
      utl.moveApp { x = 0.5, y = 0.5, w = 0.5, h = 0.5 }

      -- Wezterm @ left half
      utl.positionApp('WezTerm', screens[1])
      utl.moveApp { x = 0, y = 0, w = 0.5, h = 1 }
    end,
  },

  {
    key = '2',
    desc = 'Set 2 External Monitor Workspace',
    mods = { 'ctrl', 'alt', 'cmd' },
    command = function()
      -- Get all screens
      local screens = hs.screen.allScreens()
      if #screens < 3 then
        hs.alert.show 'Requires 3 displays!'
        return
      end

      -- Move apps to their respective screens and make them visible
      utl.positionApp('Arc', screens[3])
      utl.positionApp('ChatGPT', screens[2])
      utl.moveApp 'maximize'
      utl.positionApp('WezTerm', screens[1])
    end,
  },
}
