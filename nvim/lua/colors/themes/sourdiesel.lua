local primary = {
  black = '#cccccc',
  red = '#ffc7c7',
  green = '#ceffc9',
  yellow = '#fdf7cd',
  blue = '#c4effa',
  magenta = '#eccef0',
  cyan = '#8ae7c5',
  white = '#f4f3f2',

  brightblack = '#5c617d',
  brightred = '#f096b7',
  brightgreen = '#d2fd9d',
  brightyellow = '#f3b175',
  brightblue = '#80d7fe',
  brightmagenta = '#c9ccfb',
  brightcyan = '#47e7b1',
  brightwhite = '#ffffff',
}

local extras = {
  background = 'NONE',
  grey = '#313244',
  dark = '#1b1c28',
}

return vim.tbl_deep_extend('force', primary, extras)
