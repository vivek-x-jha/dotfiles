return {
  {
    desc = 'Reload Config!',
    mods = { 'cmd', 'alt', 'ctrl' },
    key = 'h',
    command = function()
      hs.reload()
      hs.console.clearConsole()
    end,
  },
}
