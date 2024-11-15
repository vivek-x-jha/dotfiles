-- Helper functions that affect overall UI and coloring

return {
  set_base46 = function(file)
    local success, err = pcall(function()
      dofile(vim.g.base46_cache .. file)
    end)

    if not success then
      local err_msg = 'Error loading base46 cache file: ' .. file .. '\n' .. err
      vim.notify(err_msg, vim.log.levels.ERROR)
    end
  end,
}
