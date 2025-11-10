require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = 'x' },
    topdelete = { text = 'x' },
    changedelete = { text = 'x' },
    untracked = { text = '?' },
  },

  signs_staged = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = 'x' },
    topdelete = { text = 'x' },
    changedelete = { text = 'x' },
    untracked = { text = '?' },
  },

  on_attach = function(bufnr)
    local map = function(key, fn)
      vim.keymap.set('n', key, function()
        if vim.wo.diff then return key end
        vim.schedule(package.loaded.gitsigns[fn])
        return '<Ignore>'
      end, { buffer = bufnr, expr = true, desc = 'Git: ' .. fn })
    end

    map(']c', 'next_hunk')
    map('[c', 'prev_hunk')
  end,
}
