return {
  set_console = function(opts_path)
    local options = require(opts_path)

    for setting, opts in pairs(options) do
      if setting == 'toolbar' and not opts then
        hs.console.toolbar(nil)
      else
        hs.console[setting](opts)
      end
    end
  end,

  bind_hotkeys = function(hotkey_path)
    -- Translate the dot-based hotkey_path into a file path
    local path = hs.configdir .. '/' .. hotkey_path:gsub('%.', '/')

    if not hs.fs.attributes(path) then
      print('Error: hotkey_path does not exist: ', path)
      return
    end

    -- Iterate over files in the hotkey_path
    for file in hs.fs.dir(path) do
      if file:sub(-4) == '.lua' then
        local module_name = hotkey_path .. '.' .. file:sub(1, -5)
        local success, mappings = pcall(require, module_name)

        if success and type(mappings) == 'table' then
          for _, spec in ipairs(mappings) do
            if spec.mods and spec.key and spec.desc and spec.command then
              hs.hotkey.bind(spec.mods, spec.key, spec.desc, spec.command)
            else
              print('Invalid spec in ' .. file .. ': ', hs.inspect(spec))
            end
          end
        else
          print('Failed to load ' .. module_name .. ': ' .. tostring(mappings))
        end
      end
    end
  end,
}
