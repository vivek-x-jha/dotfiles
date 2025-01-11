-- Hide Toolbar
hs.console.toolbar(nil)

-- Set transparency
hs.console.alpha(0.95)

-- -- Close the Preferences window if it's open
-- local prefsWindow = hs.application.get('Hammerspoon'):findWindow 'Preferences'
-- if prefsWindow then prefsWindow:close() end
--
-- -- Open the Console window and bring it to focus
-- hs.console.clearConsole() -- Optional: Clear the console on startup
-- hs.console.show()

-- Get or set the color that commands displayed in the Hammerspoon console are displayed with
hs.console.consoleCommandColor { hex = '#f3b175' }

-- Get or set the font used in the Hammerspoon console
hs.console.consoleFont {
  name = 'JetBrainsMono Nerd Font',
  size = 15,
}

-- Get or set the color that regular output displayed in the Hammerspoon console is displayed with
hs.console.consolePrintColor { hex = '#c9ccfb' }

-- Get or set the color that function results displayed in the Hammerspoon console are displayed with
hs.console.consoleResultColor { hex = '#ffc7c7' }

-- Enable dark mode for the console
hs.console.darkMode(true)

-- Get or set the color for the background of the Hammerspoon Console's input field
hs.console.inputBackgroundColor { hex = '#1c1b29' }

-- Set the console background color with transparency
hs.console.outputBackgroundColor { hex = '#1c1b29' }

-- Get or set whether or not the "Hammerspoon Console" text appears in the Hammerspoon console titlebar
hs.console.titleVisibility 'hidden'

-- Get or set the color for the background of the Hammerspoon Console's window
hs.console.windowBackgroundColor { hex = '#1c1b29' }
