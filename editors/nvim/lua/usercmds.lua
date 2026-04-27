local usercmd = vim.api.nvim_create_user_command

---@param predicate? fun(plugin: { spec: { name: string }, active: boolean }): boolean
local list_plugins = function(predicate)
  for _, plugin in ipairs(vim.pack.get()) do
    if not predicate or predicate(plugin) then print(plugin.spec.name) end
  end
end

-- [1/2] List all vim.pack plugins
usercmd('PackList', function() list_plugins() end, { desc = 'List vim.pack plugins' })

-- [2/2] List inactive vim.pack plugins
usercmd('PackListInactive', function()
  list_plugins(function(plugin) return not plugin.active end)
end, { desc = 'List inactive vim.pack plugins' })
