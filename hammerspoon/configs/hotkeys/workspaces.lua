local workspace = require('configs.utils').move_max_app

return {
  {
    key = '0',
    desc = 'Set Workspace: ChatGPT -> WezTerm -> Arc',
    mods = HYPER,
    command = function()
      -- Get all screens
      local screens = hs.screen.allScreens()
      if #screens < 3 then
        hs.alert.show 'Requires 3 displays!'
        return
      end

      -- Move apps to their respective screens and make them visible
      workspace('Arc', screens[3])
      workspace('ChatGPT', screens[2])
      workspace('WezTerm', screens[1])
    end,
  },
}
