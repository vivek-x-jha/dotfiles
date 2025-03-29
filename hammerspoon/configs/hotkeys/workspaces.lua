local utl = require 'utils'

return {
  {
    key = '1',
    desc = 'Set utl.positionApp: ChatGPT -> WezTerm -> Arc',
    mods = HYPER,
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
      utl.positionApp('WezTerm', screens[1])
    end,
  },
}
