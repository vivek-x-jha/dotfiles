local theme = require 'colors.sourdiesel'

return {
  toolbar = false,
  alpha = 0.98,
  consoleCommandColor = { hex = theme.green },
  consoleFont = { name = 'JetBrainsMono Nerd Font', size = 15 },
  consolePrintColor = { hex = theme.brightmagenta },
  consoleResultColor = { hex = theme.red },
  darkMode = true,
  inputBackgroundColor = { hex = theme.background },
  outputBackgroundColor = { hex = theme.background },
  titleVisibility = 'hidden',
  windowBackgroundColor = { hex = theme.background },
}
