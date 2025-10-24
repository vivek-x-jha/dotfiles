#!/usr/bin/env bash

clear

# -------------------------------------- COLORS + ICON -------------------------------------

# BLACK=$'\e[0;30m'
RED=$'\e[0;31m'
GREEN=$'\e[0;32m'
YELLOW=$'\e[0;33m'
BLUE=$'\e[0;34m'
MAGENTA=$'\e[0;35m'
CYAN=$'\e[0;36m'
WHITE=$'\e[0;37m'

RESET=$'\e[0m'
ICON='󰓒'

# -------------------------------------- GLOBALS & DEFAULTS -------------------------------------

STEP=0
SUBSTEP=0
TOTAL_STEPS=17

DRY_RUN=0

USE_1PASSWORD=0
FORCE_1PASSWORD=0
KEEP_SUDO_PID=''

OS_TYPE=''
DISTRO=''
PKG_MGR=''
BREWFILE_DEFAULT='https://raw.githubusercontent.com/vivek-x-jha/dotfiles/refs/heads/main/Brewfile'
APT_MANIFEST_DEFAULT="$HOME/.dotfiles/apt-packages.txt"

# -------------------------------------- HELPER FUNCTIONS -------------------------------------

# [HF1] print standardized and colorized log messages
# Usage: logg -i | -w | -e "message"
logg() {
  local opt="$1"
  local level=''
  local color=''

  case "$opt" in
  -i) level=INFO ;;
  -w) level=WARN && color="$YELLOW" ;;
  -e) level=ERROR && color="$MAGENTA" ;;
  *) printf 'log: missing or invalid level flag\n' >&2 && return 1 ;;
  esac

  shift
  printf '%b[%s] %s%b\n' "$color" "$level" "$*" "$RESET"
}

# [HF2] print step progress message (supports main and substeps)
# Usage: notify [-s] "message"
notify() {
  local minor=''

  case "$1" in
  -s) SUBSTEP=$((SUBSTEP + 1)) && minor=".$SUBSTEP" && shift ;;
  *) STEP=$((STEP + 1)) && SUBSTEP=0 ;;
  esac

  printf '\n%s\n' "${GREEN}${ICON} [${STEP}${minor}/${TOTAL_STEPS}] $* ${ICON}${RESET}"
}

# [HF3] execute a command, honoring dry-run mode
# Usage: run "command"
run() {
  local cmd="$1"

  ((DRY_RUN)) && logg -i "[dry-run] $cmd" && return
  eval "$cmd"
}

# [HF4] Convert paths under $HOME into a tilde-prefixed display string
# Usage: pretty_path "/Users/me/.config"
pretty_path() {
  local path="$1"

  [[ $path == "$HOME"* ]] && printf '~%s' "${path#"$HOME"}" && return
  printf '%s' "$path"
}

# [HF5] ask a yes/no question with optional default
# Usage: confirm "prompt" [default]
confirm() {
  local prompt="$1"
  local default="${2:-}"
  local suffix answer

  case "$default" in
  y | Y) suffix=" [${CYAN}Y${RESET}/n]" ;;
  n | N) suffix=" [y/${CYAN}N${RESET}]" ;;
  *) suffix=' [y/n]' ;;
  esac

  while true; do
    read -rp ">>> $prompt$suffix: "

    answer=${REPLY:-$default}

    case "${answer,,}" in
    y | yes) return 0 ;;
    n | no) return 1 ;;
    esac

    logg -w 'Invalid input - please answer: <y,yes,n,no>'
  done
}

