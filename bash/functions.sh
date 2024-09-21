#!/usr/bin/env bash

take() {
  local dir="$1"

  [ -d "$dir" ] || mkdir -p "$dir"
  cd "$dir"
}

combinepdf() {
  gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$1" "${@:2}"
}

tmux_list_sessions() {
  # TODO standardize with header
  tmux list-sessions | awk -F '[ :()]+' 'BEGIN { \
  printf "%-13s %-5s %-25s\n", "Session", "Win", "Date Created"; \
  print "·······································"} \
  { printf "%-13s %-5s %s %s %s (%s:%s)\n", $1, $2, $6, $7, $11, $8, $9 }'
}

condainit() {
  # export JUPYTER_CONFIG_DIR="$DOT/jupyter/.jupyter"

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

list_colors() {

  local table_width=36
  local colorscheme=(
    black         '#cccccc'  '\e[0;30m' 
    red           '#ffc7c7'  '\e[0;31m' 
    green         '#ceffc9'  '\e[0;32m' 
    yellow        '#fdf7cd'  '\e[0;33m' 
    blue          '#c4effa'  '\e[0;34m' 
    magenta       '#eccef0'  '\e[0;35m' 
    cyan          '#8ae7c5'  '\e[0;36m' 
    white         '#f4f3f2'  '\e[0;37m'
    brightblack   '#5c617d'  '\e[0;90m'
    brightred     '#f096b7'  '\e[0;91m'
    brightgreen   '#d2fd9d'  '\e[0;92m'
    brightyellow  '#f3b175'  '\e[0;93m'
    brightblue    '#80d7fe'  '\e[0;94m'
    brightmagenta '#c9ccfb'  '\e[0;95m'
    brightcyan    '#47e7b1'  '\e[0;96m'
    brightwhite   '#ffffff'  '\e[0;97m'
    grey          '#313244'  '\e[38;5;248m'
  )

  # Create Color Table Header
  print_separator() { printf "${brightblack}%-${table_width}s${reset}\n" | tr ' ' '-'; }

  print_separator
  printf "${white}%-14s %-8s %-8s${reset}\n" 'Color' 'Hex' 'Ansi'
  print_separator

  # Create Color Table Rows
  for ((i=0; i<${#colorscheme[@]}; i+=3)); do
    local name="${colorscheme[i]}"
    local hex="${colorscheme[i+1]}"
    local ansi="${colorscheme[i+2]}"

    # Indirect Substitution of name as color variable
    printf "${!name}%-14s %-8s %-8s${reset}\n" "$name" "$hex" "$ansi"
  done
  echo
}

update_icons() {
  command -v fileicon &>/dev/null || brew install fileicon

  local table_width=57
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
    ~/Pictures/wallpapers                  ~/Pictures/icons/wallpaper.png
    ~/.dotfiles                            ~/Pictures/icons/gear.png

  )

  # Create Directory-Icons Table Header
  print_separator() { printf "${brightblack}%-${table_width}s${reset}\n" | tr ' ' '-'; }

  print_separator
  printf "%-1s ${blue}%-37s ${magenta}%-5s${reset}\n" '' 'App / Directory' '~/Pictures/icons/'
  print_separator

  # Sort keys while preserving spaces in the directories
  IFS=$'\n' sorted_dirs=($(for dir in "${!dir_icons[@]}"; do echo "$dir"; done | sort))

  local dir_count="${#sorted_dirs[@]}"
  local success_count=$dir_count

  # Create Directory-Icons Table Rows
  for dir in "${sorted_dirs[@]}"; do

    local icon=${dir_icons["$dir"]}
    local expanded_dir=$(echo "$dir" | sed "s|^$HOME|~|")  # Replace $HOME with ~ for output
    local basename_dir=$(basename "$expanded_dir")
    local basename_icon=$(basename "$icon")

    if sudo fileicon set "$dir" "$icon" &> /dev/null; then
      printf "${green}%-1s ${white}%-37s ${brightmagenta}%-5s${reset}\n" "" "$expanded_dir" "$basename_icon"
    elif [[ $basename_dir == 'Mimestream.app' ]]; then
      printf "${green}%-1s ${white}%-37s ${brightmagenta}%-5s${reset}\n" "" "$expanded_dir" "$basename_icon"
    else
      printf "${red}%-1s ${white}%-37s ${brightmagenta}%-5s${reset}\n"   "" "$expanded_dir" "$basename_icon"
      ((success_count--))
    fi

  done

  # Footer
  local fail_count=$(($dir_count-$success_count))

  print_separator
  printf "${green}%-2s ${brightblack}%-37s ${reset}\n" "$success_count" 'Folder icon(s) updated successfully'
  [ $fail_count -eq 0 ] || printf "${red}%-2s ${brightblack}%-37s ${reset}\n" "$fail_count" 'Folder icon(s) failed to update'
  echo
}
