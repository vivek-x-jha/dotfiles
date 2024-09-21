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

rmds() {
  local directory="${1:-$HOME}"
  find "$directory" -name '.DS_Store' -type f -delete &>/dev/null
  return 0
}

update_icons() {
  command -v fileicon &>/dev/null || brew install fileicon

  declare -A dir_icons=(

    # Apps                                 Icons
    /Applications/1Password.app            ~/Pictures/icons/1password.png
    /Applications/ChatGPT.app              ~/Pictures/icons/chatgpt.png
    /Applications/Figma.app                ~/Pictures/icons/figma.png
    /Applications/Firefox.app              ~/Pictures/icons/firefox-macos.png
    /Applications/Google\ Chrome.app       ~/Pictures/icons/chrome.png
    /Applications/iTerm.app                ~/Pictures/icons/iterm2.png
    /Applications/iTermAI.app              ~/Pictures/icons/ai-brain.png
    /Applications/Mimestream.app           ~/Pictures/icons/gmail.png
    /Applications/Neovim.app               ~/Pictures/icons/neovim.png
    /Applications/Slack.app                ~/Pictures/icons/slack.png
    /Applications/Spotify.app              ~/Pictures/icons/spotify.png
    /Applications/Tex                      ~/Pictures/icons/tex.png
    /Applications/Visual\ Studio\ Code.app ~/Pictures/icons/vscode.png

    # Folders                              Icons
    ~/Developer                            ~/Pictures/icons/developer.png
    ~/Downloads                            ~/Pictures/icons/download.png
    ~/Dropbox/content                      ~/Pictures/icons/content.png
    ~/Pictures/icons                       ~/Pictures/icons/png.png
    ~/Pictures/screenshots                 ~/Pictures/icons/screenshot.png
    ~/Pictures/wallpaper                  ~/Pictures/icons/wallpaper.png
    ~/.dotfiles                            ~/Pictures/icons/gear.png

  )

  # Header
  local black='\e[0;30m'
  local red='\e[0;31m'
  local green='\e[0;32m'
  local blue='\e[0;34m'
  local magenta='\e[0;35m'
  local brightblack='\e[0;90m'
  local brightblue='\e[0;94m'
  local brightmagenta='\e[0;95m'
  local reset='\e[0m'

  local table_width=57

  print_separator() { printf "${brightblack}%-${table_width}s${reset}\n" | tr ' ' '-'; }

  printf "%-1s ${brightblue}%-37s ${magenta}%-5s${reset}\n" '' 'Folder' '~/Pictures/icons/'
  print_separator

  # Sort keys while preserving spaces in the directories
  IFS=$'\n' sorted_dirs=($(for dir in "${!dir_icons[@]}"; do echo "$dir"; done | sort))

  local dir_count="${#sorted_dirs[@]}"
  local success_count=$dir_count

  for dir in "${sorted_dirs[@]}"; do
    local icon=${dir_icons["$dir"]}
    local expanded_dir=$(echo "$dir" | sed "s|^$HOME|~|")  # Replace $HOME with ~ for output
    local basename_dir=$(basename "$expanded_dir")
    local basename_icon=$(basename "$icon")

    if sudo fileicon set "$dir" "$icon" &> /dev/null; then
      printf "${green}%-1s ${blue}%-37s ${brightmagenta}%-5s${reset}\n" "" "$expanded_dir" "$basename_icon"
    elif [[ $basename_dir == 'Mimestream.app' ]]; then
      printf "${green}%-1s ${blue}%-37s ${brightmagenta}%-5s${reset}\n" "" "$expanded_dir" "$basename_icon"
    else
      printf "${red}%-1s ${blue}%-37s ${brightmagenta}%-5s${reset}\n"   "" "$expanded_dir" "$basename_icon"
      ((success_count--))
    fi

  done

  local fail_count=$(($dir_count-$success_count))

  # Footer
  print_separator
  printf "${green}%-2s ${brightblack}%-37s ${reset}\n" "$success_count" 'Folder icon(s) updated successfully'
  [ $fail_count -eq 0 ] || printf "${red}%-2s ${brightblack}%-37s ${reset}\n" "$fail_count" 'Folder icon(s) failed to update'
  echo
}
