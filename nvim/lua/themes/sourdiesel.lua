-- this line for types, by hovering and autocompletion (lsp required)
-- will help you understanding properties, fields, and what highlightings the color used for
---@type Base46Table
local M = {}
-- UI
M.base_30 = {
  white = '#f4f3f2',
  darker_black = '#cccccc', -- nvtree background
  black = '#212030', --  statusline icon background and editor active tab background and telescope background
  black2 = '#252435', -- highlights nvtree current line and inactive tabs bg, and cheat sheet sections
  one_bg = '#313244', -- status line background
  one_bg2 = '#5c617d', -- highlights current scope and nvtree divider
  one_bg3 = '#212030', -- highlights toggle button and telescope borders
  grey = '#5c617d', -- line number fg
  grey_fg = '#5c617d', -- comments
  grey_fg2 = '#555464',
  light_grey = '#605f6f', -- inactive tabs fg
  red = '#FFC7C7',
  baby_pink = '#f096b7',
  pink = '#ECCEF0',
  line = '#5c617d', -- for lines like vertsplit
  green = '#CEFFC9',
  vibrant_green = '#d2fd9d',
  nord_blue = '#80d7fe',
  blue = '#C4EFFA',
  yellow = '#FDF7CD',
  sun = '#ffe9b6',
  purple = '#ECCEF0',
  dark_purple = '#ECCEF0',
  teal = '#47e7b1',
  orange = '#F3B175',
  cyan = '#8AE7C5',
  statusline_bg = '#F4F3F2',
  lightbg = '#2f2e3e',
  pmenu_bg = '#F4F3F2',
  folder_bg = '#C4EFFA',
  lavender = '#C9CCFB',
}

-- check https://github.com/chriskempson/base16/blob/master/styling.md for more info
M.base_16 = {
  base00 = '#212030',
  base01 = '#CCCCCC',
  base02 = '#5c617d',
  base03 = '#5c617d',
  base04 = '#5c617d',
  base05 = '#f4f3f2',
  base06 = '#cccccc',
  base07 = '#F4F3F2',
  base08 = '#FFC7C7',
  base09 = '#F3B175',
  base0A = '#FDF7CD',
  base0B = '#CEFFC9',
  base0C = '#8AE7C5',
  base0D = '#C4EFFA',
  base0E = '#ECCEF0',
  base0F = '#cccccc',
}

-- OPTIONAL
-- overriding or adding highlights for this specific theme only
-- defaults/treesitter is the filename i.e integration there,

M.polish_hl = {
  defaults = {
    Comment = {
      bg = '#ffffff', -- or M.base_30.cyan
      italic = true,
    },
  },

  treesitter = {
    ['@variable'] = { fg = '#000000' },
  },
}

-- set the theme type whether is dark or light
M.type = 'dark' -- "or light"

-- this will be later used for users to override your theme table from chadrc
M = require('base46').override_theme(M, 'sourdiesel')

return M
