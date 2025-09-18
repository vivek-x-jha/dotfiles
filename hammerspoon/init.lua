-- https://www.hammerspoon.org/docs/

------------------------------------ Console options ------------------------------------

-- Load colors from $HOME/.zshenv
local hex_from_zsh = function()
  local palette = {}
  local env_path = os.getenv 'HOME' .. '/.zshenv'
  local f = assert(io.open(env_path, 'r'), 'Failed to open $HOME/.zshenv')

  for line in f:lines() do
    -- Only match exports ending in _HEX
    local color, hex = line:match "^export%s+([A-Z_]+_HEX)%s*=%s*'?(#%x%x%x%x%x%x)'?"
    if color and hex then
      -- Drop the _HEX suffix and lowercase it
      color = color:match('^(.-)_HEX$'):lower()
      palette[color] = hex
    end
  end

  f:close()

  return palette
end

local thm = hex_from_zsh()

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

------------------------------------ Reload hotkey ------------------------------------

local ctrl_alt = { 'ctrl', 'alt' }
local ctrl_alt_cmd = { 'ctrl', 'alt', 'cmd' }

hs.hotkey.bind(ctrl_alt_cmd, 'h', 'Reload Config!', function()
  hs.reload()
  hs.console.clearConsole()
end)

------------------------------------ App Launcher hotkeys ------------------------------------

local app_hotkeys = {
  a = 'Anki',
  b = 'Arc',
  c = 'ChatGPT',
  d = 'Discord',
  e = 'Notion Calendar',
  f = 'Messenger',
  g = 'Google Chrome',
  i = 'Image2Icon',
  j = 'Hammerspoon',
  k = 'Karabiner-Elements',
  l = 'Slack',
  m = 'Messages',
  n = 'Notes',
  p = 'Photos',
  r = 'Reminders',
  s = 'Spotify',
  t = 'WhatsApp',
  v = 'VLC',
  w = 'WezTerm',
  x = 'System Settings',
}

for key, app in pairs(app_hotkeys) do
  hs.hotkey.bind(ctrl_alt_cmd, key, 'Toggle ' .. app, function()
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
  end)
end

------------------------------------ Window Manager hotkeys ------------------------------------

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
    win:moveToUnit(hs.geometry.rect(app_pos.x, app_pos.y, app_pos.w, app_pos.h))
  end
end

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

local window_hotkeys = {
  { mods = ctrl_alt_cmd, key = 'Left', desc = 'Left Display', cmd = function() moveApp 'next' end },
  { mods = ctrl_alt_cmd, key = 'Right', desc = 'Right Display', cmd = function() moveApp 'previous' end },
  { mods = ctrl_alt, key = 'Left', desc = 'Left Half', cmd = function() moveApp { x = 0, y = 0, w = 0.5, h = 1 } end },
  { mods = ctrl_alt, key = 'Right', desc = 'Right Half', cmd = function() moveApp { x = 0.5, y = 0, w = 0.5, h = 1 } end },
  { mods = ctrl_alt, key = 'C', desc = 'Center Half', cmd = function() moveApp { x = 0.25, y = 0.25, w = 0.5, h = 0.5 } end },
  { mods = ctrl_alt, key = 'Up', desc = 'Top Half', cmd = function() moveApp { x = 0, y = 0, w = 1, h = 0.5 } end },
  { mods = ctrl_alt, key = 'Down', desc = 'Bottom Half', cmd = function() moveApp { x = 0, y = 0.5, w = 1, h = 0.5 } end },
  { mods = ctrl_alt, key = 'U', desc = 'Top Left', cmd = function() moveApp { x = 0, y = 0, w = 0.5, h = 0.5 } end },
  { mods = ctrl_alt, key = 'I', desc = 'Top Right', cmd = function() moveApp { x = 0.5, y = 0, w = 0.5, h = 0.5 } end },
  { mods = ctrl_alt, key = 'J', desc = 'Bottom Left', cmd = function() moveApp { x = 0, y = 0.5, w = 0.5, h = 0.5 } end },
  { mods = ctrl_alt, key = 'K', desc = 'Bottom Right', cmd = function() moveApp { x = 0.5, y = 0.5, w = 0.5, h = 0.5 } end },
  { mods = ctrl_alt, key = 'F', desc = 'Maximize', cmd = function() moveApp 'maximize' end },
  { mods = ctrl_alt, key = 'A', desc = 'Almost Maximize', cmd = almost_maximize },
}

for _, m in ipairs(window_hotkeys) do
  hs.hotkey.bind(m.mods, m.key, m.desc, m.cmd)
end

------------------------------------ Workspace Manager hotkeys ------------------------------------

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

local workspaces = {
  {
    mods = ctrl_alt_cmd,
    key = '1',
    desc = 'Set Single Monitor Workspace',
    cmd = function()
      local screens = hs.screen.allScreens()

      -- Arc @ top right
      positionApp('Arc', screens[1])
      moveApp { x = 0.5, y = 0, w = 0.5, h = 0.5 }

      -- ChatGPT @ bottom right
      positionApp('ChatGPT', screens[1])
      moveApp { x = 0.5, y = 0.5, w = 0.5, h = 0.5 }

      -- WezTerm @ left half
      positionApp('WezTerm', screens[1])
      moveApp { x = 0, y = 0, w = 0.5, h = 1 }
    end,
  },

  {
    mods = ctrl_alt_cmd,
    key = '2',
    desc = 'Set 2 External Monitor Workspace',
    cmd = function()
      local screens = hs.screen.allScreens()
      if #screens < 3 then
        hs.alert.show 'Requires 3 displays!'
        return
      end

      positionApp('Arc', screens[3])
      positionApp('ChatGPT', screens[2])
      moveApp 'maximize'
      positionApp('WezTerm', screens[1])
    end,
  },
}

for _, m in ipairs(workspaces) do
  hs.hotkey.bind(m.mods, m.key, m.desc, m.cmd)
end