# [HF6] run 1Password CLI commands when integration is enabled
# Usage: safe_op_call <subcommand> [args...]
safe_op_call() {
  ((USE_1PASSWORD)) || return 1

  command -v op &>/dev/null || {
    logg -w '1Password CLI not installed. Skipping related action.'
    return 1
  }

  local quoted_args=()
  local cmd=op

  for arg in "$@"; do
    printf -v quoted_arg '%q' "$arg"
    quoted_args+=("$quoted_arg")
  done

  [[ ${#quoted_args[@]} -gt 0 ]] && cmd+=" ${quoted_args[*]}"

  run "$cmd"
}

# Determine OS and package-manager defaults
# Usage: detect_platform
detect_platform() {
  case "$(uname -s)" in
  Darwin)
    OS_TYPE=macos
    PKG_MGR=brew
    DISTRO=macOS
    ;;
  Linux)
    [[ -r /etc/os-release ]] || {
      logg -e 'Unable to detect Linux distribution (missing /etc/os-release).'
      exit 1
    }

    # shellcheck disable=SC1091
    source /etc/os-release
    DISTRO="${PRETTY_NAME:-${NAME:-Linux}}"

    case "${ID_LIKE:-}$ID" in
    *debian* | *ubuntu*)
      OS_TYPE=linux
      PKG_MGR=apt
      ;;
    *) logg -e "Linux distribution '$DISTRO' is not yet supported." && exit 1 ;;
    esac
    ;;
  *) logg -e "Unsupported operating system: $(uname -s)" && exit 1 ;;
  esac

  logg -i "TARGET PLATFORM: DISTRO=$DISTRO"
  logg -i "PACKAGE MANAGER: PKG_MGR=${PKG_MGR}${RESET}"
}

