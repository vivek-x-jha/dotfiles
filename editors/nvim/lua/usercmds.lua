-- [1/2] List all vim.pack plugins
vim.api.nvim_create_user_command('PackList', function()
  for _, plugin in ipairs(vim.pack.get()) do
    print(plugin.spec.name)
  end
end, { desc = 'List vim.pack plugins' })

-- [2/2] List inactive vim.pack plugins
vim.api.nvim_create_user_command('PackListInactive', function()
  for _, plugin in ipairs(vim.pack.get()) do
    if not plugin.active then print(plugin.spec.name) end
  end
end, { desc = 'List inactive vim.pack plugins' })
