# Hammerspoon workspaces

Hotkeys use **Ctrl + Option + Command**. Bindings live in `apps/hammerspoon/init.lua`;
layout rules and the shared runner live in `apps/hammerspoon/workspace.lua`.

## Layouts

`1` uses the primary display (the only display when undocked):

| App | State |
| --- | --- |
| Dia, otherwise Chrome, otherwise Safari | Maximized |
| Messages | Maximized, then hidden |
| Spotify | Maximized, then hidden |
| WezTerm | Maximized, final keyboard focus |

`2` requires exactly three displays, ordered by their macOS arrangement from left
to right, and “Displays have separate Spaces” enabled:

| Display | Maximized | Native fullscreen |
| --- | --- | --- |
| Left | Messages, Spotify, ChatGPT, Muse | VLC |
| Center | WezTerm | Photos |
| Right | Skim, Dia | — |

The final visible apps are **Muse / WezTerm / Dia**, with keyboard focus on WezTerm.
VLC and Photos remain fullscreen in background Spaces. Triple mode explicitly
unhides its apps; covered windows are not hidden apps.

## Behavior

One asynchronous polling loop launches missing apps and arranges ready windows
concurrently. Ordinary move/resize operations do not activate each app. Only native
fullscreen transitions share a focus lock; an already-correct fullscreen window
is left alone. After placement, the foreground apps are layered on top and WezTerm
gets keyboard focus. WindowServer ordering avoids querying every running app.
Other windows belonging to an app are left alone, except that hiding/unhiding is
app-wide.

For a running app without a usable window, the runner first requests a native
reopen. If necessary, it uses an enabled **File → New Window / New Chat** command;
WezTerm instead uses its CLI. It never sends generic Cmd-N or opens an arbitrary
document. In particular, Skim may need you to open a PDF before it can be arranged.
Menu fallbacks currently use English menu names.

Unfinished app placement has a 15-second deadline; final foreground ordering has
a five-second deadline. There are no fixed waits between ordinary moves. One
unavailable app does not delay the other apps' placement, although the final
foreground pass waits until all apps have finished or failed. A newer hotkey
cancels the previous polling loop. Already-issued native launches and animations
cannot be undone; final checks repair late placement changes when possible.

Completion verifies placement, size (within four points), visibility, fullscreen,
foreground Spaces, stacking order, and keyboard focus. **Workspace ready** means
all checks passed; **Workspace incomplete** names failed steps. The console also
logs elapsed time. Avoid changing focus during fullscreen/Space transitions.

## Checks

Run the full runner against fake macOS APIs without moving desktop windows:

```sh
hs -c 'dofile(os.getenv("HOME") .. "/.dotfiles/bootstrap/tests/hammerspoon-workspace.lua")'
```

Alternatively run the test file with Lua 5.3+ using an absolute path. Fixtures
cover both layouts, delayed launch/focus/movement/fullscreen, hidden/minimized
windows, window creation, refused operations, partial failure, repeat runs, and
cancellation, parallel launch/placement, and latency budgets (warm triple and
ordinary single layouts under two simulated seconds). Live display/Space behavior
still needs a macOS smoke test.
