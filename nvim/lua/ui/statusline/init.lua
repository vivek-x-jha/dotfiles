--- @type StatusLine
return {
  setup = function()
    local modules = require 'ui.statusline.modules'

    --- @type string[] Aggregated statusline modules
    local statusline = {}

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

    for _, mod in ipairs(orders) do
      -- Directly handle '%=' as a string, otherwise call the module function
      table.insert(statusline, mod == 'sep' and modules[mod] or modules[mod]())
    end

    return table.concat(statusline)
  end,

  autocmds = function()
    local aucmd = require('configs.utils').create_auto_command
    local augroup = require('configs.utils').create_auto_group
    local state = require('ui.statusline.utils').state

    aucmd {
      desc = 'Show LSP Progress bar',
      group = augroup 'LspProgressAU',
      event = 'LspProgress',
      pattern = { 'begin', 'end' },
      callback = function(args)
        local data = args.data.params.value
        local progress = ''

        if data.percentage then
          local spinners = { '', '', '', '󰪞', '󰪟', '󰪠', '󰪢', '󰪣', '󰪤', '󰪥' }
          local idx = math.max(1, math.floor(data.percentage / 10))
          local icon = spinners[idx]
          progress = icon .. ' ' .. data.percentage .. '%% '
        end

        local str = progress .. (data.message or '') .. ' ' .. (data.title or '')
        state.lsp_msg = data.kind == 'end' and '' or str
        vim.cmd.redrawstatus()
      end,
    }
  end,
}
