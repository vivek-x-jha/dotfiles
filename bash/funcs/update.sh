#!/usrr/bin/env bash

update_feature_branches() {
  local branches=("$@")

  # Default branches
  [[ $# -eq 0 ]] && branches=(
    bootstrap
    fzf
    hammerspoon
    nvim
    shell
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

update_feature_branches() {
  local branches=("$@")

  # Default branches
  [[ $# -eq 0 ]] && branches=(
    bootstrap
    fzf
    hammerspoon
    nvim
    shell
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
