local api = vim.api
local fn = vim.fn

--- @type Utils
return {
  create_auto_group = function(opts)
    local name
    local options = {}

    if type(opts) == 'string' then
      name = opts
    elseif type(opts) == 'table' then
      name, options = opts[1], { clear = opts[2] }
    end

    return api.nvim_create_augroup(name, options)
  end,

  create_auto_command = function(opts)
    local event = opts.event

    opts.event = nil
    opts.after = nil

    api.nvim_create_autocmd(event, opts)
  end,

  create_user_command = function(opts)
    local name = opts.name
    local cmd = opts.command

    opts.name = nil
    opts.command = nil
    opts.after = nil

    api.nvim_create_user_command(name, cmd, opts)
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
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
      local lazyrepo = 'https://github.com/folke/lazy.nvim.git'

      local out = fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        '--branch=stable',
        lazyrepo,
        lazypath,
      }

      if vim.v.shell_error ~= 0 then
        api.nvim_echo({
          { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
          { out, 'WarningMsg' },
          { '\nPress any key to exit...' },
        }, true, {})

        fn.getchar()
        os.exit(1)
      end
    end

    -- Prepend lazy to rtp
    vim.opt.rtp:prepend(lazypath)
  end,
}
