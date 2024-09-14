-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",
  transparency = true,
  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
  changed_themes = {
    catppuccin = {
      base_16 = {
        base00 = "#212030", -- editor background
        base01 = "#CCCCCC", -- BLACK
        base02 = "#5c617d", -- select background
        base03 = "#5c617d", -- Bright BLACK
        base04 = "#5c617d",
        base05 = "#f4f3f2", -- default fg, `=` syntax, nvtree default fg
        base06 = "#cccccc",
        base07 = "#F4F3F2",
        base08 = "#FFC7C7",
        base09 = "#F3B175",
        base0A = "#FDF7CD",
        base0B = "#CEFFC9",
        base0C = "#8AE7C5",
        base0D = "#C4EFFA",
        base0E = "#ECCEF0",
        base0F = "#cccccc", -- punctuation, parantheses, brackets
      },
      base_30 = {
        white = "#f4f3f2",
        darker_black = "#212030", -- nvtree background
        black = "#212030",        --  statusline icon background and editor active tab background and telescope background
        black2 = "#252435",       -- highlights nvtree current line and inactive tabs bg, and cheat sheet sections
        one_bg = "#313244",       -- status line background
        one_bg2 = "#5c617d",      -- highlights current scope and nvtree divider
        one_bg3 = "#212030",      -- highlights toggle button and telescope borders
        grey = "#5c617d",         -- line number fg
        grey_fg = "#5c617d",      -- comments
        grey_fg2 = "#555464",
        light_grey = "#605f6f",   -- inactive tabs fg
        red = "#FFC7C7",
        baby_pink = "#f096b7",
        pink = "#ECCEF0",
        line = "#5c617d", -- for lines like vertsplit
        green = "#CEFFC9",
        vibrant_green = "#d2fd9d",
        nord_blue = "#80d7fe",
        blue = "#C4EFFA",
        yellow = "#FDF7CD",
        sun = "#ffe9b6",
        purple = "#ECCEF0",
        dark_purple = "#ECCEF0",
        teal = "#47e7b1",
        orange = "#F3B175",
        cyan = "#8AE7C5",
        statusline_bg = "#F4F3F2",
        lightbg = "#2f2e3e",
        pmenu_bg = "#F4F3F2",
        folder_bg = "#C4EFFA",
        lavender = "#C9CCFB",
      },
    },
  },
  telescope = { style = "bordered" },
  statusline = {
    theme = "minimal",
    separator_style = "round"
  },
  nvdash = {
    load_on_startup = true,
    buttons = {
      { "  Find File", "<Space> + f f", "Telescope find_files" },
      { "󰈚  Recent Files", "<Space> + f o", "Telescope oldfiles" },
      { "󰈭  Find Word", "<Space> + f w", "Telescope live_grep" },
      { "  Bookmarks", "<Space> + m a", "Telescope marks" },
      { "  Themes", "<Space> + t h", "Telescope themes" },
      { "  Mappings", "<Space> + c h", "NvCheatsheet" },
    },
  },
}

return M
