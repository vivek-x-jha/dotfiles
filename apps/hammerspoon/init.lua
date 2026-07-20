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
  nvim_statusline = '#27283a',

  -- App specific
  nvim_bg = 'NONE',
  wezterm_bg = '#212030',
}

-- https://www.hammerspoon.org/docs/
hs.ipc.cliInstall()

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

---@class WindowRect
---@field x number
---@field y number
---@field w number
---@field h number

---@alias ScreenLike table
---@alias WindowLike table
---@alias AppPos '"next"'|'"previous"'|'"maximize"'|WindowRect

---@class AppHotkeyRow
---@field key string
---@field app string

---@class Remap
---@field mods string[]
---@field key string
---@field message string
---@field pressedfn fun()

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
    return
  end

  if not appObj then
    hs.application.launchOrFocus(app)
    return
  end

  appObj:activate()
  appObj:unhide()

  local win = appObj:mainWindow()
  if win then
    win:raise()
    win:focus()
  end
end

local thinkorswim_focus_token = 0

--- Give thinkorswim's Java login window an initial click so keyboard focus starts.
--- @param token number
--- @return nil
local focus_thinkorswim_login = function(token)
  if token ~= thinkorswim_focus_token then return end

  local app = hs.application.get 'java-arm' or hs.application.find 'java-arm' or hs.application.get 'thinkorswim'
  if not app then return end
  if app:isHidden() then return end

  app:activate()
  app:unhide()

  local win = app:mainWindow()
  if not win then return end

  win:raise()
  win:focus()

  local frame = win:frame()
  local point = {
    x = frame.x + math.floor(frame.w * 0.5),
    y = frame.y + math.floor(frame.h * 0.48),
  }

  hs.timer.doAfter(0.15, function()
    hs.mouse.absolutePosition(point)
    hs.eventtap.leftClick(point)
  end)
end

--- Toggle thinkorswim and seed keyboard focus after launch/focus.
--- @return nil
local toggle_thinkorswim = function()
  local app = hs.application.get 'java-arm' or hs.application.find 'java-arm' or hs.application.get 'thinkorswim'

  if app and app:isFrontmost() then
    thinkorswim_focus_token = thinkorswim_focus_token + 1
    app:hide()
    return
  end

  thinkorswim_focus_token = thinkorswim_focus_token + 1
  local token = thinkorswim_focus_token

  if not app then
    hs.application.launchOrFocus 'thinkorswim'
  else
    app:activate()
    app:unhide()
  end

  hs.timer.doAfter(2, function() focus_thinkorswim_login(token) end)
  hs.timer.doAfter(5, function() focus_thinkorswim_login(token) end)
  hs.timer.doAfter(10, function() focus_thinkorswim_login(token) end)
end

-- Mods
local ctrl_alt = { 'ctrl', 'alt' }
local ctrl_alt_cmd = { 'ctrl', 'alt', 'cmd' }

-- Application hotkeys
---@type table<string, string>
local applications = {
  a = 'Anki',
  b = 'Arc',
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
  q = 'thinkorswim',
  r = 'Reminders',
  s = 'Spotify',
  t = 'WhatsApp',
  u = 'Claude',
  v = 'VLC',
  w = 'WezTerm',
  x = 'System Settings',
  y = 'ChatGPT',
  z = 'WeChat',
  ['/'] = 'Hotkeys',
}

--- Show app hotkey reference from the applications table
--- @return nil
local show_app_hotkeys = function()
  ---@type AppHotkeyRow[]
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
  elseif app == 'thinkorswim' then
    pressedfn = toggle_thinkorswim
  end

  hs.hotkey.bind(ctrl_alt_cmd, key, message, pressedfn)
end

--- Move the currently focused window - accepts following arguments:
---  * 'next'     -> move to next screen
---  * 'previous' -> move to previous screen
---  * 'maximize' -> maximize window on current screen
---  * Provide a unit-rect table to place the window via hs.geometry.rect
--- @param app_pos AppPos
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

--- Clamp a number to a range.
--- @param value number
--- @param min_value number
--- @param max_value number
--- @return number
local clamp = function(value, min_value, max_value)
  return math.min(math.max(value, min_value), max_value)
