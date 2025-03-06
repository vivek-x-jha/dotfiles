---@type Colorscheme
return {
  -- Primary Colors
  black = os.getenv 'BLACK_HEX',
  red = os.getenv 'RED_HEX',
  green = os.getenv 'GREEN_HEX',
  yellow = os.getenv 'YELLOW_HEX',
  blue = os.getenv 'BLUE_HEX',
  magenta = os.getenv 'MAGENTA_HEX',
  cyan = os.getenv 'CYAN_HEX',
  white = os.getenv 'WHITE_HEX',

  brightblack = os.getenv 'BRIGHTBLACK_HEX',
  brightred = os.getenv 'BRIGHTRED_HEX',
  brightgreen = os.getenv 'BRIGHTGREEN_HEX',
  brightyellow = os.getenv 'BRIGHTYELLOW_HEX',
  brightblue = os.getenv 'BRIGHTBLUE_HEX',
  brightmagenta = os.getenv 'BRIGHTMAGENTA_HEX',
  brightcyan = os.getenv 'BRIGHTCYAN_HEX',
  brightwhite = os.getenv 'BRIGHTWHITE_HEX',

  -- Extras
  background = os.getenv 'BACKGROUND_HEX',
  grey = os.getenv 'GREY_HEX',
  dark = os.getenv 'DARK_HEX',
}