# Ensure required package manager tooling is present
# Usage: setup_package_manager
setup_package_manager() {
  if [[ $PKG_MGR == brew ]]; then
    notify -s 'Ensuring Homebrew is installed'
    if [[ -x /opt/homebrew/bin/brew || -x /usr/local/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
    else
      if ((DRY_RUN)); then
        logg -i '[dry-run] Install Homebrew'
      else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
      fi
    fi
  elif [[ $PKG_MGR == apt ]]; then
    notify -s 'Ensuring apt is available'
    command -v apt-get &>/dev/null || {
      logg -e "Missing command 'apt-get'. Install via: sudo apt install apt"
      exit 1
    }
  fi
}

# Install brew/apt package manifests and optional updates
# Usage: install_package_sets
install_package_sets() {
  if [[ $PKG_MGR == brew ]]; then
    if confirm 'Install packages & apps from Brewfile' 'Y'; then
      notify -s 'Select Brewfile'
      local brewfile
      read -rp '>>> Enter Brewfile path or URL (<Enter> to use default): ' brewfile
      [[ -z $brewfile ]] && brewfile="$BREWFILE_DEFAULT"
      logg -i "Using Brewfile: $brewfile"

      if [[ $brewfile =~ ^https?:// ]]; then
        if ((DRY_RUN)); then
          logg -i "[dry-run] curl -fsSL $brewfile | brew bundle --file=-"
        else
          curl -fsSL "$brewfile" | brew bundle --file=-
        fi
      else
        [[ $brewfile =~ ^~ ]] && brewfile="${HOME}${brewfile:1}"
        brewfile="${brewfile/#\~/$HOME}"
        if [[ -f $brewfile ]]; then
          if ((DRY_RUN)); then
            logg -i "[dry-run] brew bundle --file=$brewfile"
          else
            brew bundle --file="$brewfile"
          fi
        else
          logg -w "Invalid Brewfile path: $brewfile"
        fi
      fi
    fi

    notify -s 'Refresh Brewfile snapshot'
    if ((DRY_RUN)); then
      logg -i "[dry-run] brew bundle dump --force --file=$HOME/.dotfiles/Brewfile"
    else
      brew bundle dump --force --file="$HOME/.dotfiles/Brewfile"
    fi

    if confirm "Run brew cleanup & doctor" 'N'; then
      notify -s 'Running brew maintenance'
      ((DRY_RUN)) || brew cleanup
      ((DRY_RUN)) || brew doctor
    fi

    if confirm "Update brew formulae & casks" 'N'; then
      notify -s 'Updating Homebrew packages'
      ((DRY_RUN)) || brew upgrade
      if command -v brew &>/dev/null && brew tap | grep -q '^buo/cask-upgrade$'; then
        ((DRY_RUN)) || brew cu -af
      fi
    fi
  elif [[ $PKG_MGR == apt ]]; then
    if confirm "Update apt package lists" 'Y'; then
      notify -s 'Updating apt cache'
      if ((DRY_RUN)); then
        logg -i '[dry-run] sudo apt update'
      else
        sudo apt update
      fi
    fi

    if confirm "Upgrade installed apt packages" 'N'; then
      notify -s 'Upgrading apt packages'
      if ((DRY_RUN)); then
        logg -i '[dry-run] sudo apt upgrade -y'
      else
        sudo apt upgrade -y
      fi
    fi

    if [[ -f $APT_MANIFEST_DEFAULT ]]; then
      if confirm "Install apt packages from $(basename "$APT_MANIFEST_DEFAULT")" 'Y'; then
        notify -s 'Installing apt packages'
        mapfile -t apt_packages < <(grep -vE '^(#|\s*$)' "$APT_MANIFEST_DEFAULT")
        if [[ ${#apt_packages[@]} -gt 0 ]]; then
          if ((DRY_RUN)); then
            logg -i "[dry-run] sudo apt install -y ${apt_packages[*]}"
          else
            sudo apt install -y "${apt_packages[@]}"
          fi
        else
          logg -w "No packages listed in $APT_MANIFEST_DEFAULT"
        fi
      fi
    else
      logg -w "apt manifest not found at $APT_MANIFEST_DEFAULT. Create it to enable bulk installs."
    fi

    install_linux_optional_tools
  fi
}

# Fetch a secret field from 1Password if enabled
# Usage: get_op_field <item> <field>
get_op_field() {
  local item="$1"
  local field="$2"
  local value

  ((USE_1PASSWORD)) || return 1
  ((DRY_RUN)) && printf '\n' && return 0

  value=$(op item get "$item" --vault "$OP_VAULT" --field "$field" --reveal 2>/dev/null) || return 1
  printf '%s' "$value"
}

# Collect environment preferences and prompt for 1Password data
# Usage: collect_environment
collect_environment() {
  # Sign into 1Password CLI when integration is enabled
  ((USE_1PASSWORD)) && {
    notify -s 'Signing into 1Password CLI'
    safe_op_call signin || { logg -w 'Skipping 1Password features (signin failed).' && USE_1PASSWORD=0; }
  }

  # Load any existing Git metadata as defaults
  local existing_git_name existing_git_email existing_signingkey

  existing_git_name=$(git config --global user.name 2>/dev/null || true)
  existing_git_email=$(git config --global user.email 2>/dev/null || true)
  existing_signingkey=$(git config --global user.signingkey 2>/dev/null || true)

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

      OP_GIT_SIGNKEY="$(get_op_field 'GitHub Signing Key' 'public key' || true)"
      local obfuscated_key="${OP_GIT_SIGNKEY:0:18} ... ${OP_GIT_SIGNKEY: -10}"
      [[ -z $OP_GIT_SIGNKEY ]] && obfuscated_key=""

      read -rp "${WHITE}>>> Git Signing Key${RESET} (<Enter> to use '${obfuscated_key}'): " GIT_SIGNINGKEY
      GIT_SIGNINGKEY="${GIT_SIGNINGKEY:-${OP_GIT_SIGNKEY:-$existing_signingkey}}"

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
      GIT_SIGNINGKEY="${existing_signingkey:-}"
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
${MAGENTA}GIT_SIGNINGKEY${RESET}=${GIT_SIGNINGKEY:-<unset>}

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

# Create or refresh a symlink under the given base directory
# Usage: symlink <source> <base_dir> <link_name>
symlink() {
  local src="$1"
  local base="$2"
  local target="$3"

  if [[ -z $src || -z $base || -z $target ]]; then
    return
  fi

  if [[ ! -d $base ]]; then
    if ((DRY_RUN)); then
      logg -i "[dry-run] mkdir -p $base"
    else
      mkdir -p "$base"
    fi
  fi

  if ! pushd "$base" >/dev/null 2>&1; then
    logg -w "Skipping link (unable to enter $base)"
    return
  fi

  if [[ ! -e $src && ! -L $src ]]; then
    logg -w "Skipping link (missing source: $base/$src)"
    popd >/dev/null || return
    return
  fi

  if ((DRY_RUN)); then
    logg -i "[dry-run] ln -sf $src -> $base/$target"
    popd >/dev/null || return
    return
  fi

  [[ -d $target && ! -L $target ]] && mv -f "$target" "${target}.bak"
  ln -sf "$src" "$target"
  logg -i "[+ Link: $src -> $base/$target]"
  popd >/dev/null || return
}

# Link dotfiles into their XDG targets and optional media directory.
# Usage: create_symlinks
create_symlinks() {
  local vscode_src='../../../.dotfiles/vscode/settings.json'

  local dirs=(
    "$XDG_CACHE_HOME"
    "$XDG_STATE_HOME/bash"
    "$XDG_STATE_HOME/codex"
    "$XDG_STATE_HOME/less"
    "$XDG_STATE_HOME/mycli"
    "$XDG_STATE_HOME/mysql"
    "$XDG_STATE_HOME/python"
    "$XDG_STATE_HOME/zsh"
    "$XDG_DATA_HOME/zsh"
  )

  local symlinks=(
    .dotfiles/bash/.bash_profile "$HOME" .bash_profile
    .dotfiles/bash/.bashrc "$HOME" .bashrc
    .dotfiles/zsh/.zshenv "$HOME" .zshenv
    ../.dotfiles/atuin "$XDG_CONFIG_HOME" atuin
    ../.dotfiles/bash "$XDG_CONFIG_HOME" bash
    ../.dotfiles/bat "$XDG_CONFIG_HOME" bat
    ../.dotfiles/blesh "$XDG_CONFIG_HOME" blesh
    ../.dotfiles/browser "$XDG_CONFIG_HOME" browser
    ../.dotfiles/btop "$XDG_CONFIG_HOME" btop
    ../.dotfiles/dust "$XDG_CONFIG_HOME" dust
    ../.dotfiles/eza "$XDG_CONFIG_HOME" eza
    ../.dotfiles/fzf "$XDG_CONFIG_HOME" fzf
    ../.dotfiles/gh "$XDG_CONFIG_HOME" gh
    ../.dotfiles/git "$XDG_CONFIG_HOME" git
    ../.dotfiles/glow "$XDG_CONFIG_HOME" glow
    ../.dotfiles/mycli "$XDG_CONFIG_HOME" mycli
    ../.dotfiles/nvim "$XDG_CONFIG_HOME" nvim
    ../.dotfiles/ssh "$XDG_CONFIG_HOME" ssh
    ../.dotfiles/tmux "$XDG_CONFIG_HOME" tmux
    ../.dotfiles/wezterm "$XDG_CONFIG_HOME" wezterm
    ../.dotfiles/yazi "$XDG_CONFIG_HOME" yazi
    ../.dotfiles/zsh "$XDG_CONFIG_HOME" zsh
    ../.dotfiles/starship/config.toml "$XDG_CONFIG_HOME" starship.toml
    themes/sourdiesel.yml "$XDG_CONFIG_HOME/eza" theme.yml
  )

  # Ensure application directories are created
  for dir in "${dirs[@]}"; do run "mkdir -p \"$dir\""; done

  # Add macOS specific tools
  [[ $OS_TYPE == macos ]] && {
    local app_data="$HOME/Library/Application Support"

    symlinks+=(
      ../.dotfiles/hammerspoon "$XDG_CONFIG_HOME" hammerspoon
      ../.dotfiles/karabiner "$XDG_CONFIG_HOME" karabiner
      ../../.dotfiles/eza "$app_data" eza
    )

    vscode_src="../$vscode_src"
  }

  # Link Visual Studio Code settings
  local vscode_target="${app_data:-$XDG_CONFIG_HOME}/Code/User"
  symlinks+=("$vscode_src" "$vscode_target" settings.json)

  # Link 1Password ssh config
  ((USE_1PASSWORD)) && symlinks+=(../.dotfiles/1Password "$XDG_CONFIG_HOME" 1Password)

  # Link MEDIA directory (i.e. Dropbox/)
  [[ -z $MEDIA ]] && logg -w 'Media path not set. Skipping media symlinks...'

  [[ -n $MEDIA && -d "$HOME/$MEDIA" ]] && symlinks+=(
    "$MEDIA/developer" "$HOME" Developer
    "../$MEDIA/content" "$HOME/Movies" content
    "../$MEDIA/icons" "$HOME/Pictures" icons
    "../$MEDIA/screenshots" "$HOME/Pictures" screenshots
    "../$MEDIA/wallpapers" "$HOME/Pictures" wallpapers
    "../$MEDIA/education" "$HOME/Documents" education
    "../$MEDIA/finances" "$HOME/Documents" finances
  )

  # Ensure all links are created
  for ((i = 0; i < ${#symlinks[@]}; i += 3)); do
    symlink "${symlinks[i]}" "${symlinks[i + 1]}" "${symlinks[i + 2]}"
  done
}

# Apply preferred macOS UI defaults
# Usage: configure_macos_defaults
configure_macos_defaults() {
  if [[ $OS_TYPE != macos ]]; then
    logg -w "Skipping macOS UI tweaks on $DISTRO."
    return
  fi

  run "mkdir -p $HOME/Pictures/screenshots"
  run "defaults write com.apple.screencapture location -string $HOME/Pictures/screenshots"

  local defaults_settings=(
    'com.apple.dock autohide-delay -float 0.1'
    'com.apple.dock autohide -bool true'
    'com.apple.dock autohide-time-modifier -int 0'
    'com.apple.dock appswitcher-all-displays -bool true'
    'com.apple.dock expose-animation-duration -float 0.1'
    'com.apple.finder FXPreferredViewStyle -string Nlsv'
    'com.apple.finder QuitMenuItem -bool true'
    'com.apple.finder AppleShowAllFiles -bool true'
    'com.apple.finder FXEnableExtensionChangeWarning -bool false'
  )

  local domain key option value
  for entry in "${defaults_settings[@]}"; do
    read -r domain key option value <<<"$entry"
    run "defaults write $domain $key $option $value"
  done

  run 'killall Dock'
}

# Configure git/user settings and GitHub CLI defaults
# Usage: configure_git_and_github
configure_git_and_github() {
  if ((DRY_RUN)); then
    logg -i "[dry-run] git config --global user.name $GIT_NAME"
    logg -i "[dry-run] git config --global user.email $GIT_EMAIL"
    [[ -n $GIT_SIGNINGKEY ]] && logg -i "[dry-run] git config --global user.signingkey $GIT_SIGNINGKEY"
  else
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    [[ -n $GIT_SIGNINGKEY ]] && git config --global user.signingkey "$GIT_SIGNINGKEY"
  fi

  local github="git@github.com:$GITHUB_NAME/dotfiles.git"

  if ((DRY_RUN)); then
    logg -i "[dry-run] git -C $HOME/.dotfiles remote set-url origin $github"
  else
    git -C "$HOME/.dotfiles" remote set-url origin "$github" 2>/dev/null || logg -w 'Failed to update origin remote.'
    if [[ $GITHUB_NAME != "vivek-x-jha" ]]; then
      git -C "$HOME/.dotfiles" remote add upstream "$github" 2>/dev/null || true
    fi
  fi

  local allowed_signers="$XDG_CONFIG_HOME/ssh/allowed_signers"
  [[ -n $GIT_SIGNINGKEY ]] && run "printf '%s\n' \"$GIT_EMAIL $GIT_SIGNINGKEY\" > \"$allowed_signers\""

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

  if command -v gh &>/dev/null; then
    if ((DRY_RUN)); then
      logg -i '[dry-run] gh auth login'
      logg -i "[dry-run] gh repo set-default $GITHUB_NAME/dotfiles"
    else
      (cd "$HOME/.dotfiles" && gh auth login)
      (cd "$HOME/.dotfiles" && gh repo set-default "$GITHUB_NAME/dotfiles")
    fi
  else
    logg -w 'GitHub CLI not installed. Skipping gh auth.'
  fi

  if ((DRY_RUN)); then
    logg -i "[dry-run] rm -f $HOME/.dotfiles/gh/hosts.yml"
    logg -i '[dry-run] git add --all'
  else
    rm -f "$HOME/.dotfiles/gh/hosts.yml"
    git -C "$HOME/.dotfiles" add --all || true
  fi
}

# Clone or update project template repository
# Usage: install_templates
install_templates() {
  if command -v gh &>/dev/null; then
    if ((DRY_RUN)); then
      logg -i "[dry-run] gh repo clone vivek-x-jha/templates $XDG_DATA_HOME/templates"
    else
      gh repo clone vivek-x-jha/templates "$XDG_DATA_HOME/templates" 2>/dev/null || logg -w 'gh repo clone failed (already exists?).'
    fi
  else
    logg -w 'GitHub CLI not available. Skipping template clone.'
  fi
}

# Install zap and ble.sh shell plugins
# Usage: install_shell_plugins
install_shell_plugins() {
  if [[ ! -f $XDG_DATA_HOME/zap/zap.zsh ]]; then
    if ((DRY_RUN)); then
      logg -i '[dry-run] zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 -k'
    else
      zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 -k
    fi
  fi

  if ((DRY_RUN)); then
    logg -i '[dry-run] git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git'
    logg -i "[dry-run] make -C ble.sh install PREFIX=$HOME/.local"
    logg -i '[dry-run] rm -rf ble.sh'
  else
    if git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git; then
      make -C ble.sh install PREFIX="$HOME/.local"
      rm -rf ble.sh
    else
      logg -w 'Unable to clone ble.sh'
    fi
  fi
}

# Provision Atuin sync credentials via 1Password
# Usage: setup_atuin_sync
setup_atuin_sync() {
  if ! command -v atuin &>/dev/null; then
    logg -w 'Atuin not installed. Skipping sync setup.'
    return
  fi

  if ! ((USE_1PASSWORD)); then
    logg -w '1Password disabled. Skipping Atuin vault automation.'
    return
  fi

  if ((DRY_RUN)); then
    logg -i "[dry-run] op item get $ATUIN_OP_TITLE --vault $OP_VAULT"
    logg -i '[dry-run] atuin register/login'
    return
  fi

  if ! safe_op_call item get "$ATUIN_OP_TITLE" --vault "$OP_VAULT" &>/dev/null; then
    safe_op_call item create \
      --vault "$OP_VAULT" \
      --category login \
      --title "$ATUIN_OP_TITLE" \
      --generate-password='letters,digits,symbols,32' \
      "username=$ATUIN_USERNAME" \
      "email[text]=$ATUIN_EMAIL" \
      "key[password]=<Update with \$(atuin key)>" >/dev/null
  fi

  local atuin_password
  atuin_password="$(get_op_field "$ATUIN_OP_TITLE" password)"
  if [[ -z $atuin_password ]]; then
    logg -w 'Failed to fetch Atuin password from 1Password. Skipping sync.'
    return
  fi

  atuin register -u "$ATUIN_USERNAME" -e "$ATUIN_EMAIL" -p "$atuin_password" || true
  safe_op_call item edit "$ATUIN_OP_TITLE" --vault "$OP_VAULT" key="$(atuin key)" >/dev/null

  atuin status | grep -q "$ATUIN_USERNAME" || (
    atuin logout
    atuin login -u "$ATUIN_USERNAME" -p "$atuin_password" -k "$(get_op_field "$ATUIN_OP_TITLE" key)"
  ) >/dev/null 2>&1

  atuin import auto
  atuin sync
}

# Rebuild bat's theme cache when available
# Usage: rebuild_bat_cache
rebuild_bat_cache() {
  if ! command -v bat &>/dev/null; then
    logg -w 'bat not installed. Skipping cache rebuild.'
    return
  fi
  if ((DRY_RUN)); then
    logg -i '[dry-run] bat cache --build'
  else
    bat cache --build
  fi
}

# Configure Touch ID-backed sudo when supported
# Usage: configure_sudo_auth
configure_sudo_auth() {
  if [[ $OS_TYPE == macos ]]; then
    local brew_prefix
    brew_prefix=$(brew --prefix 2>/dev/null)
    if [[ -z $brew_prefix ]]; then
      logg -w 'Unable to determine Homebrew prefix for Touch ID setup.'
      return
    fi
    local pam_content="# Authenticate with Touch ID - even in tmux\nauth  optional    ${brew_prefix}/lib/pam/pam_reattach.so ignore_ssh\nauth  sufficient  pam_tid.so"
    if ((DRY_RUN)); then
      logg -i "[dry-run] sudo tee /etc/pam.d/sudo_local <<<'$pam_content'"
    else
      printf '%s\n' "$pam_content" | sudo tee /etc/pam.d/sudo_local >/dev/null
      logg -i 'UPDATED /etc/pam.d/sudo_local'
    fi
  else
    logg -w "Touch ID sudo configuration not applicable on $DISTRO."
  fi
}

# Suppress login banner by ensuring ~/.hushlogin exists
# Usage: suppress_login_banner
suppress_login_banner() {
  if ((DRY_RUN)); then
    logg -i "[dry-run] touch $HOME/.hushlogin"
  else
    touch "$HOME/.hushlogin"
  fi
  logg -i 'Ensured ~/.hushlogin exists'
}

# Ensure preferred shell binaries are registered and set as default
# Usage: change_shell_default
change_shell_default() {
  local shell_paths=()
  if [[ $OS_TYPE == macos ]]; then
    local brew_prefix
    brew_prefix=$(brew --prefix 2>/dev/null)
    if [[ -n $brew_prefix ]]; then
      shell_paths=("$brew_prefix/bin/bash" "$brew_prefix/bin/zsh")
    else
      logg -w 'Homebrew prefix unavailable; skipping shell change.'
      return
    fi
  else

    while IFS= read -r shell_candidate; do
      [[ -n $shell_candidate ]] && shell_paths+=("$shell_candidate")
    done < <(command -v bash 2>/dev/null)
    while IFS= read -r shell_candidate; do
      [[ -n $shell_candidate ]] && shell_paths+=("$shell_candidate")
    done < <(command -v zsh 2>/dev/null)
  fi

  local new_shell=""
  for shell_path in "${shell_paths[@]}"; do
    [[ -x $shell_path ]] || continue
    new_shell="$shell_path"
    if ((DRY_RUN)); then
      logg -i "[dry-run] ensure $shell_path listed in /etc/shells"
    else
      grep -qxF "$shell_path" /etc/shells || echo "$shell_path" | sudo tee -a /etc/shells >/dev/null
    fi
  done

  if [[ -n $new_shell ]]; then
    if ((DRY_RUN)); then
      logg -i "[dry-run] chsh -s $new_shell"
    else
      chsh -s "$new_shell" || logg -w "Failed to change default shell."
    fi
    logg -i "SHELL=$new_shell"
  else
    logg -w 'No shell candidates found to set as default.'
  fi
}

# Configure desktop integrations like Hammerspoon
# Usage: configure_desktop_integration
configure_desktop_integration() {
  if [[ $OS_TYPE == macos ]]; then
    if ((DRY_RUN)); then
      logg -i "[dry-run] defaults write org.hammerspoon.Hammerspoon MJConfigFile $XDG_CONFIG_HOME/hammerspoon/init.lua"
    else
      defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME/hammerspoon/init.lua"
      logg -i 'Configure System Settings > Privacy & Security > Accessibility for Hammerspoon.'
    fi
  else
    logg -w "Hammerspoon configuration skipped on $DISTRO. Configure your window manager manually."
  fi
}

# Install optional Linux-only CLI dependencies
# Usage: install_linux_optional_tools
install_linux_optional_tools() {
  [[ $OS_TYPE == linux ]] || return

  notify -s 'Install optional CLI tooling'

  if command -v atuin &>/dev/null; then
    logg -i 'Atuin already installed.'
  else
    local atuin_cmd="curl --proto '=https' --tlsv1.2 -sSf https://repo.atuin.sh/install.sh | bash"
    if ((DRY_RUN)); then
      logg -i "[dry-run] $atuin_cmd"
    else
      run "$atuin_cmd"
    fi
  fi

  if command -v op &>/dev/null; then
    logg -i '1Password CLI already installed.'
  else
    local key_cmd='curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor -o /usr/share/keyrings/1password-archive-keyring.gpg'
    local repo_cmd="printf '%s\n' 'deb [signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list >/dev/null"
    if ((DRY_RUN)); then
      logg -i "[dry-run] $key_cmd"
      logg -i "[dry-run] $repo_cmd"
      logg -i '[dry-run] sudo apt update'
      logg -i '[dry-run] sudo apt install -y 1password-cli'
    else
      run "$key_cmd"
      run "$repo_cmd"
      run 'sudo apt update'
      run 'sudo apt install -y 1password-cli'
    fi
  fi

  if command -v bob &>/dev/null; then
    logg -i 'bob already installed.'
  else
    if command -v cargo &>/dev/null; then
      if ((DRY_RUN)); then
        logg -i '[dry-run] cargo install bob-nvim'
      else
        run 'cargo install bob-nvim'
      fi
    else
      logg -w 'Rust toolchain (cargo) not found; skipping bob installation.'
    fi
  fi

  if command -v uv &>/dev/null; then
    logg -i 'uv already installed.'
  else
    local uv_cmd='curl -Ls https://astral.sh/uv/install.sh | sh'
    if ((DRY_RUN)); then
      logg -i "[dry-run] $uv_cmd"
    else
      run "$uv_cmd"
    fi
  fi
}

# Install and configure Neovim tooling via bob and uv
# Usage: setup_neovim
setup_neovim() {
  if command -v bob &>/dev/null; then
    if ((DRY_RUN)); then
      logg -i '[dry-run] bob install stable && bob install nightly && bob use nightly'
    else
      bob install stable
      bob install nightly
      bob use nightly
    fi
  else
    logg -w 'bob not installed; skipping Neovim version management.'
  fi

  if command -v uv &>/dev/null; then
    if ((DRY_RUN)); then
      logg -i '[dry-run] uv tool install basedpyright'
      logg -i '[dry-run] uv tool install ruff'
    else
      uv tool install basedpyright
      uv tool install ruff
    fi
  else
    logg -w 'uv not installed; skipping LSP tool installs.'
  fi
}

# Keep sudo credentials fresh for long-running operations.
# Usage: authorize
authorize() {
  ((DRY_RUN)) && return
  command -v sudo &>/dev/null || return

  if ! sudo -v; then
    logg -w 'Unable to refresh sudo credentials; privileged steps may prompt for password.'
    return
  fi

  {
    while true; do
      sleep 60
      sudo -n true || break
    done
  } &

  KEEP_SUDO_PID=$!
  trap '[[ -n ${KEEP_SUDO_PID:-} ]] && kill "$KEEP_SUDO_PID" 2>/dev/null' EXIT
}

# Ensure macOS CLT installed and export XDG directories
# Usage: export-xdg
export-xdg() {
  [[ $OS_TYPE == macos ]] &&
    ! command -v xcode-select &>/dev/null &&
    logg -e 'Please install Xcode Command Line Tools: xcode-select --install' &&
    exit 1

  export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
  export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
  export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
  export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
}

# Enable 1Password integrations when the CLI is available
# Usage: use_op
use_op() {
  local op_available=0
  command -v op &>/dev/null && op_available=1

  USE_1PASSWORD=$FORCE_1PASSWORD
  ((!USE_1PASSWORD && op_available)) && confirm 'Enable 1Password CLI integrations' 'Y' && USE_1PASSWORD=1
  ((USE_1PASSWORD && !op_available)) && logg -w '1Password CLI not detected. Skipping related steps.' && USE_1PASSWORD=0
}

# Orchestrate bootstrap workflow and CLI options
# Usage: main "$@"
main() {
  # Parse CLI flags for dry-run, optional 1Password integration, and help output
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -p | --with-1password) FORCE_1PASSWORD=1 ;;
    -n | --dry-run) DRY_RUN=1 ;;
    -h | --help)
      cat <<'HELP'
Usage: bootstrap.sh [-p] [-n] [-h]
  -p, --with-1password     Enable 1Password integration (requires op CLI)
  -n, --dry-run            Print actions instead of executing them
  -h, --help               Show this message
HELP
      exit 0
      ;;
    *) logg -e "Unknown option: $1" && exit 1 ;;
    esac

    shift
  done

  notify 'BEGIN BOOTSTRAP DEVELOPMENT SCRIPT'

  notify 'CREATE XDG ENV VARS & DETECT OS'
  export-xdg
  detect_platform

  notify 'AUTHORIZE & DETECT 1PASSWORD'
  authorize
  use_op

  notify 'INSTALL COMMANDS & APPS'
  setup_package_manager
  install_package_sets

  notify 'SET ENVIRONMENT'
  collect_environment

  notify 'CREATE SYMLINKS & DIRECTORIES'
  create_symlinks

  notify 'CONFIGURE OS OPTIONS'
  configure_macos_defaults

  notify 'CONFIGURE GIT AND GITHUB CLI'
  configure_git_and_github

  notify 'INSTALL TEMPLATES'
  install_templates

  notify 'INSTALL SHELL PLUGINS'
  install_shell_plugins

  notify 'SETUP ATUIN SYNC'
  setup_atuin_sync

  notify 'LOAD BAT THEMES'
  rebuild_bat_cache

  notify 'SETUP SUDO AUTH'
  configure_sudo_auth

  notify 'SUPPRESS LOGIN BANNER'
  suppress_login_banner

  notify 'CHANGE SHELL'
  change_shell_default

  notify 'DESKTOP INTEGRATION'
  configure_desktop_integration

  notify 'SETUP NEOVIM'
  setup_neovim

  # Exit confirmation messages
  printf '\n%s\n' "${CYAN}BOOTSTRAP COMPLETE - HAPPY DEVELOPING!...${RESET}"
  logg -w 'RESTART YOUR TERMINAL WINDOW TO LOAD THE NEW CONFIGURATION'
  echo
}

main "$@"
