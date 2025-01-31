local modules = require 'ui.statusline.modules'

--- @type StatusLine Generates all statusline modules and auto commands
return {
  setup = function()
    --- @type string[] Order of statusline modules
    local orders = {
      'mode',
      'git_branch',
      'lsp',
      'diagnostics',
      'file',
      'git_mod',
      'sep',
      'lsp_msg',
      'sep',
      'cwd',
      'cursor',
    }

    --- @type string[] Aggregated statusline modules
    local statusline = {}

    for _, mod in ipairs(orders) do
      table.insert(statusline, mod == 'sep' and '%=' or modules[mod]())
    end

    return table.concat(statusline)
  end,
}
