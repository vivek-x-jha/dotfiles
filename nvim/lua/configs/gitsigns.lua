require('utils.ui').set_base46 'git'

return {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '-' },
    topdelete = { text = '‾' },
    changedelete = { text = '/' },
    untracked = { text = '?' },
  },
  signs_staged = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '-' },
    topdelete = { text = '‾' },
    changedelete = { text = '/' },
    untracked = { text = '?' },
  },
}
