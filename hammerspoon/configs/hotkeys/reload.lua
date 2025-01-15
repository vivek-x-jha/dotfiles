return {
  {
    desc = 'Reload Config!',
    mods = { 'cmd', 'alt', 'ctrl' },
    key = 'R',
    command = function()
      hs.reload()
      print 'Reloaded ~/.hammerspoon/'
    end,
  },
}