end

--- Move the focused window to a unit rect, but keep it at least a terminal grid size.
--- Used by ctrl-alt-c so centered terminals do not shrink below 120 columns x 30 rows.
--- @param app_pos WindowRect
--- @param min_cols number
--- @param min_rows number
--- @return nil
local moveAppMinTerminalGrid = function(app_pos, min_cols, min_rows)
  local win = hs.window.focusedWindow()

  if not win then
    hs.alert.show 'No window to move'
    return
  end

  local screenFrame = win:screen():frame()
  local cell = { w = 9, h = 18 }
  local padding = { w = 35, h = 27 }
  local min_size = {
    w = (min_cols * cell.w) + padding.w,
    h = (min_rows * cell.h) + padding.h,
  }

  local width = math.min(math.max(screenFrame.w * app_pos.w, min_size.w), screenFrame.w)
  local height = math.min(math.max(screenFrame.h * app_pos.h, min_size.h), screenFrame.h)
  local centerX = screenFrame.x + (screenFrame.w * (app_pos.x + (app_pos.w / 2)))
  local centerY = screenFrame.y + (screenFrame.h * (app_pos.y + (app_pos.h / 2)))

  win:setFrame {
    x = clamp(centerX - (width / 2), screenFrame.x, screenFrame.x + screenFrame.w - width),
    y = clamp(centerY - (height / 2), screenFrame.y, screenFrame.y + screenFrame.h - height),
    w = width,
    h = height,
  }
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
--- @param screen ScreenLike  # target screen (e.g., hs.screen.mainScreen())
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

local workspace_request_token = 0

--- Ask an existing app to create a window.
--- WezTerm's CLI creates a fresh pane with its configured terminal environment;
--- synthetic Cmd-N events can reuse stale GUI process state.
--- @param appName string
--- @param app table
--- @return nil
local request_app_window = function(appName, app)
  if appName == 'WezTerm' then
    local wezterm = '/Applications/WezTerm.app/Contents/MacOS/wezterm'
    local task = hs.task.new(wezterm, function(exitCode, _, stderr)
      if exitCode ~= 0 then
        hs.alert.show 'Unable to open WezTerm window'
        print(stderr)
      end
    end, { 'start', '--cwd', os.getenv 'HOME' })

    if not task or not task:start() then hs.alert.show 'Unable to start WezTerm' end
    return
  end

  app:activate()
  hs.eventtap.keyStroke({ 'cmd' }, 'n', 0, app)
end

