# shellcheck shell=bash
# shellcheck disable=SC2034
get_op_field() {
  local item="$1"
  local field="$2"
  local value=''

  ((USE_1PASSWORD)) || return 1
  ((DRY_RUN)) && printf '<dry-run:%s>\n' "$field" && return

  value=$(op item get "$item" \
    --vault "${OP_VAULT:-}" \
    --field "$field" \
    --reveal 2>/dev/null) || return 1

  printf '%s' "$value"
}

collect_environment() {
  # Sign into 1Password CLI when integration is enabled
  if ((USE_1PASSWORD)); then
    notify -s 'Signing into 1Password CLI'
    run 'op signin' || {
      logg -w 'Skipping 1Password features (signin failed).'
      USE_1PASSWORD=0
    }
  fi

  # Load any existing Git metadata as defaults
  local existing_git_name existing_git_email
  local existing_origin existing_github_name

  existing_git_name=$(git config --global user.name 2>/dev/null || true)
  existing_git_email=$(git config --global user.email 2>/dev/null || true)
  existing_origin=$(git -C "$HOME/.dotfiles" remote get-url origin 2>/dev/null || true)
  existing_github_name="$(printf '%s' "$existing_origin" | sed -n 's#.*github.com[:/]\([^/]*\)/.*#\1#p')"

  if ! bootstrap_config_bool BOOTSTRAP_INTERACTIVE 0; then
    local host fallback_email
    host="$(hostname -f 2>/dev/null || hostname 2>/dev/null || printf local)"
    fallback_email="${USER:-user}@$host"

    GIT_NAME="${BOOTSTRAP_GIT_NAME:-${existing_git_name:-${USER:-User}}}"
    GIT_EMAIL="${BOOTSTRAP_GIT_EMAIL:-${existing_git_email:-$fallback_email}}"
    GITHUB_NAME="${BOOTSTRAP_GITHUB_NAME:-${existing_github_name:-${GIT_EMAIL%@*}}}"

    if ((USE_1PASSWORD)); then
      OP_VAULT="${BOOTSTRAP_OP_VAULT:-Private}"
      ATUIN_OP_TITLE="${BOOTSTRAP_ATUIN_OP_TITLE:-Atuin Sync}"
      ATUIN_USERNAME="${BOOTSTRAP_ATUIN_USERNAME:-${GIT_EMAIL%@*}}"
      ATUIN_EMAIL="${BOOTSTRAP_ATUIN_EMAIL:-$GIT_EMAIL}"
    else
      OP_VAULT=''
      ATUIN_OP_TITLE=''
      ATUIN_USERNAME=''
      ATUIN_EMAIL=''
    fi

    MEDIA="${BOOTSTRAP_MEDIA:-}"

    logg -i "Git identity: $GIT_NAME <$GIT_EMAIL>"
    logg -i "GitHub user: $GITHUB_NAME"
    logg -i "Media directory: ${MEDIA:-<not set>}"
    return
  fi

  while true; do
    while true; do
      read -rp "${WHITE}>>> Git Username${RESET} (${existing_git_name:-required}): " GIT_NAME
      [[ -z $GIT_NAME && -n $existing_git_name ]] && GIT_NAME="$existing_git_name"
      [[ -n $GIT_NAME ]] && break
      logg -w 'Git username required.'
    done

    while true; do
      read -rp "${WHITE}>>> Git Email${RESET} (${existing_git_email:-required}): " GIT_EMAIL
      [[ -z $GIT_EMAIL && -n $existing_git_email ]] && GIT_EMAIL="$existing_git_email"
      [[ -n $GIT_EMAIL ]] && break
      logg -w 'Git email required.'
    done

    if ((USE_1PASSWORD)); then
      local default_vault=Private
      read -rp "${WHITE}>>> 1Password Vault name${RESET} (<Enter> for '$default_vault'): " OP_VAULT
      OP_VAULT="${OP_VAULT:-$default_vault}"

      read -rp "${WHITE}>>> GitHub User${RESET} (<Enter> to use '${GIT_EMAIL%@*}'): " GITHUB_NAME
      GITHUB_NAME="${GITHUB_NAME:-${GIT_EMAIL%@*}}"

      read -rp "${WHITE}>>> 1Password Atuin Sync Title${RESET} (<Enter> for 'Atuin Sync'): " ATUIN_OP_TITLE
      ATUIN_OP_TITLE="${ATUIN_OP_TITLE:-Atuin Sync}"

      read -rp "${WHITE}>>> Atuin Username${RESET} (<Enter> for '${GIT_EMAIL%@*}'): " ATUIN_USERNAME
      ATUIN_USERNAME="${ATUIN_USERNAME:-${GIT_EMAIL%@*}}"

      read -rp "${WHITE}>>> Atuin Email${RESET} (<Enter> for '$GIT_EMAIL'): " ATUIN_EMAIL
      ATUIN_EMAIL="${ATUIN_EMAIL:-$GIT_EMAIL}"
    else
      OP_VAULT=""
      read -rp "${WHITE}>>> GitHub User${RESET} (<Enter> to use '${GIT_EMAIL%@*}'): " GITHUB_NAME
      GITHUB_NAME="${GITHUB_NAME:-${GIT_EMAIL%@*}}"
      ATUIN_OP_TITLE=''
      ATUIN_USERNAME=''
      ATUIN_EMAIL=''
    fi

    read -rp "${WHITE}>>> Media directory ~/$MEDIA${RESET} (<Enter> to skip): " MEDIA
    MEDIA="${MEDIA:-}"

    cat <<EOF

${CYAN}-------------- ENVIRONMENT ------------------${RESET}
${MAGENTA}OS TYPE${RESET}: $DISTRO

${MAGENTA}XDG_CONFIG_HOME${RESET}=$(pretty_path "$XDG_CONFIG_HOME")
${MAGENTA}XDG_CACHE_HOME${RESET}=$(pretty_path "$XDG_CACHE_HOME")
${MAGENTA}XDG_DATA_HOME${RESET}=$(pretty_path "$XDG_DATA_HOME")
${MAGENTA}XDG_STATE_HOME${RESET}=$(pretty_path "$XDG_STATE_HOME")

${MAGENTA}GIT_NAME${RESET}=$GIT_NAME
${MAGENTA}GIT_EMAIL${RESET}=$GIT_EMAIL

${MAGENTA}GITHUB_NAME${RESET}=$GITHUB_NAME
${MAGENTA}OP_VAULT${RESET}=${OP_VAULT:-<unused>}

${MAGENTA}ATUIN_USERNAME${RESET}=${ATUIN_USERNAME:-<skipped>}
${MAGENTA}ATUIN_EMAIL${RESET}=${ATUIN_EMAIL:-<skipped>}
${MAGENTA}ATUIN_OP_TITLE${RESET}=${ATUIN_OP_TITLE:-<skipped>}

${MAGENTA}MEDIA${RESET}=~/${MEDIA:-<not set>}
${CYAN}---------------------------------------------${RESET}
EOF

    confirm "${YELLOW}Re-enter any variables?${RESET}" "N" || break
  done
}

