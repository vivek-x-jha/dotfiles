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

  # Create Color Table Header
  print_separator() { printf "${brightblack}%-${table_width}s${reset}\n" | tr ' ' '-'; }

  print_separator
  printf "${white}%-4s %-14s %-8s %-8s${reset}\n" 'VGA' 'COLOR' 'HEX' 'ANSI'
  print_separator

  # Create Color Table Rows
  for ((i=0; i<${#colors[@]}; i+=4)); do
    local vga="${colors[i]}"
    local name="${colors[i+1]}"
    local hex="${colors[i+2]}"
    local ansi="${colors[i+3]}"

    if [[ "$name" == 'reset' ]]; then
      local linecolor=''
    else
      local linecolor=${!name}
    fi

    # Indirect Substitution of name as color variable
    printf "${linecolor}%-4s %-14s %-8s %-8s${reset}\n" "$vga" "$name" "$hex" "$ansi"
  done
  echo
}

update_texlive() {
  sudo tlmgr update --self --all
}

update_brew() {
  brew upgrade
  brew cu -af
  brew cleanup
  brew doctor
  brew bundle dump --force --file="$DOT/.Brewfile"
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
    /Applications/WezTerm.app              ~/Pictures/icons/wezterm.png

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

update_all() {
  # Keep sudo alive for the duration of the script
  sudo -v
  # while true; do
  #   sudo -n true
  #   sleep 60
  # done 2>/dev/null &

  # # Store the PID of the keep-alive process
  # sudo_keep_alive_pid=$!

  # # Ensure the keep-alive process is killed when the script exits
  # trap "kill $sudo_keep_alive_pid" EXIT

  # Run the updates
  update_brew
  update_icons
  update_texlive
}
