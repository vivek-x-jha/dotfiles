-- https://www.hammerspoon.org/docs/

--- Read hex color env vars from ~/.zshenv (or a custom file) and build a palette table.
---
--- Expected lines look like: `export RED_HEX='#ff0000'`
--- * The `_HEX` suffix is stripped.
--- * Keys are lowercased (e.g., "RED_HEX" -> "red").
--- * Values are normalized to lowercase `#rrggbb`.
---
--- @param env_path? string  Optional path to an env file; falls back to $HOME/.zshenv
--- @return table<string, string> palette  Map of color name -> '#rrggbb'
local hexify = function(env_path)
  env_path = env_path or os.getenv 'HOME' .. '/.zshenv'

  ---@type table<string, string>
  local palette = {}

  local f = assert(io.open(env_path, 'r'), 'Failed to open ' .. env_path)

  for line in f:lines() do
    -- match exports ending in _HEX, capturing VAR_HEX and the hex value
    local color, hex = line:match '^%s*export%s+([A-Z_]+_HEX)%s*=%s*[\'"]?(#%x%x%x%x%x%x)[\'"]?'

    if color and hex then
      -- strip the _HEX suffix and lowercase the key
      color = color:match('^(.-)_HEX$'):lower()
      palette[color] = hex:lower()
    end
  end

  f:close()
  return palette
end

local thm = hexify()

-- Set console theme
hs.console.alpha(0.98)
hs.console.consoleCommandColor { hex = thm.green }
hs.console.consoleFont { name = 'JetBrainsMono Nerd Font', size = 15 }
hs.console.consolePrintColor { hex = thm.brightmagenta }
hs.console.consoleResultColor { hex = thm.red }
hs.console.darkMode(true)
hs.console.inputBackgroundColor { hex = thm.dark }
hs.console.outputBackgroundColor { hex = thm.dark }
hs.console.titleVisibility 'hidden'
hs.console.toolbar(nil)
hs.console.windowBackgroundColor { hex = thm.dark }

--- Reload Hammerspoon and clear the console for a clean slate.
--- Side effects: reloads config, clears console output.
local hs_reload = function()
  hs.reload()
  hs.console.clearConsole()
end

--- Toggle an app by name:
---  • If the app is frontmost -> hide it
---  • If not running -> launch/focus it
---  • Otherwise -> activate, unhide, and focus its main window
--- @param app string  # application display name (e.g. 'WezTerm', 'Safari')
local toggle = function(app)
  local appObj = hs.application.get(app)

  if appObj and appObj:isFrontmost() then
    appObj:hide()
  else
    if not appObj then
      hs.application.launchOrFocus(app)
    else
      appObj:activate()
      appObj:unhide()

      local win = appObj:mainWindow()
      if win then
        win:raise()
        win:focus()
      end
    end
  end
end

--- Move the currently focused window.
--- String modes:
---  • 'next'     -> move to next screen
---  • 'previous' -> move to previous screen
---  • 'maximize' -> maximize window on current screen
--- Rect mode:
---  • Provide a unit-rect table to place the window via hs.geometry.rect
--- @param app_pos '"next"'|'"previous"'|'"maximize"'|{ x:number, y:number, w:number, h:number }
local moveApp = function(app_pos)
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
    -- Treat as a unit-rect (fractions of screen); accepts numbers in [0,1]
    win:moveToUnit(hs.geometry.rect(app_pos.x, app_pos.y, app_pos.w, app_pos.h))
  end
end

--- Almost maximize the focused window with a uniform margin around the edges.
--- Uses a fixed pixel margin on the current screen.
local almost_maximize = function()
  local win = hs.window.focusedWindow()
  if win then
    local screenFrame = win:screen():frame()
    local margin = 50
    win:setFrame {
      x = screenFrame.x + margin,
      y = screenFrame.y + margin,
      w = screenFrame.w - (2 * margin),
      h = screenFrame.h - (2 * margin),
    }
    print('Almost Maximized ' .. win:title())
  else
    hs.alert.show 'No window to almost maximize'
  end
end

--- Activate an app, move its main window to a given screen, focus it,
--- and set it to an "almost maximized" frame with a margin.
--- @param appName string     # application display name
--- @param screen any         # target screen (e.g., hs.screen.mainScreen())
local positionApp = function(appName, screen)
  local app = hs.application.get(appName)
  if app then
    app:activate()
    local win = app:mainWindow()
    if win then
      win:moveToScreen(screen)
      win:focus()
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
end

--- Arrange Arc, ChatGPT, and WezTerm on a single monitor.
--- Arc: top right, ChatGPT: bottom right, WezTerm: left half.
--- @return nil
local arrange_monitor = function()
  local screens = hs.screen.allScreens()
  if #screens < 1 then return hs.alert.show 'No displays detected!' end
  positionApp('Arc', screens[1])
  moveApp { x = 0.5, y = 0, w = 0.5, h = 0.5 }
  positionApp('ChatGPT', screens[1])
  moveApp { x = 0.5, y = 0.5, w = 0.5, h = 0.5 }
  positionApp('WezTerm', screens[1])
  moveApp { x = 0, y = 0, w = 0.5, h = 1 }
end

--- Arrange Arc, ChatGPT, and WezTerm across three monitors.
--- Arc: right monitor, ChatGPT: middle monitor (maximized), WezTerm: left monitor.
--- @return nil
local arrange_3_monitors = function()
  local screens = hs.screen.allScreens()
  if #screens < 3 then return hs.alert.show 'Requires 3 displays!' end
  positionApp('Arc', screens[3])
  positionApp('ChatGPT', screens[2])
  moveApp 'maximize'
  positionApp('WezTerm', screens[1])
