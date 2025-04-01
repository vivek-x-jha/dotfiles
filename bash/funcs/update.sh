#!/usr/bin/env bash

update_feature_branches() {
  local default=main
  local branches=("$@")

  # Dynamically fetch feature branches if no arguments are provided
  [[ $# -eq 0 ]] && mapfile -t branches < <(git branch --format='%(refname:short)' | grep '^feature/')

  for branch in "${branches[@]}"; do
    # Check if branch exists
    git branch --format='%(refname:short)' | grep -Fxq "$branch" || {
      printf "${RED}  '%s' not found${RESET} - run ${GREEN}'git branch'${RESET} to show available branches\n" "$branch"
      continue
    }

    # Perfom merge
    git switch "$branch" &>/dev/null
    git merge "$default" &>/dev/null

    # Print success message after switching
    printf "${GREEN}  ${RESET}${CYAN}%s${RESET} -> ${MAGENTA}${default}${RESET}\n" "$branch"
  done

  # Return to main branch
  git switch "$default" &>/dev/null
}

update_icons() {
  # Check for 'fileicon' binary
  command -v fileicon &>/dev/null || {
    printf "${BRIGHTRED}%s %s${BRIGHTYELLOW}%s${RESET}\n" "" "'fileicon' dependency not found" " - please install or check in \$PATH."
    return 1
  }

  table_width=60

  # Directory - Icons
  dir_icons=(
    "/Applications/1Password.app" "$HOME/Pictures/icons/1password-macos.png"
    "/Applications/ChatGPT.app" "$HOME/Pictures/icons/chatgpt.png"
    "/Applications/Cursor.app" "$HOME/Pictures/icons/cursor-ai-macos.png"
    "/Applications/Discord.app" "$HOME/Pictures/icons/discord-macos.png"
    "/Applications/Docker.app" "$HOME/Pictures/icons/docker.png"
    "/Applications/Figma.app" "$HOME/Pictures/icons/figma.png"
    "/Applications/Firefox.app" "$HOME/Pictures/icons/firefox-macos.png"
    "/Applications/Google Chrome.app" "$HOME/Pictures/icons/chrome.png"
    "/Applications/iTerm.app" "$HOME/Pictures/icons/iterm2.png"
    "/Applications/iTermAI.app" "$HOME/Pictures/icons/ai-brain.png"
    "/Applications/KeyCastr.app" "$HOME/Pictures/icons/keycastr.png"
    "/Applications/Mimestream.app" "$HOME/Pictures/icons/gmail.png"
    "/Applications/Neovim-iTerm.app" "$HOME/Pictures/icons/neovim-iterm.png"
    "/Applications/Neovim-Wezterm.app" "$HOME/Pictures/icons/neovim-wezterm.png"
    "/Applications/Postman.app" "$HOME/Pictures/icons/postman.png"
    "/Applications/Slack.app" "$HOME/Pictures/icons/slack.png"
    "/Applications/Spotify.app" "$HOME/Pictures/icons/spotify.png"
    "/Applications/Visual Studio Code.app" "$HOME/Pictures/icons/vscode.png"
    "/Applications/WezTerm.app" "$HOME/Pictures/icons/wezterm.png"
    "/Applications/WhatsApp.app" "$HOME/Pictures/icons/whatsapp.png"
    "$HOME/Developer" "$HOME/Pictures/icons/developer.png"
    "$HOME/Downloads" "$HOME/Pictures/icons/download.png"
    "$HOME/Dropbox/content" "$HOME/Pictures/icons/content.png"
    "$HOME/Pictures/icons" "$HOME/Pictures/icons/png.png"
    "$HOME/Pictures/screenshots" "$HOME/Pictures/icons/screenshot.png"
    "$HOME/Pictures/wallpapers" "$HOME/Pictures/icons/wallpaper.png"
    "$HOME/.dotfiles" "$HOME/Pictures/icons/gear.png"
  )

  print_separator() {
    printf "${BRIGHTBLACK}%-${table_width}s${RESET}\n" | tr ' ' '-'
  }

  # Create header
  print_separator
  printf "%-2s ${BLUE}%-37s ${MAGENTA}%-5s${RESET}\n" '' 'App / Directory' \~/Pictures/icons/
  print_separator

  # Create rows
  for ((i = 0; i < ${#dir_icons[@]}; i += 2)); do
    dir="${dir_icons[i]}"
    icon="${dir_icons[i + 1]}"
    short_dir="${dir/#$HOME/'~'}"

    print_status() {
      printf "${1}%-1s ${WHITE}%-37s ${BRIGHTMAGENTA}%-5s${RESET}\n" "$2" "$short_dir" "$(basename "$icon")"
    }

    if sudo fileicon set "$dir" "$icon" &>/dev/null || [[ $(basename "$dir") == 'Mimestream.app' ]]; then
      print_status "${GREEN}" " "
      ((success++))
    else
      print_status "${RED}" " "
      ((fail++))
    fi
  done

  # Create Footer
  print_separator
  printf "${GREEN}%-2s ${BRIGHTBLACK}%-37s${RESET}\n" "${success:-0}" 'Folder icon(s) updated successfully'
  [[ -z $fail ]] || printf "${RED}%-2s ${BRIGHTBLACK}%-37s${RESET}\n" "$fail" 'Folder icon(s) failed to update'
}

update_all() {
  # Run homebrew command and cask updates
  brew upgrade
  brew cu -af

  # Run homebrew utilities
  brew cleanup
  brew doctor
  brew bundle dump --force --file="${1:-$HOME/.dotfiles/Brewfile}"

  # Customize app icon for any upgraded cask
  update_icons

  # Update Tex Live Utility
  # sudo tlmgr update --self --all
}
