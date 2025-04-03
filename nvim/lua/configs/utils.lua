--- @type Utils Support functions used for initialization and configuration
return {
  create_auto_group = function(opts)
    local name
    local options = {}

    if type(opts) == 'string' then
      name = opts
    elseif type(opts) == 'table' then
      name, options = opts[1], { clear = opts[2] }
    end

    return vim.api.nvim_create_augroup(name, options)
  end,

  create_auto_command = function(opts)
    local event = opts.event

    opts.event = nil
    opts.after = nil

    vim.api.nvim_create_autocmd(event, opts)
  end,

  create_user_command = function(opts)
    local name = opts.name
    local cmd = opts.command

    opts.name = nil
    opts.command = nil
    opts.after = nil

    vim.api.nvim_create_user_command(name, cmd, opts)
  end,

  set_keymap = function(opts)
    local mode = opts.mode
    local keys = opts.keys
    local command = opts.command

    opts.mode = nil
    opts.keys = nil
    opts.command = nil

    vim.keymap.set(mode, keys, command, opts)
  end,

  set_hlgroups = function(hlgroups)
    for hlgroup, hlopts in pairs(hlgroups) do
      vim.api.nvim_set_hl(0, hlgroup, hlopts)
    end
  end,
}
