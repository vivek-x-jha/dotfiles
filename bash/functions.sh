#!/usr/bin/env bash

take() {
  [ -d "$1" ] || mkdir -p "$1"
  cd "$1"
}

condainit() {
   # Jupyter settings
  export JUPYTER_CONFIG_DIR="$DOT/jupyter/.jupyter"

  # Initialize conda environment
  __conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
          source "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
      else
          export PATH="/opt/homebrew/anaconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
}

tmux_list_sessions() {
  tmux list-sessions | awk -F '[ :()]+' 'BEGIN { \
  printf "%-13s %-5s %-25s\n", "Session", "Win", "Date Created"; \
  print "·······································"} \
  { printf "%-13s %-5s %s %s %s (%s:%s)\n", $1, $2, $6, $7, $11, $8, $9 }'
}

combinepdf() {
  gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$1" "${@:2}"
}

list_colors() {
  local colorscheme=(
    'grey          #313244'
    'black         #cccccc'
    'red           #ffc7c7'
    'green         #ceffc9'
    'yellow        #fdf7cd'
    'blue          #c4effa'
    'magenta       #eccef0'
    'cyan          #8ae7c5'
    'white         #f4f3f2'
    'brightblack   #5c617d'
    'brightred     #f096b7'
    'brightgreen   #d2fd9d'
    'brightyellow  #f3b175'
    'brightblue    #80d7fe'
    'brightmagenta #c9ccfb'
    'brightcyan    #47e7b1'
    'brightwhite   #ffffff'
  )
  for color in "${colorscheme[@]}"; do echo "$color"; done
}

update_icons() {
  command -v fileicon &> /dev/null || return

  sudo fileicon set /Applications/Tex                 ~/Pictures/icons/tex.png

  fileicon set /Applications/1Password.app            ~/Pictures/icons/1password.png
  fileicon set /Applications/ChatGPT.app              ~/Pictures/icons/chatgpt.png
  fileicon set /Applications/iTerm.app                ~/Pictures/icons/very-colorful-terminal-icons/indigo-to-light.icns
  fileicon set /Applications/iTermAI.app              ~/Pictures/icons/ai-brain.png
  fileicon set /Applications/Mimestream.app           ~/Pictures/icons/gmail.png
  fileicon set /Applications/Neovim.app               ~/Pictures/icons/neovim.png
  fileicon set /Applications/Slack.app                ~/Pictures/icons/slack.png
  fileicon set /Applications/Spotify.app              ~/Pictures/icons/spotify.png
  fileicon set /Applications/Visual\ Studio\ Code.app ~/Pictures/icons/vscode.png

  fileicon set ~/Developer                            ~/Pictures/icons/developer.png
  fileicon set ~/Downloads                            ~/Pictures/icons/download.png
  fileicon set ~/Dropbox/content                      ~/Pictures/icons/content.png
  fileicon set ~/Pictures/icons                       ~/Pictures/icons/png.png
  fileicon set ~/Pictures/screenshots                 ~/Pictures/icons/screenshot.png
  fileicon set ~/Pictures/wallpapers                  ~/Pictures/icons/wallpaper.png
  fileicon set ~/.dotfiles                            ~/Pictures/icons/gear.png
}
