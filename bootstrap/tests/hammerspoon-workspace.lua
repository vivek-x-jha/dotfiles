-- Run with Lua, or: hs -c 'dofile("/path/to/dotfiles/bootstrap/tests/hammerspoon-workspace.lua")'
-- Exercise the real layout code without moving any desktop windows.
local path = debug.getinfo(1, 'S').source:sub(2)
local root = assert(path:match('^(.*)/bootstrap/tests/[^/]+$'))
local file = assert(io.open(root .. '/apps/hammerspoon/init.lua'))
local source = file:read('*a')
file:close()
local helpers = assert(source:match('(local wait_for_workspace = function.-)\n%-%-%- Arrange single monitor workspace'))
local layout = assert(source:match('(local arrange_3_monitors = function.-)\n%-%- All other hotkeys'))

local function fixture()
  local now, queue, focused, mutations = 0, {}, nil, 0
  local screens, apps, active, top = {}, {}, {}, {}
  local function later(delay, callback)
    queue[#queue + 1] = { at = now + delay, callback = callback }
  end
  local function drain()
    local count = 0
    while #queue > 0 do
      table.sort(queue, function(a, b) return a.at < b.at end)
      local event = table.remove(queue, 1)
      now = event.at
      event.callback()
      count = count + 1
      assert(count < 1000, 'unbounded retry')
    end
  end
  for i = 1, 3 do
    screens[i] = { id = function() return i end }
    active[i] = i
  end
  for i, name in ipairs({ 'Messages', 'Spotify', 'ChatGPT', 'VLC', 'Photos', 'Skim', 'Muse', 'Dia', 'WezTerm' }) do
    local win = { name = name, number = i, display = screens[2], fullscreen = name == 'ChatGPT' }
    local app = {}
    function app:mainWindow() return win end
    function app:activate() end
    function win:application() return app end
    function win:id() return self.number end
    function win:screen() return self.display end
    function win:isFullScreen() return self.fullscreen end
    function win:isStandard() return true end
    function win:raise() top[self.display:id()] = name end
    function win:focus()
      later(0.3, function()
        focused = self
        active[self.display:id()] = self.fullscreen and (100 + self.number) or self.display:id()
        top[self.display:id()] = name
        -- Switching the center Space may restack a previously fullscreen app.
        if name == 'WezTerm' then top[1] = 'ChatGPT' end
      end)
    end
    function win:setFullScreen(value)
      if value then assert(focused == self, 'fullscreen requested before focus settled: ' .. name) end
      mutations = mutations + 1
      later(0.4, function() self.fullscreen = value end)
      -- The Space animation can steal focus after the fullscreen flag changes.
      later(0.7, function()
        focused = self
        active[self.display:id()] = value and (100 + self.number) or self.display:id()
        top[self.display:id()] = name
      end)
    end
    function win:moveToScreen(screen)
      assert(not self.fullscreen, 'attempted to move a fullscreen window: ' .. name)
      mutations = mutations + 1
      self.display = screen
    end
    function win:maximize()
      assert(not self.fullscreen, 'attempted to maximize a fullscreen window: ' .. name)
      mutations = mutations + 1
      self.maximized = true
    end
    apps[name] = app
  end
  focused = apps.ChatGPT:mainWindow()
  local hs_mock = {
    application = { get = function(name) return apps[name] end },
    window = {
      focusedWindow = function() return focused end,
      orderedWindows = function()
        local windows = {}
        for _, name in pairs(top) do windows[#windows + 1] = apps[name]:mainWindow() end
        return windows
      end,
    },
    timer = { doAfter = later },
    alert = { show = function(message) error(message) end },
    spaces = {
      activeSpaceOnScreen = function(screen) return active[screen:id()] end,
      windowSpaces = function(win) return { win.fullscreen and (100 + win.number) or win.display:id() } end,
    },
    fnutils = { contains = function(values, value)
      for _, candidate in ipairs(values) do if candidate == value then return true end end
      return false
    end },
  }
  local env = setmetatable({ hs = hs_mock, screens_left_to_right = function() return screens end }, { __index = _G })
  local chunk = [[
local workspace_request_token = 0
local with_app_windows = function(names, callback)
  workspace_request_token = workspace_request_token + 1
  for _, name in ipairs(names) do assert(hs.application.get(name)) end
  callback()
end
]] .. helpers .. '\n' .. layout .. [[
return arrange_3_monitors, function() workspace_request_token = workspace_request_token + 1 end
]]
  local run, cancel = assert(load(chunk, 'workspace-test', 't', env))()
  local function verify()
    local expected = { Messages = 1, Spotify = 1, ChatGPT = 1, VLC = 1, Muse = 1, Photos = 2, WezTerm = 2, Skim = 3, Dia = 3 }
    for name, screen in pairs(expected) do
      local win = apps[name]:mainWindow()
      assert(win:screen():id() == screen, name .. ' on wrong screen')
      assert(win.fullscreen == (name == 'VLC' or name == 'Photos'), name .. ' wrong fullscreen state')
      assert(win.fullscreen or win.maximized, name .. ' not maximized')
    end
    assert(top[1] == 'Muse' and top[2] == 'WezTerm' and top[3] == 'Dia', 'wrong foreground windows')
    assert(focused.name == 'WezTerm', 'wrong final keyboard focus')
    for i = 1, 3 do assert(active[i] == i, 'fullscreen Space still visible') end
  end
  return run, drain, verify, cancel, function() return mutations end, later
end

local run, drain, verify = fixture()
run(); drain(); verify()
run(); drain(); verify()
print('ok: correct app targeting, fullscreen recovery, foreground ordering, repeated invocation')

local rapid, flush, check, _, _, later = fixture()
rapid()
later(0.2, rapid)
later(0.5, rapid)
flush(); check()
print('ok: rapid repeated invocation converges')

local start, finish, _, cancel, count = fixture()
start()
cancel()
local before = count()
finish()
assert(count() == before, 'cancelled workspace continued moving windows')
print('ok: newer workspace request cancels old callbacks')
