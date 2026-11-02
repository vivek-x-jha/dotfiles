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

-- Mods
local ctrl_alt = { 'ctrl', 'alt' }
local ctrl_alt_cmd = { 'ctrl', 'alt', 'cmd' }

-- Application hotkeys
---@type table<string, string>
local applications = {
  a = 'Anki',
  b = 'Dia',
  d = 'Muse',
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
--- Used by ctrl-alt-c; reserve five extra rows so Herdr retains a 36-row grid.
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

  if win:application():name() == 'iTerm2' then
    local ok = hs.osascript.applescript(string.format([[
      tell application "iTerm2"
        tell current session of current window
          if columns < %d then set columns to %d
          if rows < %d then set rows to %d
        end tell
      end tell
    ]], min_cols, min_cols, min_rows, min_rows))

    if not ok then return hs.alert.show 'Unable to enforce iTerm grid size' end

    local frame = win:frame()
    win:setTopLeft {
      x = clamp(centerX - (frame.w / 2), screenFrame.x, screenFrame.x + screenFrame.w - frame.w),
      y = clamp(centerY - (frame.h / 2), screenFrame.y, screenFrame.y + screenFrame.h - frame.h),
    }
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

local workspace = require 'workspace'

-- All other hotkeys
---@type Remap[]
local remaps = {
  -- Workspaces
  { mods = ctrl_alt_cmd, key = '1', message = 'Set Single Monitor Workspace', pressedfn = workspace.single },
  { mods = ctrl_alt_cmd, key = '2', message = 'Set 3 Monitor Workspace', pressedfn = workspace.triple },

  -- Monitor placement
  { mods = ctrl_alt_cmd, key = 'Left', message = 'Left Display', pressedfn = function() moveApp 'next' end },
  { mods = ctrl_alt_cmd, key = 'Right', message = 'Right Display', pressedfn = function() moveApp 'previous' end },

  -- Window sizing and placement
  { mods = ctrl_alt, key = 'Left', message = 'Left Half', pressedfn = function() moveApp { x = 0, y = 0, w = 0.5, h = 1 } end },
  { mods = ctrl_alt, key = 'Right', message = 'Right Half', pressedfn = function() moveApp { x = 0.5, y = 0, w = 0.5, h = 1 } end },
  { mods = ctrl_alt, key = 'C', message = 'Center Half', pressedfn = function() moveAppMinTerminalGrid({ x = 0.25, y = 0.25, w = 0.5, h = 0.5 }, 120, 41) end },
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