create_symlinks() {
  local vscode_src='../../../.dotfiles/editors/vscode/settings.json'

  local dirs=(
    "$XDG_CACHE_HOME"
    "$XDG_CACHE_HOME/npm"
    "$HOME/.local/bin"
    "$XDG_STATE_HOME/bash"
    "$XDG_STATE_HOME/codex"
    "$XDG_STATE_HOME/jupyter/runtime"
    "$XDG_STATE_HOME/less"
    "$XDG_STATE_HOME/mycli"
    "$XDG_STATE_HOME/mysql"
    "$XDG_STATE_HOME/python"
    "$XDG_STATE_HOME/ipython"
    "$XDG_STATE_HOME/zsh"
    "$XDG_CONFIG_HOME/claude"
    "$XDG_CONFIG_HOME/jupyter"
    "$XDG_CONFIG_HOME/npm"
    "$XDG_DATA_HOME/jupyter"
    "$XDG_DATA_HOME/zsh"
    "$XDG_DATA_HOME/vscode"
  )

  local symlinks=(
    ../.dotfiles/cli/atuin "$XDG_CONFIG_HOME" atuin
    ../.dotfiles/cli/bat "$XDG_CONFIG_HOME" bat
    ../.dotfiles/cli/btop "$XDG_CONFIG_HOME" btop
    ../.dotfiles/cli/dust "$XDG_CONFIG_HOME" dust
    ../.dotfiles/cli/eza "$XDG_CONFIG_HOME" eza
    ../.dotfiles/cli/fzf "$XDG_CONFIG_HOME" fzf
    ../.dotfiles/cli/gh "$XDG_CONFIG_HOME" gh
    ../../.dotfiles/ai/claude/settings.json "$XDG_CONFIG_HOME/claude" settings.json
    ../.dotfiles/auth/git "$XDG_CONFIG_HOME" git
    ../.dotfiles/cli/glow "$XDG_CONFIG_HOME" glow
    ../.dotfiles/cli/matplotlib "$XDG_CONFIG_HOME" matplotlib
    ../.dotfiles/cli/mycli "$XDG_CONFIG_HOME" mycli
    ../.dotfiles/cli/npm "$XDG_CONFIG_HOME" npm
    ../.dotfiles/editors/nvim "$XDG_CONFIG_HOME" nvim
    ../.dotfiles/editors/vscode "$XDG_CONFIG_HOME" vscode
    ../.dotfiles/shells "$XDG_CONFIG_HOME" shells
    ../.dotfiles/auth/ssh "$XDG_CONFIG_HOME" ssh
    ../.dotfiles/terminals/tmux "$XDG_CONFIG_HOME" tmux
    ../.dotfiles/terminals/wezterm "$XDG_CONFIG_HOME" wezterm
    shells/starship.toml "$XDG_CONFIG_HOME" starship.toml
    .local/share/vscode "$HOME" .vscode
    .config/shells/bash/.bash_profile "$HOME" .bash_profile
    .config/shells/bash/.bashrc "$HOME" .bashrc
    .config/shells/env "$HOME" .zshenv
  )

  # Ensure application directories are created
  for dir in "${dirs[@]}"; do run "mkdir -p \"$dir\""; done

  # Add macOS specific tools
  [[ $OS_TYPE == macos ]] && {
    local app_data="$HOME/Library/Application Support"

    symlinks+=(
      ../.dotfiles/apps/hammerspoon "$XDG_CONFIG_HOME" hammerspoon
      ../.dotfiles/apps/karabiner "$XDG_CONFIG_HOME" karabiner
      ../../.dotfiles/cli/eza "$app_data" eza
    )

    vscode_src="../$vscode_src"
  }

  # Link Visual Studio Code settings
  local vscode_target="${app_data:-$XDG_CONFIG_HOME}/Code/User"
  symlinks+=("$vscode_src" "$vscode_target" settings.json)

  # Link 1Password ssh config
  ((USE_1PASSWORD)) && symlinks+=(../.dotfiles/auth/1Password "$XDG_CONFIG_HOME" 1Password)

  # Link MEDIA directory (i.e. Dropbox/)
  [[ -z $MEDIA ]] && logg -w 'Media path not set. Skipping media symlinks...'

  [[ -n $MEDIA && -d "$HOME/$MEDIA" ]] && symlinks+=(
    "../$MEDIA/content" "$HOME/Movies" content
    "../$MEDIA/icons" "$HOME/Pictures" icons
    "../$MEDIA/screenshots" "$HOME/Pictures" screenshots
    "../$MEDIA/wallpapers" "$HOME/Pictures" wallpapers
    "../$MEDIA/education" "$HOME/Documents" education
    "../$MEDIA/finances" "$HOME/Documents" finances
  )

  # Ensure all links are created
  for ((i = 0; i < ${#symlinks[@]}; i += 3)); do
    local src="${symlinks[i]}"
    local base="${symlinks[i+1]}"
    local target="${symlinks[i+2]}"

    # Ensure required args are present
    [[ -n $src && -n $base && -n $target ]] || {
      logg -e 'Missing required arg(s): Usage: symlink <source> <base_dir> <target>'
      continue
    }

    # Ensure base directory of target link exists
    [[ -d $base ]] || run "mkdir -p \"$base\""

    # Bail early if we can't enter the base directory (e.g., permissions)
    pushd "$base" &>/dev/null || {
      logg -w "Skipping link (unable to enter $base)"
      continue
    }

    # Skip if the source path is missing
    [[ -e $src || -L $src ]] || {
      logg -w "Skipping link (missing source: $base/$src)"
      popd >/dev/null || true
      continue
    }

    # Remove an existing symlink before relinking. `ln -sf` may follow a
    # symlinked directory and create nested links inside the source tree.
    [[ -L $target ]] && run "rm -f \"$target\""

    # Backup target directory
    [[ -d $target && ! -L $target ]] && run "mv -f \"$target\" \"${target}.bak\""

    # Create symlink (respects DRY_RUN via run)
    run "ln -sf \"$src\" \"$target\"" && logg -i "[+ Link: $src -> $base/$target]"
    popd >/dev/null || true
  done

}

configure_codex_environment() {
  local codex_home="${CODEX_HOME:-$XDG_STATE_HOME/codex}"
  export CODEX_HOME="$codex_home"

  [[ $OS_TYPE == macos ]] || return
  require launchctl || return

  run "launchctl setenv XDG_CONFIG_HOME \"$XDG_CONFIG_HOME\""
  run "launchctl setenv XDG_CACHE_HOME \"$XDG_CACHE_HOME\""
  run "launchctl setenv XDG_DATA_HOME \"$XDG_DATA_HOME\""
  run "launchctl setenv XDG_STATE_HOME \"$XDG_STATE_HOME\""
  run "launchctl setenv CODEX_HOME \"$codex_home\""
  logg -i "Codex Desktop launch environment: CODEX_HOME=$(pretty_path "$codex_home")"
}

configure_codex_ui() {
  local codex_home="${CODEX_HOME:-$XDG_STATE_HOME/codex}"
  local config_path="$codex_home/config.toml"
  local script_path="$HOME/.dotfiles/ai/codex/scripts/apply_preferences.py"
  local preferences_path="$HOME/.dotfiles/ai/codex/themes/sourdiesel.toml"

  require python3 || {
    logg -w 'Python 3 unavailable. Skipping Codex UI preference configuration.'
    return
  }

  [[ -f $script_path && -f $preferences_path ]] || {
    logg -w 'Codex UI preference source files missing. Skipping Codex configuration.'
    return
  }

  run "mkdir -p \"$codex_home\""
  run "python3 \"$script_path\" \"$config_path\" \"$preferences_path\"" || logg -w 'Codex UI preference configuration failed.'
  logg -i "Codex SourDiesel UI preferences: $(pretty_path "$preferences_path")"
}

configure_macos_defaults() {
  [[ $OS_TYPE != macos ]] && logg -w "Skipping macOS UI tweaks on $DISTRO" && return

  # Ensure screenshots folder exists
  local screenshots="$HOME/Pictures/screenshots"
  run "mkdir -p \"$screenshots\""

  # domain | key | option | value
  local settings=(
    'com.apple.dock autohide-delay -float 0.1'
    'com.apple.dock autohide -bool true'
    'com.apple.dock autohide-time-modifier -int 0'
    'com.apple.dock appswitcher-all-displays -bool true'
    'com.apple.dock expose-animation-duration -float 0.1'
    'com.apple.finder FXPreferredViewStyle -string Nlsv'
    'com.apple.finder QuitMenuItem -bool true'
    'com.apple.finder AppleShowAllFiles -bool true'
    'com.apple.finder FXEnableExtensionChangeWarning -bool false'
    "com.apple.screencapture location -string $screenshots"
  )

  local entry dom key opt val

  # Update defaults settings
  for entry in "${settings[@]}"; do
    read -r dom key opt val <<<"$entry"
    local setting="$dom $key $opt $val"

    run "defaults write \"$setting\""
  done

  # Reset dock for settings to take effect
  run 'killall Dock'
}

configure_git_and_github() {
  local github="git@github.com:$GITHUB_NAME/dotfiles.git"

  run "git config --global user.name \"$GIT_NAME\""
  run "git config --global user.email \"$GIT_EMAIL\""

  if ((DRY_RUN)); then
    logg -i "[dry-run] git -C $HOME/.dotfiles remote set-url origin $github"
  else
    git -C "$HOME/.dotfiles" remote set-url origin "$github" 2>/dev/null || logg -w 'Failed to update origin remote.'
    if [[ $GITHUB_NAME != "vivek-x-jha" ]]; then
      git -C "$HOME/.dotfiles" remote add upstream "$github" 2>/dev/null || true
    fi
  fi

  if ((USE_1PASSWORD)); then
    local agent_file="$XDG_CONFIG_HOME/1Password/ssh/agent.toml"
    if [[ -f $agent_file ]]; then
      if ((DRY_RUN)); then
        logg -i "[dry-run] perl -pi -e \"s/vault = \\\"Private\\\"/vault = \\\"$OP_VAULT\\\"/g\" $agent_file"
      else
        perl -pi -e "s/vault = \"Private\"/vault = \"$OP_VAULT\"/g" "$agent_file"
      fi
    else
      logg -w "1Password SSH agent config not found at $agent_file"
    fi
  fi

  if command -v gh &>/dev/null && confirm_config BOOTSTRAP_GH_AUTH 'Authenticate GitHub CLI' 'N'; then
    if ((DRY_RUN)); then
      logg -i '[dry-run] gh auth login'
      logg -i "[dry-run] gh repo set-default $GITHUB_NAME/dotfiles"
    else
      run "cd \"$HOME/.dotfiles\" && gh auth login"
      run "cd \"$HOME/.dotfiles\" && gh repo set-default \"$GITHUB_NAME/dotfiles\""
    fi
  elif ! command -v gh &>/dev/null; then
    logg -w 'GitHub CLI not installed. Skipping gh auth.'
  fi

  run "rm -f \"$HOME/.dotfiles/cli/gh/hosts.yml\""
}
