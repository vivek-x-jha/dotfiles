#!/usr/bin/env bash

take() {
  local dir="$1"

  [ -d "$dir" ] || mkdir -p "$dir"
  cd "$dir"
}

count-files() (
  shopt -s nullglob
  local dir=$1
  local files=("$dir"/* "$dir"/.*)
  echo "${#files[@]}"
)

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

list_colors() {

  local colors=(
    "#cccccc"
    "#ffc7c7"
    "#ceffc9"
    "#fdf7cd"
    "#c4effa"
    "#eccef0"
    "#8ae7c5"
    "#f4f3f2"

    "#5c617d"
    "#f096b7"
    "#d2fd9d"
    "#f3b175"
    "#80d7fe"
    "#c9ccfb"
    "#47e7b1"
    "#ffffff"
  )

  for hex in "${colors[@]}"; do
    # Convert hex to RGB
    local r=$((16#${hex:1:2}))
    local g=$((16#${hex:3:2}))
    local b=$((16#${hex:5:2}))
    
    # Create the ANSI escape sequence for the color
    local ansi="\e[38;2;${r};${g};${b}m"

    printf "${ansi}(%s) The quick brown fox jumps over the lazy dog${RESET}\n" "$hex"
  done
}

update_feature_branches() {
  local branches=("$@")

  # Default branches
  [[ $# -eq 0 ]] && branches=(
    bootstrap
    fzf
    hammerspoon
    nvim
    tmux
    wezterm
  )

  for branch in "${branches[@]}"; do git switch "feature/$branch" && git merge main; done

  git switch main

  git log -5 --graph --date=format:"%b-%d-%Y" --pretty="%C(yellow)%h %C(blue)%an %C(brightmagenta)%ad%C(auto)%d %C(white)%s %Creset"
}

update_texlive() {
  sudo tlmgr update --self --all
}

update_brew() {
  brew upgrade
  brew cu -af
  brew cleanup
  brew doctor
  brew bundle dump --force --file="$XDG_CONFIG_HOME/brew/.Brewfile"
}
update_icons() {
  command -v fileicon &>/dev/null || brew install fileicon

  local table_width=60
  declare -A dir_icons=(

    # Apps                                 Icons
    /Applications/1Password.app            ~/Pictures/icons/1password-macos.png
    /Applications/ChatGPT.app              ~/Pictures/icons/chatgpt.png
    /Applications/Discord.app              ~/Pictures/icons/discord-macos.png
    /Applications/Docker.app               ~/Pictures/icons/docker.png
    /Applications/Figma.app                ~/Pictures/icons/figma.png
    /Applications/Firefox.app              ~/Pictures/icons/firefox-macos.png
    /Applications/Google\ Chrome.app       ~/Pictures/icons/chrome.png
    /Applications/iTerm.app                ~/Pictures/icons/iterm2.png
    /Applications/iTermAI.app              ~/Pictures/icons/ai-brain.png
    /Applications/KeyCastr.app             ~/Pictures/icons/keycastr.png
    /Applications/Mimestream.app           ~/Pictures/icons/gmail.png
    /Applications/Neovim.app               ~/Pictures/icons/neovim.png
    /Applications/Postman.app              ~/Pictures/icons/postman.png
    /Applications/Python\ 3.13             ~/Pictures/icons/python.png
    /Applications/Slack.app                ~/Pictures/icons/slack.png
    /Applications/Spotify.app              ~/Pictures/icons/spotify.png
    /Applications/Tex                      ~/Pictures/icons/tex.png
    /Applications/Visual\ Studio\ Code.app ~/Pictures/icons/vscode.png
    /Applications/WezTerm.app              ~/Pictures/icons/wezterm.png
    /Applications/WhatsApp.app             ~/Pictures/icons/whatsapp.png

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
  print_separator() { printf "${BRIGHTBLACK}%-${table_width}s${RESET}\n" | tr ' ' '-'; }

  print_separator
  printf "%-2s ${BLUE}%-37s ${MAGENTA}%-5s${RESET}\n" '' 'App / Directory' '~/Pictures/icons/'
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
      printf "${GREEN}%-1s ${WHITE}%-37s ${BRIGHTMAGENTA}%-5s${RESET}\n" " " "$expanded_dir" "$basename_icon"
    elif [[ $basename_dir == 'Mimestream.app' ]]; then                        
      printf "${GREEN}%-1s ${WHITE}%-37s ${BRIGHTMAGENTA}%-5s${RESET}\n" " " "$expanded_dir" "$basename_icon"
    else                                                                      
      printf "${RED}%-1s ${WHITE}%-37s ${BRIGHTMAGENTA}%-5s${RESET}\n"   " " "$expanded_dir" "$basename_icon"
      ((success_count--))
    fi

  done

  # Footer
  local fail_count=$(($dir_count-$success_count))

  print_separator
  printf "${GREEN}%-2s ${BRIGHTBLACK}%-37s ${RESET}\n" "$success_count" 'Folder icon(s) updated successfully'
  [ $fail_count -eq 0 ] || printf "${RED}%-2s ${BRIGHTBLACK}%-37s ${RESET}\n" "$fail_count" 'Folder icon(s) failed to update'
  echo
}

update_all() {
  # Run the updates
  update_brew
  update_icons
  update_texlive
}
