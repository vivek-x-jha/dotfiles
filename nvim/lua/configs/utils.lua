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

  filenames = function(folder)
    local uv = vim.loop
    local files = {}
    local fd = uv.fs_opendir(folder, nil, 50)
    if fd then
      while true do
        local dir_entries = uv.fs_readdir(fd)
        if not dir_entries then break end
        for _, entry in ipairs(dir_entries) do
          if entry.type == 'file' and entry.name:match '%.lua$' then
            -- Use vim.fn to strip extension
            local basename = vim.fn.fnamemodify(entry.name, ':r')
            table.insert(files, basename)
          end
        end
      end
      uv.fs_closedir(fd)
    end
    return files
  end,

  load = function(self, type)
    local commands = {
      usercmds = self.create_user_command,
      autocmds = self.create_auto_command,
      mappings = self.set_keymap,
    }

    --- @type AutoCmd[]|UserCmd[]|KeyMap[] Auto/User commands or keymappings
    local cmds = require('configs.' .. type)

    --- @type AutoCmd[]|UserCmd[]|KeyMap[] Auto/User commands or keymappings to be scheduled
    local deferred_cmds = {}

    for _, cmd in ipairs(cmds) do
      if cmd.enabled == false then
        goto continue
      elseif cmd.after or type == 'mappings' then
        table.insert(deferred_cmds, cmd)
      else
        commands[type](cmd)
      end

      ::continue::
    end

    vim.schedule(function()
      for _, cmd in ipairs(deferred_cmds) do
        commands[type](cmd)
      end
    end)
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
