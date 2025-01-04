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
      if cmd.after or type == 'mappings' then
        table.insert(deferred_cmds, cmd)
      else
        commands[type](cmd)
      end
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

  set_rtp = function(lazypath)
    -- Bootstrap lazy if not installed
    if not vim.uv.fs_stat(lazypath) then
      local out = vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        '--branch=stable',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
      }

      if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
          { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
          { out, 'WarningMsg' },
          { '\nPress any key to exit...' },
        }, true, {})

        vim.fn.getchar()
        os.exit(1)
      end
    end

    -- Prepend lazy to rtp
    vim.opt.rtp:prepend(lazypath)
  end,

  set_hlgroups = function(hlgroups)
    for hlgroup, hlopts in pairs(hlgroups) do
      vim.api.nvim_set_hl(0, hlgroup, hlopts)
    end
  end,

  set_terminal_colors = function(theme)
    for i, color in ipairs {
      'black',
      'red',
      'green',
      'yellow',
      'blue',
      'magenta',
      'cyan',
      'white',
      'brightblack',
      'brightred',
      'brightgreen',
      'brightyellow',
      'brightblue',
      'brightmagenta',
      'brightcyan',
      'brightwhite',
    } do
      vim.g['terminal_color_' .. (i - 1)] = theme[color]
    end
  end,
}
