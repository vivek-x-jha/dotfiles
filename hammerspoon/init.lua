-- Main palette
local thm = {
  -- Base16
  black = '#cccccc',
  red = '#ffc7c7',
  green = '#ceffc9',
  yellow = '#fdf7cd',
  blue = '#c4effa',
  magenta = '#eccef0',
  cyan = '#8ae7c5',
  white = '#f4f3f2',
  brightblack = '#5c617d',
  brightred = '#f096b7',
  brightgreen = '#d2fd9d',
  brightyellow = '#f3b175',
  brightblue = '#80d7fe',
  brightmagenta = '#c9ccfb',
  brightcyan = '#47e7b1',
  brightwhite = '#ffffff',

  -- Other
  dark = '#1b1c28',
  grey = '#313244',

  -- App specific
  nvim_bg = 'NONE',
  wezterm_bg = '#212030',
}

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
  ['/'] = 'Hotkeys',
}

--- Show app hotkey reference from the applications table
--- @return nil
local show_app_hotkeys = function()
  local rows = {}

  for key, app in pairs(applications) do
    rows[#rows + 1] = { key = key, app = app }
  end

  table.sort(rows, function(a, b) return a.key < b.key end)

  local lines = { 'Apps (ctrl+alt+cmd)' }
  for _, row in ipairs(rows) do
    lines[#lines + 1] = string.format('%s  %s', row.key:upper(), row.app)
  end

  hs.alert.show(table.concat(lines, '\n'), {
    textSize = 18,
    radius = 12,
    atScreenEdge = 2,
    fillColor = { hex = thm.dark, alpha = 0.96 },
    strokeColor = { hex = thm.brightmagenta, alpha = 0.9 },
    textColor = { hex = thm.green, alpha = 1 },
  }, hs.screen.mainScreen(), 5)
end

-- Bind application hotkeys defined in the applications table
for key, app in pairs(applications) do
  local message = 'Toggle ' .. app
  local pressedfn = function() toggle(app) end

  if key == 'h' then
    message = app
    pressedfn = hs.reload
  elseif key == '/' then
    pressedfn = show_app_hotkeys
  end

  hs.hotkey.bind(ctrl_alt_cmd, key, message, pressedfn)
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
  { mods = ctrl_alt_cmd, key = '1', message = 'Set Single Monitor Workspace', pressedfn = arrange_monitor },
  { mods = ctrl_alt_cmd, key = '2', message = 'Set 2 External Monitor Workspace', pressedfn = arrange_3_monitors },

  -- Monitor placement
  { mods = ctrl_alt_cmd, key = 'Left', message = 'Left Display', pressedfn = function() moveApp 'next' end },
  { mods = ctrl_alt_cmd, key = 'Right', message = 'Right Display', pressedfn = function() moveApp 'previous' end },

  -- Window sizing and placement
  { mods = ctrl_alt, key = 'Left', message = 'Left Half', pressedfn = function() moveApp { x = 0, y = 0, w = 0.5, h = 1 } end },
  { mods = ctrl_alt, key = 'Right', message = 'Right Half', pressedfn = function() moveApp { x = 0.5, y = 0, w = 0.5, h = 1 } end },
  { mods = ctrl_alt, key = 'C', message = 'Center Half', pressedfn = function() moveApp { x = 0.25, y = 0.25, w = 0.5, h = 0.5 } end },
  { mods = ctrl_alt, key = 'Up', message = 'Top Half', pressedfn = function() moveApp { x = 0, y = 0, w = 1, h = 0.5 } end },
  { mods = ctrl_alt, key = 'Down', message = 'Bottom Half', pressedfn = function() moveApp { x = 0, y = 0.5, w = 1, h = 0.5 } end },
  { mods = ctrl_alt, key = 'U', message = 'Top Left', pressedfn = function() moveApp { x = 0, y = 0, w = 0.5, h = 0.5 } end },
  { mods = ctrl_alt, key = 'I', message = 'Top Right', pressedfn = function() moveApp { x = 0.5, y = 0, w = 0.5, h = 0.5 } end },
  { mods = ctrl_alt, key = 'J', message = 'Bottom Left', pressedfn = function() moveApp { x = 0, y = 0.5, w = 0.5, h = 0.5 } end },
  { mods = ctrl_alt, key = 'K', message = 'Bottom Right', pressedfn = function() moveApp { x = 0.5, y = 0.5, w = 0.5, h = 0.5 } end },
  { mods = ctrl_alt, key = 'F', message = 'Maximize', pressedfn = function() moveApp 'maximize' end },
  { mods = ctrl_alt, key = 'A', message = 'Almost Maximize', pressedfn = almost_maximize },
}

for _, m in ipairs(remaps) do
  hs.hotkey.bind(m.mods, m.key, m.message, m.pressedfn)
end