end

-- Mods
local ctrl_alt = { 'ctrl', 'alt' }
local ctrl_alt_cmd = { 'ctrl', 'alt', 'cmd' }

-- Reload
hs.hotkey.bind(ctrl_alt_cmd, 'h', 'Reload Hammerspoon Config', hs_reload)

-- Workspaces
hs.hotkey.bind(ctrl_alt_cmd, '1', 'Set Single Monitor Workspace', arrange_monitor)
hs.hotkey.bind(ctrl_alt_cmd, '2', 'Set 2 External Monitor Workspace', arrange_3_monitors)

-- Monitor placement
hs.hotkey.bind(ctrl_alt_cmd, 'Left', 'Left Display', function() moveApp 'next' end)
hs.hotkey.bind(ctrl_alt_cmd, 'Right', 'Right Display', function() moveApp 'previous' end)

-- Application hotkeys
hs.hotkey.bind(ctrl_alt_cmd, 'a', 'Toggle Anki', function() toggle 'Anki' end)
hs.hotkey.bind(ctrl_alt_cmd, 'b', 'Toggle Arc', function() toggle 'Arc' end)
hs.hotkey.bind(ctrl_alt_cmd, 'c', 'Toggle ChatGPT', function() toggle 'ChatGPT' end)
hs.hotkey.bind(ctrl_alt_cmd, 'd', 'Toggle Discord', function() toggle 'Discord' end)
hs.hotkey.bind(ctrl_alt_cmd, 'e', 'Toggle Notion Calendar', function() toggle 'Notion Calendar' end)
hs.hotkey.bind(ctrl_alt_cmd, 'f', 'Toggle Messenger', function() toggle 'Messenger' end)
hs.hotkey.bind(ctrl_alt_cmd, 'g', 'Toggle Google Chrome', function() toggle 'Google Chrome' end)
hs.hotkey.bind(ctrl_alt_cmd, 'i', 'Toggle Image2Icon', function() toggle 'Image2Icon' end)
hs.hotkey.bind(ctrl_alt_cmd, 'j', 'Toggle Hammerspoon', function() toggle 'Hammerspoon' end)
hs.hotkey.bind(ctrl_alt_cmd, 'k', 'Toggle Karabiner-Elements', function() toggle 'Karabiner-Elements' end)
hs.hotkey.bind(ctrl_alt_cmd, 'l', 'Toggle Slack', function() toggle 'Slack' end)
hs.hotkey.bind(ctrl_alt_cmd, 'm', 'Toggle Messages', function() toggle 'Messages' end)
hs.hotkey.bind(ctrl_alt_cmd, 'n', 'Toggle Notes', function() toggle 'Notes' end)
hs.hotkey.bind(ctrl_alt_cmd, 'p', 'Toggle Photos', function() toggle 'Photos' end)
hs.hotkey.bind(ctrl_alt_cmd, 'r', 'Toggle Reminders', function() toggle 'Reminders' end)
hs.hotkey.bind(ctrl_alt_cmd, 's', 'Toggle Spotify', function() toggle 'Spotify' end)
hs.hotkey.bind(ctrl_alt_cmd, 't', 'Toggle WhatsApp', function() toggle 'WhatsApp' end)
hs.hotkey.bind(ctrl_alt_cmd, 'v', 'Toggle VLC', function() toggle 'VLC' end)
hs.hotkey.bind(ctrl_alt_cmd, 'w', 'Toggle WezTerm', function() toggle 'WezTerm' end)
hs.hotkey.bind(ctrl_alt_cmd, 'x', 'Toggle System Settings', function() toggle 'System Settings' end)

-- Window sizing and placement
hs.hotkey.bind(ctrl_alt, 'Left', 'Left Half', function() moveApp { x = 0, y = 0, w = 0.5, h = 1 } end)
hs.hotkey.bind(ctrl_alt, 'Right', 'Right Half', function() moveApp { x = 0.5, y = 0, w = 0.5, h = 1 } end)
hs.hotkey.bind(ctrl_alt, 'C', 'Center Half', function() moveApp { x = 0.25, y = 0.25, w = 0.5, h = 0.5 } end)
hs.hotkey.bind(ctrl_alt, 'Up', 'Top Half', function() moveApp { x = 0, y = 0, w = 1, h = 0.5 } end)
hs.hotkey.bind(ctrl_alt, 'Down', 'Bottom Half', function() moveApp { x = 0, y = 0.5, w = 1, h = 0.5 } end)
hs.hotkey.bind(ctrl_alt, 'U', 'Top Left', function() moveApp { x = 0, y = 0, w = 0.5, h = 0.5 } end)
hs.hotkey.bind(ctrl_alt, 'I', 'Top Right', function() moveApp { x = 0.5, y = 0, w = 0.5, h = 0.5 } end)
hs.hotkey.bind(ctrl_alt, 'J', 'Bottom Left', function() moveApp { x = 0, y = 0.5, w = 0.5, h = 0.5 } end)
hs.hotkey.bind(ctrl_alt, 'K', 'Bottom Right', function() moveApp { x = 0.5, y = 0.5, w = 0.5, h = 0.5 } end)
hs.hotkey.bind(ctrl_alt, 'F', 'Maximize', function() moveApp 'maximize' end)
hs.hotkey.bind(ctrl_alt, 'A', 'Almost Maximize', almost_maximize)
