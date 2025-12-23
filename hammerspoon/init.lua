--- Generate pallete table of hex values by parsing env color file
--- * File must contain lines in this format: `export *_HEX="#rrggbb"`
--- * key, value pairs look like: "cyan" = "#8ae7c5"
---
--- @param theme string -- Theme identifier (e.g. 'sourdiesel')
--- @return table<string, string>
local hexify = function(theme)
  local thm_path = os.getenv 'HOME' .. '/.config/zsh/themes/' .. theme .. '.sh'

  --- @type table<string, string>
  local palette = {}

  --- @type file* -- Opened file handle
  local f = assert(io.open(thm_path, 'r'), 'Failed to open ' .. thm_path)

  for line in f:lines() do
    --- @type string?, string? -- Extracted color name and hex code from line
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

--- @type table<string, string> -- Palette of colors
local thm = hexify 'sourdiesel'

-- https://www.hammerspoon.org/docs/
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

--- Toggle an app by name:
---  * If the app is frontmost -> hide it
---  * If not running -> launch/focus it
---  * Otherwise -> activate, unhide, and focus its main window
--- @param app string  # application display name (e.g. 'WezTerm', 'Safari')
--- @return nil
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

-- Mods
local ctrl_alt = { 'ctrl', 'alt' }
local ctrl_alt_cmd = { 'ctrl', 'alt', 'cmd' }

-- Application hotkeys
local applications = {
  a = 'Anki',
  b = 'Arc',
  c = 'ChatGPT',
  d = 'Discord',
  e = 'Notion Calendar',
  f = 'iPhone Mirroring',
  g = 'Google Chrome',
  h = 'Reload Hammerspoon',
  i = 'Image2Icon',
  j = 'Hammerspoon',
  k = 'Karabiner-Elements',
  l = 'Slack',
  m = 'Messages',
  n = 'Notes',
  o = 'Skim',
  p = 'Photos',
  r = 'Reminders',
  s = 'Spotify',
  t = 'WhatsApp',
  v = 'VLC',
  w = 'WezTerm',
  x = 'System Settings',
  z = 'WeChat',
}

for key, app in pairs(applications) do
  local cmd = key == 'h' and hs.reload or function() toggle(app) end
  hs.hotkey.bind(ctrl_alt_cmd, key, 'Toggle ' .. app, cmd)
end

--- Move the currently focused window - accepts following arguments:
---  * 'next'     -> move to next screen
---  * 'previous' -> move to previous screen
---  * 'maximize' -> maximize window on current screen
---  * Provide a unit-rect table to place the window via hs.geometry.rect
--- @param app_pos '"next"'|'"previous"'|'"maximize"'|{ x:number, y:number, w:number, h:number }
--- @return nil
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

--- Almost maximize the focused window with a uniform margin around border
--- @return nil
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
--- @return nil
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

--- Arrange single monitor workspace
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

--- Arrange 3 monitor workspace
--- @return nil
local arrange_3_monitors = function()
  local screens = hs.screen.allScreens()

  if #screens < 3 then return hs.alert.show 'Requires 3 displays!' end

  positionApp('Arc', screens[3])
  moveApp 'maximize'
  positionApp('ChatGPT', screens[2])
  moveApp 'maximize'
  positionApp('WezTerm', screens[1])
  moveApp 'maximize'
end

-- All other hotkeys
local remaps = {
  -- Workspaces
  { mods = ctrl_alt_cmd, keys = '1', desc = 'Set Single Monitor Workspace', cmd = arrange_monitor },
  { mods = ctrl_alt_cmd, keys = '2', desc = 'Set 2 External Monitor Workspace', cmd = arrange_3_monitors },

  -- Monitor placement
  { mods = ctrl_alt_cmd, keys = 'Left', desc = 'Left Display', cmd = function() moveApp 'next' end },
  { mods = ctrl_alt_cmd, keys = 'Right', desc = 'Right Display', cmd = function() moveApp 'previous' end },

  -- Window sizing and placement
  { mods = ctrl_alt, keys = 'Left', desc = 'Left Half', cmd = function() moveApp { x = 0, y = 0, w = 0.5, h = 1 } end },
  { mods = ctrl_alt, keys = 'Right', desc = 'Right Half', cmd = function() moveApp { x = 0.5, y = 0, w = 0.5, h = 1 } end },
  { mods = ctrl_alt, keys = 'C', desc = 'Center Half', cmd = function() moveApp { x = 0.25, y = 0.25, w = 0.5, h = 0.5 } end },
  { mods = ctrl_alt, keys = 'Up', desc = 'Top Half', cmd = function() moveApp { x = 0, y = 0, w = 1, h = 0.5 } end },
  { mods = ctrl_alt, keys = 'Down', desc = 'Bottom Half', cmd = function() moveApp { x = 0, y = 0.5, w = 1, h = 0.5 } end },
  { mods = ctrl_alt, keys = 'U', desc = 'Top Left', cmd = function() moveApp { x = 0, y = 0, w = 0.5, h = 0.5 } end },
  { mods = ctrl_alt, keys = 'I', desc = 'Top Right', cmd = function() moveApp { x = 0.5, y = 0, w = 0.5, h = 0.5 } end },
  { mods = ctrl_alt, keys = 'J', desc = 'Bottom Left', cmd = function() moveApp { x = 0, y = 0.5, w = 0.5, h = 0.5 } end },
  { mods = ctrl_alt, keys = 'K', desc = 'Bottom Right', cmd = function() moveApp { x = 0.5, y = 0.5, w = 0.5, h = 0.5 } end },
  { mods = ctrl_alt, keys = 'F', desc = 'Maximize', cmd = function() moveApp 'maximize' end },
  { mods = ctrl_alt, keys = 'A', desc = 'Almost Maximize', cmd = almost_maximize },
}

for _, m in ipairs(remaps) do
  hs.hotkey.bind(m.mods, m.keys, m.desc, m.cmd)
end
