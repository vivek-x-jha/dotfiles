return {
  setConsole = function(opts_path)
    local options = require(opts_path)

    for setting, opts in pairs(options) do
      if setting == 'toolbar' and not opts then
        hs.console.toolbar(nil)
      else
        hs.console[setting](opts)
      end
    end
  end,

  toggleApp = function(app_name)
    local app = hs.application.get(app_name)

    if app and app:isFrontmost() then
      app:hide()
    else
      if not app then
        hs.application.launchOrFocus(app_name)
      else
        app:activate()
        app:unhide()
        local win = app:mainWindow()
        if win then
          win:raise()
          win:focus()
        end
      end
    end
  end,

  moveApp = function(app_pos)
    local win = hs.window.focusedWindow()

    if not win then
      hs.alert.show 'No window to move'
    elseif type(app_pos) == 'string' then
      if app_pos == 'next' then
        win:moveToScreen(win:screen():next())
      elseif app_pos == 'previous' then
        win:moveToScreen(win:screen():previous())
      elseif app_pos == 'maximize' then
        win:maximize()
      end
    else
      win:moveToUnit(hs.geometry.rect(app_pos.x, app_pos.y, app_pos.w, app_pos.h))
    end
  end,

  positionApp = function(appName, screen)
    local app = hs.application.get(appName)
    if app then
      app:activate() -- Brings the app to the foreground
      local win = app:mainWindow()
      if win then
        win:moveToScreen(screen)
        win:focus() -- Ensure the window is visible and active
        local screenFrame = win:screen():frame()
        local margin = 50
        win:setFrame {
          x = screenFrame.x + margin,
          y = screenFrame.y + margin,
          w = screenFrame.w - (2 * margin),
          h = screenFrame.h - (2 * margin),
        }
      else
        hs.alert.show(appName .. ' has no open window')
      end
    else
      hs.alert.show(appName .. ' not running')
    end
  end,

  bindHotkeys = function(hotkey_path)
    -- Translate the dot-based hotkey_path into a file path
    local path = hs.configdir .. '/' .. hotkey_path:gsub('%.', '/')

    if not hs.fs.attributes(path) then
      print('Error: hotkey_path does not exist: ', path)
      return
    end

    -- Iterate over files in the hotkey_path
    for file in hs.fs.dir(path) do
      if file:sub(-4) == '.lua' then
        local module_name = table.concat { hotkey_path, '.', file:sub(1, -5) }
        local success, mappings = pcall(require, module_name)

        if success and type(mappings) == 'table' then
          for _, spec in ipairs(mappings) do
            if spec.mods and spec.key and spec.desc and spec.command then
              hs.hotkey.bind(spec.mods, spec.key, spec.desc, spec.command)
            else
              print(table.concat { 'Invalid spec in ', file, ': ', hs.inspect(spec) })
            end
          end
        else
          print(table.concat { 'Failed to load ', module_name, ': ', tostring(mappings) })
        end
      end
    end
  end,
}
