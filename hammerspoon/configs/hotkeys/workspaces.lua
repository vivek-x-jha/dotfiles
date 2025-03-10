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

      -- Assign displays
      local centerScreen = screens[1]
      local leftScreen = screens[2]
      local rightScreen = screens[3]

      -- Function to move, unhide, and focus an app
      local function moveAndShowApp(appName, screen)
        local app = hs.application.get(appName)
        if app then
          app:activate() -- Brings the app to the foreground
          local win = app:mainWindow()
          if win then
            win:moveToScreen(screen)
            win:maximize()
            win:focus() -- Ensure the window is visible and active
          else
            hs.alert.show(appName .. ' has no open window')
          end
        else
          hs.alert.show(appName .. ' not running')
        end
      end

      -- Move apps to their respective screens and make them visible
      moveAndShowApp('ChatGPT', leftScreen)
      moveAndShowApp('WezTerm', centerScreen)
      moveAndShowApp('Arc', rightScreen)
    end,
  },
}
