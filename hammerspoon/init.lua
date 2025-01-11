-- https://www.hammerspoon.org/docs/
package.path = table.concat { hs.configdir, '/lua/?.lua;', package.path }

-- Set console theme
require 'ui'

-- Set hotkeys
for _, spec in ipairs(require 'mappings') do
  hs.hotkey.bind(spec.mods, spec.key, spec.desc, spec.command)
end
