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

gsw() {
  # Function overload for git switch fuzzy finding
  if (( $# == 0 )) && command -v fzf; then
    git switch $(git branch | fzf --header 'Switch Local  ')
  else
    git switch "$@"
  fi
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
    0   black         '#cccccc'  '\e[0;30m' 
    1   red           '#ffc7c7'  '\e[0;31m' 
    2   green         '#ceffc9'  '\e[0;32m' 
    3   yellow        '#fdf7cd'  '\e[0;33m' 
    4   blue          '#c4effa'  '\e[0;34m' 
    5   magenta       '#eccef0'  '\e[0;35m' 
    6   cyan          '#8ae7c5'  '\e[0;36m' 
    7   white         '#f4f3f2'  '\e[0;37m'
        
    8   brightblack   '#5c617d'  '\e[0;90m'
    9   brightred     '#f096b7'  '\e[0;91m'
    10  brightgreen   '#d2fd9d'  '\e[0;92m'
    11  brightyellow  '#f3b175'  '\e[0;93m'
    12  brightblue    '#80d7fe'  '\e[0;94m'
    13  brightmagenta '#c9ccfb'  '\e[0;95m'
    14  brightcyan    '#47e7b1'  '\e[0;96m'
    15  brightwhite   '#ffffff'  '\e[0;97m'
        
    248 grey          '#313244'  '\e[38;5;248m'
  )

  # Create Color Table Header
  print_separator() { printf "${brightblack}%-${table_width}s${reset}\n" | tr ' ' '-'; }

  print_separator
  printf "${white}%-4s %-14s %-8s %-8s${reset}\n" 'VGA' 'COLOR' 'HEX' 'ANSI'
  print_separator

  # Create Color Table Rows
  for ((i=0; i<${#colorscheme[@]}; i+=4)); do
    local vga="${colorscheme[i]}"
    local name="${colorscheme[i+1]}"
    local hex="${colorscheme[i+2]}"
    local ansi="${colorscheme[i+3]}"

    # Indirect Substitution of name as color variable
    printf "${!name}%-4s %-14s %-8s %-8s${reset}\n" "$vga" "$name" "$hex" "$ansi"
  done
  echo
}

update_icons() {
  command -v fileicon &>/dev/null || brew install fileicon

  local table_width=57
  declare -A dir_icons=(

    # Apps                                 Icons
    /Applications/1Password.app            ~/Pictures/icons/1password-macos.png
    /Applications/ChatGPT.app              ~/Pictures/icons/chatgpt.png
    /Applications/Discord.app              ~/Pictures/icons/discord-macos.png
    /Applications/Figma.app                ~/Pictures/icons/figma.png
    /Applications/Firefox.app              ~/Pictures/icons/firefox-macos.png
    /Applications/Google\ Chrome.app       ~/Pictures/icons/chrome.png
    /Applications/iTerm.app                ~/Pictures/icons/iterm2.png
    /Applications/iTermAI.app              ~/Pictures/icons/ai-brain.png
    /Applications/KeyCastr.app             ~/Pictures/icons/keycastr.png
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
