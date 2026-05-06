-- Register the active colorscheme name
vim.g.colors_name = 'sourdiesel'

-- Apply the SourDiesel highlights
for group, opts in pairs(require 'ui.highlights') do
  vim.api.nvim_set_hl(0, group, opts)
end
