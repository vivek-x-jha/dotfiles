return {
  {
    desc = 'Reload Config!',
    mods = { 'cmd', 'alt', 'ctrl' },
    key = 'R',
    command = function()
      hs.reload()
      hs.console.clearConsole()
      print 'Reloaded ~/.hammerspoon/'
    end,
  },
}
