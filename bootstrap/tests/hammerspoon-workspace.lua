-- Lua 5.3+, or: hs -c 'dofile("/absolute/path/to/bootstrap/tests/hammerspoon-workspace.lua")'
-- Load the complete production module with fake macOS APIs; never touch real windows.
local path = debug.getinfo(1, 'S').source:sub(2)
local root = assert(path:match '^(.*)/bootstrap/tests/[^/]+$')

local function fixture(options)
  local opts = options or {}
  local now, queue, focused, mutations = 0, {}, nil, 0
  local screens, apps, active, top, alerts, launches, tasks, focuses = {}, {}, {}, {}, {}, {}, {}, {}
  local function later(delay, callback) queue[#queue + 1] = { at = now + delay, callback = callback } end
  local function drain()
    local count = 0
    while #queue > 0 do
      table.sort(queue, function(a, b) return a.at < b.at end)
      local event = table.remove(queue, 1)
      now = event.at
      event.callback()
      count = count + 1
      assert(count < 5000, 'unbounded retry')
    end
  end
  for i = 1, opts.screen_count or 3 do
    local frame = { x = (i - 1) * 1920, y = 25, w = 1920, h = 1055 }
    screens[i] = { id = function() return i end, frame = function() return frame end, fullFrame = function() return frame end }
    active[i] = i
  end
  local primary = screens[2] or screens[1]
  for i, name in ipairs { 'Messages', 'Spotify', 'ChatGPT', 'VLC', 'Photos', 'Skim', 'Muse', 'Dia', 'WezTerm', 'Safari', 'Google Chrome' } do
    local win = {
      name = name,
      number = i,
      display = primary,
      fullscreen = name == 'ChatGPT',
      minimized = name == 'WezTerm',
      rect = { x = 40, y = 40, w = 800, h = 600 },
    }
    local app = { running = not opts.cold, has_window = not opts.cold, hidden = name == 'Spotify', win = win }
    if name == opts.windowless then app.has_window = false end
    if name == opts.absent then app.running = false end
    function app:mainWindow()
      if self.has_window and not opts.no_main then return win end
    end
    function app:allWindows() return self.has_window and { win } or {} end
    function app:activate() end -- Deliberately does not synchronously focus the window.
    function app:isHidden() return self.hidden end
    function app:hide() self.hidden = true end
    function app:unhide() self.hidden = false end
    function app:findMenuItem(menu)
      if name == 'ChatGPT' and menu[2] == 'New Window' then return { enabled = true } end
    end
    function app:selectMenuItem()
      self.menu_requests = (self.menu_requests or 0) + 1
      later(0.3, function() self.has_window = true end)
    end
    function win:application() return app end
    function win:id() return self.number end
    function win:screen() return self.display end
    function win:frame() return self.rect end
    function win:isFullScreen() return self.fullscreen end
    function win:isStandard() return true end
    function win:isMinimized() return self.minimized end
    function win:unminimize() self.minimized = false end
    function win:raise() top[self.display:id()] = name end
    function win:focus()
      focuses[name] = (focuses[name] or 0) + 1
      later(0.3, function()
        focused = self
        active[self.display:id()] = self.fullscreen and (100 + self.number) or self.display:id()
        top[self.display:id()] = name
        if name == 'WezTerm' and apps.ChatGPT.win.display == screens[1] then top[1] = 'ChatGPT' end
        if name == 'WezTerm' and opts.drift then apps.Messages.hidden = true end
      end)
    end
    function win:setFullScreen(value)
      if name == opts.throw_fullscreen then error 'window disappeared' end
      assert(focused == self, 'fullscreen requested before focus settled: ' .. name)
      mutations = mutations + 1
      later(0.4, function() self.fullscreen = value end)
      -- Native animations can outlive the AX fullscreen flag change.
      later(0.9, function()
        focused = self
        active[self.display:id()] = value and (100 + self.number) or self.display:id()
        top[self.display:id()] = name
      end)
    end
    function win:moveToScreen(screen)
      assert(not self.fullscreen, 'moved a fullscreen window: ' .. name)
      mutations = mutations + 1
      if name ~= opts.refuse_move then later(0.3, function() self.display = screen end) end
    end
    function win:maximize()
      assert(not self.fullscreen, 'maximized a fullscreen window: ' .. name)
      mutations = mutations + 1
      if name ~= opts.refuse_size then later(0.2, function() self.rect = self.display:frame() end) end
    end
    apps[name] = app
  end
  focused = apps.ChatGPT.win
  local mock = {
    application = {
      get = function(name) return apps[name] and apps[name].running and apps[name] or nil end,
      pathForBundleID = function(id) return id == 'company.thebrowser.dia' and '/Applications/Dia.app' or nil end,
    },
    task = {
      new = function(executable, callback, args)
        return {
          start = function()
            local name = executable == '/usr/bin/open' and args[2] or 'WezTerm'
            tasks[name] = (tasks[name] or 0) + 1
            if not apps[name].running then launches[name] = (launches[name] or 0) + 1 end
            later(0.3, function()
              if name == opts.absent then
                callback(1)
                return
              end
              apps[name].running = true
              -- Reopen cannot manufacture a document for document-based apps.
              if name ~= opts.windowless or executable ~= '/usr/bin/open' then apps[name].has_window = true end
              callback(0)
            end)
            return true
          end,
        }
      end,
    },
    screen = {
      find = function(rect) return screens[math.floor(rect.x / 1920) + 1] end,
      primaryScreen = function() return primary end,
      allScreens = function()
        -- Enumeration order is intentionally NOT physical order.
        return #screens == 3 and { screens[2], screens[3], screens[1] } or screens
      end,
    },
    window = {
      focusedWindow = function() return focused end,
      orderedWindows = function() error 'slow all-app window scan must not be used' end,
      list = function()
        local windows = {}
        for _, name in pairs(top) do
          local win = apps[name].win
          if not apps[name].hidden then
            local f = win.display:frame()
            windows[#windows + 1] = {
              kCGWindowNumber = win:id(),
              kCGWindowLayer = 0,
              kCGWindowIsOnscreen = true,
              kCGWindowBounds = { X = f.x, Y = f.y, Width = f.w, Height = f.h },
            }
          end
        end
        return windows
      end,
    },
    timer = { doAfter = later, secondsSinceEpoch = function() return now end },
    alert = { show = function(message) alerts[#alerts + 1] = message end },
    spaces = {
      screensHaveSeparateSpaces = function() return opts.separate_spaces ~= false end,
      activeSpaceOnScreen = function(screen) return active[screen:id()] end,
      spaceType = function(id) return id > 100 and 'fullscreen' or 'user' end,
      windowSpaces = function(win) return { win.fullscreen and (100 + win.number) or win.display:id() } end,
    },
    fnutils = {
      contains = function(values, value)
        for _, candidate in ipairs(values) do
          if candidate == value then return true end
        end
        return false
      end,
    },
  }
  local env = setmetatable({ hs = mock, print = function() end }, { __index = _G })
  local workspace = assert(loadfile(root .. '/apps/hammerspoon/workspace.lua', 't', env))()
  local function verify(single, skipped)
    local expected = single and { Dia = primary:id(), Messages = primary:id(), Spotify = primary:id(), WezTerm = primary:id() }
      or { Messages = 1, Spotify = 1, ChatGPT = 1, VLC = 1, Muse = 1, Photos = 2, WezTerm = 2, Skim = 3, Dia = 3 }
    for name, screen in pairs(expected) do
      if name ~= skipped then
        local app, win = apps[name], apps[name].win
        assert(app.running and app.has_window, name .. ' unavailable')
        assert(win:screen():id() == screen, name .. ' on wrong screen')
        assert(win.fullscreen == (not single and (name == 'VLC' or name == 'Photos')), name .. ' wrong fullscreen state')
        assert(win.fullscreen or win.rect == win.display:frame(), name .. ' not maximized')
        assert(not win.minimized, name .. ' still minimized')
        assert(app.hidden == (single and (name == 'Messages' or name == 'Spotify')), name .. ' wrong visibility')
      end
    end
    assert(focused.name == 'WezTerm', 'wrong final keyboard focus')
    if not single then
      assert(top[1] == 'Muse' and top[2] == 'WezTerm' and top[3] == 'Dia', 'wrong foreground windows')
      for i = 1, 3 do
        assert(active[i] == i, 'fullscreen Space still visible')
      end
    end
    if not skipped then assert(alerts[#alerts] == 'Workspace ready', tostring(alerts[#alerts])) end
  end
  return {
    run = workspace,
    drain = drain,
    verify = verify,
    later = later,
    apps = apps,
    alerts = alerts,
    launches = launches,
    tasks = tasks,
    focuses = focuses,
    elapsed = function() return now end,
    mutations = function() return mutations end,
  }
end

local f = fixture()
f.run.triple()
f.drain()
f.verify(false)
f.run.triple()
f.drain()
f.verify(false)
f.run.single()
f.drain()
f.verify(true)
f.run.triple()
f.drain()
f.verify(false)
print 'ok: triple/single switching, repeatability, physical displays, hidden/minimized recovery, focus and Spaces'

local fast = fixture()
fast.run.triple()
fast.drain()
fast.verify(false)
local before = fast.elapsed()
fast.run.triple()
fast.drain()
fast.verify(false)
assert(fast.elapsed() - before < 2, 'warm triple workspace is serializing unnecessary waits')
for _, name in ipairs { 'Messages', 'Spotify', 'Skim' } do
  assert(not fast.focuses[name], name .. ' stole focus during ordinary placement')
end
local single = fixture()
single.run.single()
single.drain()
single.verify(true)
assert(single.elapsed() < 2, 'single workspace is serializing unnecessary waits')
for _, name in ipairs { 'Dia', 'Messages', 'Spotify' } do
  assert(not single.focuses[name], name .. ' stole focus during single workspace placement')
end
print 'ok: warm triple and single complete under 2 simulated seconds; background placement does not steal focus'

for _, count in ipairs { 1, 3 } do
  local s = fixture { screen_count = count, no_main = true }
  s.apps.Dia.win.fullscreen = true
  s.run.single()
  s.drain()
  s.verify(true)
end
print 'ok: single mode on one or three displays, fullscreen recovery, standard-window fallback'

local cold = fixture { cold = true, windowless = 'ChatGPT' }
cold.run.triple()
for _, name in ipairs { 'Messages', 'Spotify', 'ChatGPT', 'VLC', 'Photos', 'Skim', 'Muse', 'Dia', 'WezTerm' } do
  assert(cold.launches[name] == 1, name .. ' was not launched in the first pass')
end
cold.drain()
cold.verify(false)
assert(cold.apps.ChatGPT.menu_requests == 1 and cold.tasks.ChatGPT == 1)
for _, count in pairs(cold.launches) do
  assert(count == 1, 'repeated launch')
end
local terminal = fixture { windowless = 'WezTerm' }
terminal.run.single()
terminal.drain()
terminal.verify(true)
assert(terminal.tasks.WezTerm == 2, 'expected reopen then terminal CLI')
print 'ok: cold launch, windowless ChatGPT menu fallback, WezTerm CLI, bounded creation requests'

for _, options in ipairs {
  { absent = 'ChatGPT' },
  { windowless = 'Skim' },
  { refuse_move = 'Messages' },
  { refuse_size = 'Spotify' },
  { throw_fullscreen = 'VLC' },
} do
  local name = options.absent or options.windowless or options.refuse_move or options.refuse_size or options.throw_fullscreen
  local broken = fixture(options)
  broken.run.triple()
  broken.drain()
  broken.verify(false, name)
  assert(broken.alerts[#broken.alerts]:match 'Workspace incomplete:' and broken.alerts[#broken.alerts]:find(name))
end
print 'ok: missing/windowless apps, refused moves/resizes and API errors do not block remaining apps'

local drift = fixture { drift = true }
drift.run.triple()
drift.drain()
drift.verify(false)
print 'ok: final verification repairs late state changes'

local rapid = fixture()
rapid.run.triple()
rapid.later(0.2, rapid.run.single)
rapid.later(0.5, rapid.run.triple)
rapid.drain()
rapid.verify(false)
assert(#rapid.alerts == 1, 'cancelled run reported completion')
local cancel = fixture { screen_count = 1, cold = true }
cancel.run.single()
cancel.run.triple() -- Even an invalid newer request cancels the older run.
local before = cancel.mutations()
cancel.drain()
assert(cancel.mutations() == before and #cancel.alerts == 1)
for _, count in ipairs { 0, 2, 4 } do
  local displays = fixture { screen_count = count }
  if count == 0 then
    displays.run.single()
  else
    displays.run.triple()
  end
  displays.drain()
  assert(displays.mutations() == 0 and #displays.alerts == 1)
end
local spaces = fixture { separate_spaces = false }
spaces.run.triple()
spaces.drain()
assert(spaces.mutations() == 0 and spaces.alerts[1]:find 'separate Spaces')
for _, mode in ipairs { 'single', 'triple' } do
  local interrupted = fixture()
  interrupted.run.triple()
  interrupted.later(0.8, interrupted.run[mode]) -- Cancel during a native fullscreen transition.
  interrupted.drain()
  interrupted.verify(mode == 'single')
  assert(#interrupted.alerts == 1, 'cancelled fullscreen run reported completion')
end
local stalled = fixture { windowless = 'Skim' }
stalled.run.triple()
stalled.later(1, function()
  assert(stalled.apps.Spotify.win.display:id() == 1, 'windowless app blocked unrelated placement')
  assert(stalled.apps.Dia.win.display:id() == 3, 'windowless app blocked later layout entries')
end)
stalled.drain()
stalled.verify(false, 'Skim')
print 'ok: cancellation during native transitions, rapid repeats, concurrent placement and display preconditions'
