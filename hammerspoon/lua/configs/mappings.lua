return {
  {
    desc = 'Reload Config!',
    mods = { 'cmd', 'alt', 'ctrl' },
    key = 'R',
    command = function()
      hs.reload()
      print 'Reloaded ~/.hammerspoon/'
    end,
  },

  {
    desc = 'Arrange Main Workspace',
    mods = { 'cmd', 'alt', 'ctrl' },
    key = 'W',
    command = function()
      print '---------------------------------------'
      local leftDisp
      local frontDisp
      local rightDisp

      local screens = hs.screen.allScreens()

      -- Ensure monitor arrangement
      for _, screen in ipairs(screens) do
        local name = screen:name()
        if name == 'Built-in Retina Display' then
          leftDisp = name
        elseif name == 'Studio Display (1)' then
          rightDisp = name
        elseif name == 'Studio Display (2)' then
          frontDisp = name
          screen:setPrimary()
        end
      end

      print(leftDisp)
      print(frontDisp)
      print(rightDisp)
      print '---------------------------------------'

      -- -- Open Spotify and ChatGPT on "Built-in Display" and make them fullscreen
      -- local openAndFullscreen = function(appName, screen)
      --   hs.application.launchOrFocus(appName)
      --   hs.timer.doAfter(1, function()
      --     local app = hs.application.get(appName)
      --     if app then
      --       local win = app:mainWindow()
      --       if win then
      --         win:moveToScreen(screen)
      --         win:setFullscreen(true)
      --       end
      --     end
      --   end)
      -- end
      --
      -- openAndFullscreen('Spotify', screenArrangement['Built-in Display'])
      -- openAndFullscreen('ChatGPT', screenArrangement['Built-in Display'])
      --
      -- -- Open Arc on "Studio Display (1)" and make it fullscreen
      -- openAndFullscreen('Arc', screenArrangement['Studio Display (1)'])
      --
      -- -- Open WezTerm on "Studio Display (2)" (no fullscreen requirement specified, so omitted)
      -- hs.application.launchOrFocus 'WezTerm'
      -- hs.timer.doAfter(1, function()
      --   local wezterm = hs.application.get 'WezTerm'
      --   if wezterm then
      --     local win = wezterm:mainWindow()
      --     if win then win:moveToScreen(screenArrangement['Studio Display (2)']) end
      --   end
      -- end)
      --
      -- hs.alert.show 'Workspace arranged successfully!'
    end,
  },
}
