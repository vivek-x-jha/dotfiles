local M = {}
local request = 0

local function window_for(app)
  if not app then return end
  local win = app:mainWindow()
  if win and win:isStandard() then return win end
  for _, candidate in ipairs(app:allWindows()) do
    if candidate:isStandard() then return candidate end
  end
end

local function task(run, executable, args)
  local process = hs.task.new(executable, function() end, args)
  if not process or not process:start() then error 'could not request a window' end
  run.tasks[#run.tasks + 1] = process
end

local function on_active_space(win) return hs.fnutils.contains(hs.spaces.windowSpaces(win) or {}, hs.spaces.activeSpaceOnScreen(win:screen())) end

local function focused(win)
  local current = hs.window.focusedWindow()
  return current and current:id() == win:id()
end

local function geometry_matches(row)
  if row.win:screen():id() ~= row.screen:id() then return false end
  if row.mode == 'fullscreen' then return true end
  local actual, target = row.win:frame(), row.screen:frame()
  for _, key in ipairs { 'x', 'y', 'w', 'h' } do
    if math.abs(actual[key] - target[key]) > 4 then return false end
  end
  return true
end

-- Only native fullscreen transitions share keyboard focus; ordinary placement is concurrent.
local function fullscreen(run, row, value, now)
  row.stage = value and 'entering fullscreen' or 'leaving fullscreen'
  if run.fullscreen and run.fullscreen ~= row then return false end
  run.fullscreen = row
  local win = row.win
  if row.transition == nil then
    if not focused(win) or not on_active_space(win) then
      win:focus()
      return false
    end
    win:setFullScreen(value)
    row.transition = value
    return false
  end
  if
    win:isFullScreen() ~= value
    or not on_active_space(win)
    or (not value and hs.spaces.spaceType(hs.spaces.activeSpaceOnScreen(win:screen())) ~= 'user')
  then
    row.settled = nil
    return false
  end
  row.settled = row.settled or now
  if now - row.settled < 0.4 then return false end
  run.fullscreen, row.transition, row.settled = nil, nil, nil
  return true
end

local function place(run, row, now)
  row.stage = 'opening a usable window'
  local app = hs.application.get(row.name)
  row.win = row.win or window_for(app)
  if not row.win then
    if not row.launched then
      row.launched = true
      -- Launch Services also reopens windowless apps, without a blind Cmd-N.
      task(run, '/usr/bin/open', { '-a', row.name })
    elseif app and now - run.started >= 2 and not row.created then
      row.created = true
      if row.name == 'WezTerm' then
        task(run, '/Applications/WezTerm.app/Contents/MacOS/wezterm', { 'start', '--cwd', os.getenv 'HOME' })
      else
        for _, path in ipairs { { 'File', 'New Window' }, { 'File', 'New Chat' } } do
          local item = app:findMenuItem(path)
          if item and item.enabled then
            app:selectMenuItem(path)
            break
          end
        end
      end
    end
    return false
  end
  local win = row.win
  if not app or not win:application() then error 'window disappeared' end
  if app:isHidden() and (row.mode ~= 'hidden' or win:isFullScreen()) then app:unhide() end
  if win:isMinimized() then win:unminimize() end
  if row.transition ~= nil and not fullscreen(run, row, row.transition, now) then return false end
  if win:isFullScreen() and (row.mode ~= 'fullscreen' or win:screen():id() ~= row.screen:id()) then
    fullscreen(run, row, false, now)
    return false
  end
  row.stage = 'moving to display'
  if win:screen():id() ~= row.screen:id() then
    win:moveToScreen(row.screen, false, true, 0)
    return false
  end
  if row.mode == 'fullscreen' and not win:isFullScreen() then return fullscreen(run, row, true, now) end
  row.stage = 'maximizing'
  if not geometry_matches(row) then
    win:maximize(0)
    return false
  end
  row.stage = 'applying visibility'
  if row.mode == 'hidden' and not app:isHidden() then app:hide() end
  return app:isHidden() == (row.mode == 'hidden') and not win:isMinimized()
end

local function layer(layout, foreground, by_name)
  for _, row in ipairs(layout) do
    if row.done then
      local win = row.win
      if
        not geometry_matches(row)
        or win:isFullScreen() ~= (row.mode == 'fullscreen')
        or win:isMinimized()
        or win:application():isHidden() ~= (row.mode == 'hidden')
      then
        -- A native move issued by a cancelled run can finish late. Reconcile it.
        row.done = false
        return false
      end
    end
  end
  local top, last = {}, nil
  -- WindowServer order avoids orderedWindows() querying every running app over AX.
  for _, win in ipairs(hs.window.list()) do
    if win.kCGWindowLayer == 0 and win.kCGWindowIsOnscreen then
      local b = win.kCGWindowBounds
      local screen = hs.screen.find { x = b.X, y = b.Y, w = b.Width, h = b.Height }
      if screen and not top[screen:id()] then top[screen:id()] = win.kCGWindowNumber end
    end
  end
  local settled = true
  for _, name in ipairs(foreground) do
    local row = by_name[name]
    if row.done then
      last = row.win
      -- Switch only inactive foreground Spaces; raising alone preserves keyboard focus.
      if not on_active_space(last) then
        last:focus()
        return false
      end
      if top[row.screen:id()] ~= last:id() then
        last:raise()
        settled = false
      end
    end
  end
  if last and not focused(last) then
    last:focus()
    return false
  end
  return settled
end

local function arrange(layout, foreground, token)
  local run = { started = hs.timer.secondsSinceEpoch(), tasks = {} }
  local by_name, errors, finishing, stable = {}, {}, nil, 0
  for _, row in ipairs(layout) do
    by_name[row.name] = row
  end
  local function tick()
    if token ~= request then return end
    local now, pending = hs.timer.secondsSinceEpoch(), false
    for _, row in ipairs(layout) do
      if not row.done and not row.error then
        local ok, done = pcall(place, run, row, now)
        if ok and done then
          row.done = true
        elseif not ok or now - run.started >= 15 then
          row.error = row.name .. ': ' .. (ok and (row.stage .. ' timed out') or tostring(done))
          errors[#errors + 1] = row.error
          if run.fullscreen == row then run.fullscreen = nil end
        else
          pending = true
        end
      end
    end
    if pending then
      finishing, stable = nil, 0
    else
      finishing = finishing or now
      local ok, done = pcall(layer, layout, foreground, by_name)
      stable = ok and done and (stable + 1) or 0
      if not ok or stable >= 5 or now - finishing >= 5 then
        if not ok then
          errors[#errors + 1] = tostring(done)
        elseif stable < 5 then
          errors[#errors + 1] = 'foreground/focus timed out'
        end
        local message = #errors == 0 and 'Workspace ready' or ('Workspace incomplete:\n' .. table.concat(errors, '\n'))
        print(string.format('%s (%.2fs)', message, now - run.started))
        hs.alert.show(message)
        return
      end
    end
    hs.timer.doAfter(0.1, tick)
  end
  tick()
end

function M.single()
  request = request + 1
  local screen = hs.screen.primaryScreen()
  if not screen then return hs.alert.show 'No displays detected!' end
  local browser = 'Safari'
  for _, candidate in ipairs { { 'Dia', 'company.thebrowser.dia' }, { 'Google Chrome', 'com.google.Chrome' } } do
    if hs.application.get(candidate[1]) or hs.application.pathForBundleID(candidate[2]) then
      browser = candidate[1]
      break
    end
  end
  arrange({
    { name = browser, screen = screen, mode = 'maximize' },
    { name = 'Messages', screen = screen, mode = 'hidden' },
    { name = 'Spotify', screen = screen, mode = 'hidden' },
    { name = 'WezTerm', screen = screen, mode = 'maximize' },
  }, { 'WezTerm' }, request)
end

function M.triple()
  request = request + 1
  local screens = hs.screen.allScreens()
  table.sort(screens, function(a, b) return a:fullFrame().x < b:fullFrame().x end)
  if #screens ~= 3 then return hs.alert.show 'Requires exactly 3 displays!' end
  if not hs.spaces.screensHaveSeparateSpaces() then return hs.alert.show 'Enable “Displays have separate Spaces” before using this workspace.' end
  arrange({
    { name = 'Messages', screen = screens[1], mode = 'maximize' },
    { name = 'Spotify', screen = screens[1], mode = 'maximize' },
    { name = 'ChatGPT', screen = screens[1], mode = 'maximize' },
    { name = 'VLC', screen = screens[1], mode = 'fullscreen' },
    { name = 'Photos', screen = screens[2], mode = 'fullscreen' },
    { name = 'Skim', screen = screens[3], mode = 'maximize' },
    { name = 'Muse', screen = screens[1], mode = 'maximize' },
    { name = 'Dia', screen = screens[3], mode = 'maximize' },
    { name = 'WezTerm', screen = screens[2], mode = 'maximize' },
  }, { 'Muse', 'Dia', 'WezTerm' }, request)
end

return M
