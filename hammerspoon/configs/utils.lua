return {
  bind_hotkeys = function(directory)
    for file in hs.fs.dir(hs.configdir .. directory) do
      if file:sub(-4) == '.lua' then
        -- Build the module name relative to the base directory
        local module_name = 'hotkeys.' .. file:sub(1, -5)
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
          print('Failed to load ' .. file .. ': ' .. tostring(mappings))
        end
      end
    end
  end,
}