--- Launch missing apps, create a window for windowless apps, then run a callback.
--- A newer workspace request cancels retries from an older request.
--- @param appNames string[]
--- @param callback fun()
--- @return nil
local with_app_windows = function(appNames, callback)
  workspace_request_token = workspace_request_token + 1
  local token = workspace_request_token
  local max_attempts = 20
  local retry_delay = 0.5
  local window_requested = {}
  local check_windows

  check_windows = function(attempt)
    if token ~= workspace_request_token then return end

    local missing = {}

    for _, appName in ipairs(appNames) do
      local app = hs.application.get(appName)
      if not app then
        missing[#missing + 1] = appName
        hs.application.launchOrFocus(appName)
      elseif not app:mainWindow() then
        missing[#missing + 1] = appName

        if not window_requested[appName] then
          window_requested[appName] = true
          request_app_window(appName, app)
        end
      end
    end

    if #missing == 0 then
      callback()
    elseif attempt < max_attempts then
      hs.timer.doAfter(retry_delay, function() check_windows(attempt + 1) end)
    else
      hs.alert.show('Unable to open windows: ' .. table.concat(missing, ', '))
    end
  end

  check_windows(1)
end

--- Return screens sorted by their physical left-to-right position.
--- @return ScreenLike[]
local screens_left_to_right = function()
  local screens = hs.screen.allScreens()

  table.sort(screens, function(a, b) return a:frame().x < b:frame().x end)

  return screens
end

local browser_apps = {
  { name = 'Arc', bundle_id = 'company.thebrowser.Browser' },
  { name = 'Google Chrome', bundle_id = 'com.google.Chrome' },
  { name = 'Safari', bundle_id = 'com.apple.Safari' },
}

--- Pick the preferred available browser: Arc, then Google Chrome, then Safari.
--- @return string
local select_browser_app = function()
  for _, browser in ipairs(browser_apps) do
    if hs.application.get(browser.name) or hs.application.pathForBundleID(browser.bundle_id) then return browser.name end
  end

  return 'Safari'
end

--- Hide an app after workspace placement.
--- @param appName string
--- @return nil
local hide_app = function(appName)
  local app = hs.application.get(appName)
  if app then app:hide() end
end

--- Move an app to a screen and enter native macOS fullscreen.
--- @param appName string
--- @param screen ScreenLike
--- @return nil
local fullscreen_app = function(appName, screen)
  positionApp(appName, screen)
  local win = hs.window.focusedWindow()
  if win and not win:isFullScreen() then win:setFullScreen(true) end
end

--- Arrange single monitor workspace
--- @return nil
local arrange_monitor = function()
  local screens = hs.screen.allScreens()

  if #screens < 1 then return hs.alert.show 'No displays detected!' end

  local browser = select_browser_app()

  with_app_windows({ 'WezTerm', browser, 'Messages', 'Spotify' }, function()
    screens = hs.screen.allScreens()
    if #screens < 1 then return hs.alert.show 'No displays detected!' end

    positionApp(browser, screens[1])
    moveApp 'maximize'

    positionApp('Messages', screens[1])
    moveApp 'maximize'
    hide_app 'Messages'

    positionApp('Spotify', screens[1])
    moveApp 'maximize'
    hide_app 'Spotify'

    positionApp('WezTerm', screens[1])
    moveApp 'maximize'
  end)
end

--- Arrange 3 monitor workspace with WezTerm centered for terminal harnesses.
--- @return nil
local arrange_3_monitors = function()
  local screens = screens_left_to_right()

  if #screens < 3 then return hs.alert.show 'Requires 3 displays!' end

  with_app_windows({ 'Messages', 'Spotify', 'ChatGPT', 'VLC', 'Photos', 'WezTerm', 'Arc' }, function()
    screens = screens_left_to_right()
    if #screens < 3 then return hs.alert.show 'Requires 3 displays!' end

    positionApp('Messages', screens[1])
    moveApp 'maximize'
    positionApp('Spotify', screens[1])
    moveApp 'maximize'
    positionApp('ChatGPT', screens[1])
    moveApp 'maximize'
    fullscreen_app('VLC', screens[1])

    positionApp('Arc', screens[3])
    moveApp 'maximize'
    fullscreen_app('Photos', screens[2])

    positionApp('WezTerm', screens[2])
    moveApp 'maximize'
    hs.timer.doAfter(1, function()
      positionApp('WezTerm', screens[2])
      moveApp 'maximize'
    end)
  end)
end

-- All other hotkeys
---@type Remap[]
local remaps = {
  -- Workspaces
  { mods = ctrl_alt_cmd, key = '1', message = 'Set Single Monitor Workspace', pressedfn = arrange_monitor },
  { mods = ctrl_alt_cmd, key = '2', message = 'Set 3 Monitor Workspace', pressedfn = arrange_3_monitors },

  -- Monitor placement
  { mods = ctrl_alt_cmd, key = 'Left', message = 'Left Display', pressedfn = function() moveApp 'next' end },
  { mods = ctrl_alt_cmd, key = 'Right', message = 'Right Display', pressedfn = function() moveApp 'previous' end },

  -- Window sizing and placement
  { mods = ctrl_alt, key = 'Left', message = 'Left Half', pressedfn = function() moveApp { x = 0, y = 0, w = 0.5, h = 1 } end },
  { mods = ctrl_alt, key = 'Right', message = 'Right Half', pressedfn = function() moveApp { x = 0.5, y = 0, w = 0.5, h = 1 } end },
  { mods = ctrl_alt, key = 'C', message = 'Center Half', pressedfn = function() moveAppMinTerminalGrid({ x = 0.25, y = 0.25, w = 0.5, h = 0.5 }, 120, 30) end },
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

_G.hammerspoon_config_watcher = hs.pathwatcher.new(hs.configdir, function() hs.reload() end):start()
