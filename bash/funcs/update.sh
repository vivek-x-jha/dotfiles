#!/usrr/bin/env bash

update_feature_branches() {
  local branches=("$@")

  # Dynamically fetch feature branches if no arguments are provided
  [[ $# -eq 0 ]] && mapfile -t branches < <(git branch --format='%(refname:short)' | grep '^feature/')

  for branch in "${branches[@]}"; do
    # Check if branch exists
    git branch --format='%(refname:short)' | grep -Fxq "$branch" || { printf "${RED} '%s' not found${RESET} - run ${GREEN}'git branch'${RESET} to show available branches\n" "$branch"; continue; }

    # Perfom merge
    git switch "$branch" &>/dev/null 
    git merge main &>/dev/null

    # Print success message after switching
    printf "${GREEN}  ${RESET}${CYAN}%s${RESET} -> ${MAGENTA}main${RESET}\n" "$branch"
  done
}

update_icons() {
  # Create directory-icons association
  command -v fileicon &>/dev/null || { printf "${BRIGHTRED}%s %s${BRIGHTYELLOW}%s${RESET}\n" "" "'fileicon' dependency not found" " - please install or check in \$PATH."; return 1; }

  local table_width=60
  declare -A dir_icons=(
    [/Applications/1Password.app]=~/Pictures/icons/1password-macos.png
    [/Applications/ChatGPT.app]=~/Pictures/icons/chatgpt.png
    [/Applications/Discord.app]=~/Pictures/icons/discord-macos.png
    [/Applications/Docker.app]=~/Pictures/icons/docker.png
    [/Applications/Figma.app]=~/Pictures/icons/figma.png
    [/Applications/Firefox.app]=~/Pictures/icons/firefox-macos.png
    [/Applications/Google\ Chrome.app]=~/Pictures/icons/chrome.png
    [/Applications/iTerm.app]=~/Pictures/icons/iterm2.png
    [/Applications/iTermAI.app]=~/Pictures/icons/ai-brain.png
    [/Applications/KeyCastr.app]=~/Pictures/icons/keycastr.png
    [/Applications/Mimestream.app]=~/Pictures/icons/gmail.png
    [/Applications/Neovim-iTerm.app]=~/Pictures/icons/neovim-iterm.png
    [/Applications/Neovim-Wezterm.app]=~/Pictures/icons/neovim-wezterm.png
    [/Applications/Postman.app]=~/Pictures/icons/postman.png
    [/Applications/Slack.app]=~/Pictures/icons/slack.png
    [/Applications/Spotify.app]=~/Pictures/icons/spotify.png
    [/Applications/Visual\ Studio\ Code.app]=~/Pictures/icons/vscode.png
    [/Applications/WezTerm.app]=~/Pictures/icons/wezterm.png
    [/Applications/WhatsApp.app]=~/Pictures/icons/whatsapp.png
    [~/Developer]=~/Pictures/icons/developer.png
    [~/Downloads]=~/Pictures/icons/download.png
    [~/Dropbox/content]=~/Pictures/icons/content.png
    [~/Pictures/icons]=~/Pictures/icons/png.png
    [~/Pictures/screenshots]=~/Pictures/icons/screenshot.png
    [~/Pictures/wallpapers]=~/Pictures/icons/wallpaper.png
    [~/.dotfiles]=~/Pictures/icons/gear.png
  )

  # Create Directory-Icons Table Header
  print_separator() { printf "${BRIGHTBLACK}%-${table_width}s${RESET}\n" | tr ' ' '-'; }

  print_separator
  printf "%-2s ${BLUE}%-37s ${MAGENTA}%-5s${RESET}\n" '' 'App / Directory' \~/Pictures/icons/
  print_separator

  # Sort keys while preserving spaces in the directories
  mapfile -t sorted_dirs < <(printf '%s\n' "${!dir_icons[@]}" | sort)

  local dir_count="${#sorted_dirs[@]}"
  local success_count=$dir_count

  # Create Directory-Icons Table Rows
  local icon directory

  for dir in "${sorted_dirs[@]}"; do
    icon=${dir_icons[$dir]}
    directory=${dir/#$HOME/\~}

    # Function to print the status of setting file icons
    print_status() { printf "${1}%-1s ${WHITE}%-37s ${BRIGHTMAGENTA}%-5s${RESET}\n" "$2" "$directory" "$(basename "$icon")"; }

    if sudo fileicon set "$dir" "$icon" &> /dev/null || [[ $(basename "$directory") == 'Mimestream.app' ]]; then
      print_status "${GREEN}" " "
    else
      print_status "${RED}" " "
      ((success_count--))
    fi
  done

  # Footer
  local fail_count=$(( dir_count - success_count ))

  print_separator
  printf "${GREEN}%-2s ${BRIGHTBLACK}%-37s ${RESET}\n" "$success_count" 'Folder icon(s) updated successfully'
  [ $fail_count -eq 0 ] || printf "${RED}%-2s ${BRIGHTBLACK}%-37s ${RESET}\n" "$fail_count" 'Folder icon(s) failed to update'
}

update_all() {
  # Run homebrew command and cask updates
  brew upgrade
  brew cu -af

  # Run homebrew utilities
  brew cleanup
  brew doctor
  brew bundle dump --force --file="$XDG_CONFIG_HOME/brew/.Brewfile"

  # Customize app icon for any upgraded cask
  update_icons

  # Update Tex Live Utility
  # sudo tlmgr update --self --all
}
