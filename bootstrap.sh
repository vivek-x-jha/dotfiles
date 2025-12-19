#!/usr/bin/env bash

clear

# -------------------------------------- COLORS + ICON -------------------------------------

# BLACK=$'\e[0;30m'
# RED=$'\e[0;31m'
GREEN=$'\e[0;32m'
YELLOW=$'\e[0;33m'
# BLUE=$'\e[0;34m'
MAGENTA=$'\e[0;35m'
CYAN=$'\e[0;36m'
WHITE=$'\e[0;37m'

RESET=$'\e[0m'
ICON='󰓒'

# -------------------------------------- GLOBALS & DEFAULTS -------------------------------------

STEP=0
SUBSTEP=0
TOTAL_STEPS=19

DRY_RUN=0

USE_1PASSWORD=0
FORCE_1PASSWORD=0
KEEP_SUDO_PID=''

OS_TYPE=''
DISTRO=''
PKG_MGR=''

GITHUB_RAW_BASE='https://raw.githubusercontent.com/vivek-x-jha/dotfiles/refs/heads/main'
BREWFILE_DEFAULT="$GITHUB_RAW_BASE/manifests/Brewfile"
APT_MANIFEST_DEFAULT="$HOME/.dotfiles/manifests/apt-packages.txt"
DNF_MANIFEST_DEFAULT="$HOME/.dotfiles/manifests/dnf-packages.txt"
APT_MANIFEST_URL_DEFAULT="$GITHUB_RAW_BASE/manifests/apt-packages.txt"
DNF_MANIFEST_URL_DEFAULT="$GITHUB_RAW_BASE/manifests/dnf-packages.txt"
DNF_CMD=''

DEVELOPER_REPOS=(
  vivek-x-jha/dcp
  vivek-x-jha/notes
  vivek-x-jha/nvim-dashboard
  vivek-x-jha/neovim-macos-launcher
  vivek-x-jha/nvim-sourdiesel
  vivek-x-jha/nvim-statusline
  vivek-x-jha/nvim-terminal
)

# -------------------------------------- HELPER FUNCTIONS -------------------------------------

# [HF1] print standardized and colorized log messages
# Usage: logg -i | -w | -e "message"
logg() {
  local opt="$1"
  local level=''
  local color=''

  case "$opt" in
  -i) level=INFO ;;
  -w)
    level=WARN
    color="$YELLOW"
    ;;
  -e)
    level=ERROR
    color="$MAGENTA"
    ;;
  *)
    printf 'logg: missing or invalid level flag\n' >&2
    return 1
    ;;
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

# [HF4] Ensure a command exists, warn generically, and return non-zero otherwise
# Usage: require git
require() {
  local bin="$1"

  command -v "$bin" &>/dev/null || {
    logg -w "$bin unavailable or not in PATH. Skipping..."
    return 1
  }
}

# [HF5] Convert paths under $HOME into a tilde-prefixed display string
# Usage: pretty_path "/Users/me/.config"
pretty_path() {
  local path="$1"

  [[ $path == "$HOME"* ]] && printf '~%s' "${path#"$HOME"}" && return
  printf '%s' "$path"
}

# [HF6] ask a yes/no question with optional default
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

# [HF6] fetch secret field from 1Password when available
# Usage: get_op_field <item> <field>
get_op_field() {
  local item="$1"
  local field="$2"
  local value=''

  ((USE_1PASSWORD)) || return 1
  ((DRY_RUN)) && printf '<dry-run:%s>\n' "$field" && return

  value=$(op item get "$item" \
    --vault "$OP_VAULT" \
    --field "$field" \
    --reveal 2>/dev/null) || return 1

  printf '%s' "$value"
}

# Determine OS and package-manager defaults
detect_platform() {
  case "$(uname -s)" in
  Darwin)
    # Ensure xcode installed for macOS
    require xcode-select || exit 1

    DISTRO=macOS
    OS_TYPE=macos
    PKG_MGR=brew
    ;;

  Linux)
    # Ensure os-release available
    # shellcheck disable=SC1091
    source /etc/os-release 2>/dev/null || {
      logg -e 'Unable to detect Linux distribution (missing /etc/os-release).'
      exit 1
    }

    DISTRO="${PRETTY_NAME:-${NAME:-Linux}}"
    OS_TYPE=linux

    case "${ID_LIKE:-}$ID" in
    *debian* | *ubuntu*) PKG_MGR=apt ;;
    *fedora* | *rhel* | *centos*) PKG_MGR=dnf ;;
    *) logg -e "Linux distribution '$DISTRO' is not yet supported." && exit 1 ;;
    esac
    ;;

  *) logg -e "Unsupported operating system: $(uname -s)" && exit 1 ;;
  esac

  logg -i "TARGET PLATFORM: DISTRO=$DISTRO"
  logg -i "PACKAGE MANAGER: PKG_MGR=$PKG_MGR"
}

# Keep sudo credentials fresh for long-running operations.
authorize() {
  require sudo || return

  run 'sudo -v' || {
    logg -w 'Unable to refresh sudo credentials; privileged steps may prompt for password.'
    return
  }

  {
    while true; do
      sleep 60
      sudo -n true || break
    done
  } &

  KEEP_SUDO_PID=$!
  trap '[[ -n ${KEEP_SUDO_PID:-} ]] && kill "$KEEP_SUDO_PID" 2>/dev/null' EXIT
}

# Enable 1Password integrations when the CLI is available
use_op() {
  local op_available=0
  require op && op_available=1

  USE_1PASSWORD=$FORCE_1PASSWORD
  ((!USE_1PASSWORD && op_available)) && confirm 'Enable 1Password CLI integrations' 'Y' && USE_1PASSWORD=1
  ((USE_1PASSWORD && !op_available)) && logg -w '1Password CLI not detected. Skipping related steps.' && USE_1PASSWORD=0
}

# Ensure required package manager tooling is present
setup_package_manager() {
  [[ $PKG_MGR == brew ]] && {
    notify -s 'Ensuring Homebrew is available'

    local brew_cmd='/opt/homebrew/bin/brew'
    [[ $(uname -m) == x86_64 ]] && brew_cmd=/usr/local/bin/brew

    # run installer if homebrew executable not in $PATH
    [[ -x $brew_cmd ]] || {
      notify -s 'Installing Homebrew'
      run 'curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /bin/bash' 2>/dev/null
    }

    # Ensure homebrew is in $PATH for current shell session
    run "eval \"\$($brew_cmd shellenv)\"" || {
      logg -e 'Homebrew failed to install - please check install instructions @ https://brew.sh/'
      exit 1
    }
  }

  [[ $PKG_MGR == dnf ]] && {
    notify -s 'Ensuring dnf is available'

    local dnf_cmd=''
    dnf_cmd="$(command -v dnf 2>/dev/null)"
    [[ -z $dnf_cmd ]] && dnf_cmd="$(command -v dnf5 2>/dev/null)"

    require "$dnf_cmd" || exit 1
    DNF_CMD="$dnf_cmd"
  }

  [[ $PKG_MGR == apt ]] && {
    notify -s 'Ensuring apt is available'
    require apt-get || exit 1
  }
}

# Install brew/apt package manifests and optional updates
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
  elif [[ $PKG_MGR == dnf ]]; then
    local dnf_exec="${DNF_CMD:-$(command -v dnf 2>/dev/null || command -v dnf5 2>/dev/null)}"

    if [[ -z $dnf_exec ]]; then
      logg -e 'dnf command not found after initialization.'
      exit 1
    fi

    if confirm 'Upgrade Fedora packages' 'Y'; then
      notify -s 'Upgrading system packages'
      if ((DRY_RUN)); then
        logg -i "[dry-run] sudo $dnf_exec upgrade --refresh -y"
      else
        run "sudo $dnf_exec upgrade --refresh -y"
      fi
    fi

    local dnf_manifest="$DNF_MANIFEST_DEFAULT"
    local dnf_manifest_tmp=''

    if [[ ! -f $dnf_manifest && -n $DNF_MANIFEST_URL_DEFAULT ]]; then
      dnf_manifest_tmp="$(mktemp)"
      if ((DRY_RUN)); then
        logg -i "[dry-run] curl -fsL $DNF_MANIFEST_URL_DEFAULT -o $dnf_manifest_tmp"
      fi

      if curl -fsL "$DNF_MANIFEST_URL_DEFAULT" -o "$dnf_manifest_tmp" 2>/dev/null; then
        logg -i "Using remote dnf manifest: $DNF_MANIFEST_URL_DEFAULT"
        dnf_manifest="$dnf_manifest_tmp"
      else
        logg -w "Failed to fetch dnf manifest from $DNF_MANIFEST_URL_DEFAULT"
        rm -f "$dnf_manifest_tmp"
        dnf_manifest_tmp=''
      fi
    fi

    if [[ -f $dnf_manifest ]]; then
      if confirm "Install dnf packages from $(pretty_path "$dnf_manifest")" 'Y'; then
        notify -s 'Installing dnf packages'
        mapfile -t dnf_packages < <(grep -vE '^(#|\s*$)' "$dnf_manifest")
        if [[ ${#dnf_packages[@]} -gt 0 ]]; then
          if ((DRY_RUN)); then
            logg -i "[dry-run] sudo $dnf_exec install -y ${dnf_packages[*]}"
          else
            sudo "$dnf_exec" install -y "${dnf_packages[@]}"
          fi
        else
          logg -w "No packages listed in $(pretty_path "$dnf_manifest")"
        fi
      fi
    else
      logg -w "dnf manifest not found locally and no remote fallback available."
    fi

    if [[ -n $dnf_manifest_tmp && -f $dnf_manifest_tmp ]]; then
      rm -f "$dnf_manifest_tmp"
    fi

    install_linux_gui_apps

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

    local apt_manifest="$APT_MANIFEST_DEFAULT"
    local apt_manifest_tmp=''

    if [[ ! -f $apt_manifest && -n $APT_MANIFEST_URL_DEFAULT ]]; then
      apt_manifest_tmp="$(mktemp)"
      if ((DRY_RUN)); then
        logg -i "[dry-run] curl -fsL $APT_MANIFEST_URL_DEFAULT -o $apt_manifest_tmp"
      fi

      if curl -fsL "$APT_MANIFEST_URL_DEFAULT" -o "$apt_manifest_tmp" 2>/dev/null; then
        logg -i "Using remote apt manifest: $APT_MANIFEST_URL_DEFAULT"
        apt_manifest="$apt_manifest_tmp"
      else
        logg -w "Failed to fetch apt manifest from $APT_MANIFEST_URL_DEFAULT"
        rm -f "$apt_manifest_tmp"
        apt_manifest_tmp=''
      fi
    fi

    if [[ -f $apt_manifest ]]; then
      if confirm "Install apt packages from $(pretty_path "$apt_manifest")" 'Y'; then
        notify -s 'Installing apt packages'
        mapfile -t apt_packages < <(grep -vE '^(#|\s*$)' "$apt_manifest")
        if [[ ${#apt_packages[@]} -gt 0 ]]; then
          if ((DRY_RUN)); then
            logg -i "[dry-run] sudo apt install -y ${apt_packages[*]}"
          else
            sudo apt install -y "${apt_packages[@]}"
          fi
        else
          logg -w "No packages listed in $(pretty_path "$apt_manifest")"
        fi
      fi
    else
      logg -w "apt manifest not found locally and no remote fallback available."
    fi

    if [[ -n $apt_manifest_tmp && -f $apt_manifest_tmp ]]; then
      rm -f "$apt_manifest_tmp"
    fi

    # Install 1Password CLI on Linux (apt-based)
    notify -s 'Install 1Password CLI'
    require op || {
      # Import signing key, add repo, then install
      run "curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor -o /usr/share/keyrings/1password-archive-keyring.gpg"

      run "printf '%s\n' 'deb [signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list >/dev/null"

      run 'sudo apt update'
      run 'sudo apt install -y 1password-cli'
    }

    install_linux_gui_apps
  fi
}

# Fetch a secret field from 1Password if enabled

# Collect environment preferences and prompt for 1Password data
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

# Link dotfiles into their XDG targets and optional media directory.
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
    ../../../.dotfiles/btop/btop.log "$XDG_STATE_HOME/btop" btop.log
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
    local base="${symlinks[i + 1]}"
    local target="${symlinks[i + 2]}"

    # Ensure required args are present
    [[ -n $src && -n $base && -n $target ]] || {
      logg -e 'Missing required arg(s): Usage: symlink <source> <base_dir> <link_name>'
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

    # Backup target directory
    [[ -d $target && ! -L $target ]] && mv -f "$target" "${target}.bak"

    # Create symlink (respects DRY_RUN via run)
    run "ln -sf \"$src\" \"$target\"" && logg -i "[+ Link: $src -> $base/$target]"
    popd >/dev/null || true
  done
}

# Apply preferred macOS UI defaults
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

# Configure git/user settings and GitHub CLI defaults
configure_git_and_github() {
  run "git config --global user.name \"$GIT_NAME\""
  run "git config --global user.email \"$GIT_EMAIL\""
  [[ -n $GIT_SIGNINGKEY ]] && run "git config --global user.signingkey \"$GIT_SIGNINGKEY\""

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

# Clone curated developer repositories under the user's workspace
clone_developer_repos() {
  require git || return

  local base="$HOME/Developer"
  mkdir -p "$base"

  local slug repo_name url dest
  local sorted_slugs=()
  while IFS= read -r slug; do
    sorted_slugs+=("$slug")
  done < <(printf '%s\n' "${DEVELOPER_REPOS[@]}" | sort)

  for slug in "${sorted_slugs[@]}"; do
    repo_name="${slug##*/}"
    url="git@github.com:${slug}.git"
    dest="$base/$repo_name"

    if [[ -d $dest/.git ]]; then
      logg -i "$repo_name already present; ensuring SSH remote."
      if ((DRY_RUN)); then
        logg -i "[dry-run] git -C $dest remote set-url origin $url"
      else
        if ! git -C "$dest" remote set-url origin "$url" 2>/dev/null; then
          git -C "$dest" remote add origin "$url" 2>/dev/null || logg -w "Failed to configure origin for $repo_name."
        fi
      fi
      continue
    fi

    if [[ -e $dest ]]; then
      local pretty_dest
      pretty_dest="$(pretty_path "$dest")"
      logg -w "Skipping $repo_name - $pretty_dest exists but is not a git repository."
      continue
    fi

    if ((DRY_RUN)); then
      logg -i "[dry-run] git clone $url $dest"
    else
      git clone "$url" "$dest" || logg -w "Failed to clone $repo_name from $url."
    fi
  done
}

# Clone or update project template repository
install_templates() {
  require git || return

  local templates_remote='git@github.com:vivek-x-jha/templates.git'
  local templates_dir="$XDG_DATA_HOME/templates"
  local templates_backup="${templates_dir}.bak"

  # Backup existing templates directory
  [[ -d $templates_dir ]] && {
    [[ -d $templates_backup ]] && run "rm -rf \"$templates_backup\""

    run "cp -a \"$templates_dir\" \"$templates_backup\"" || {
      logg -w 'Failed to backup existing templates directory.'
      return
    }

    run "rm -rf \"$templates_dir\""
  }

  # Download templates repo
  run "git clone \"$templates_remote\" \"$templates_dir\"" || logg -w 'Cloning templates failed - please check GitHub repo exists'
}

# Provision Atuin sync credentials via 1Password
setup_atuin_sync() {
  # Skip Atuin 1Password setup when either command unavailable
  require atuin || return
  require op || return
  ! ((USE_1PASSWORD)) && logg -w '1Password disabled. Skipping Atuin vault automation.' && return

  local atuin_op="${ATUIN_OP_TITLE} --vault ${OP_VAULT}"

  # Ensure Atuin Sync 1Password login exists with password generated
  run "op item get \"$atuin_op\" >/dev/null || op item create \
    --title \"$atuin_op\" \
    --category login \
    --generate-password='letters,digits,symbols,32' \
    username=\"$ATUIN_USERNAME\" \
    email[text]=\"$ATUIN_EMAIL\" \
    key[password]='<Update with \$(atuin key)>' >/dev/null"

  # Retreive Atuin Sync password
  local atuin_password=''
  atuin_password="$(get_op_field "$ATUIN_OP_TITLE" password)"
  [[ -z $atuin_password ]] && logg -w 'Failed to fetch Atuin password from 1Password. Skipping sync.' && return

  # Register Atuin credentials obtained from 1Password - if already exists is idempotent
  run "atuin register \
    -u \"$ATUIN_USERNAME\" \
    -e \"$ATUIN_EMAIL\" \
    -p \"$atuin_password\" || true"

  # Update Atuin Sync 1Password with generated key
  run "op item edit \"$atuin_op\" key=\"$(atuin key)\" >/dev/null"

  # Retrieve freshly updated Atuin sync key
  local atuin_key=''
  atuin_key="$(get_op_field "$ATUIN_OP_TITLE" key)"
  [[ -z $atuin_key ]] && logg -w 'Failed to retrieve Atuin sync key from 1Password. Skipping login refresh.' && return

  # Ensure Atuin session logged in using 1Password-managed credentials
  run "atuin status | grep -q \"$ATUIN_USERNAME\" || ( \
    atuin logout && atuin login \
    -u \"$ATUIN_USERNAME\" \
    -p \"$atuin_password\" \
    -k \"$atuin_key\" ) &>/dev/null"

  # Sync Atuin history with existing commands in server
  run 'atuin import auto'
  run 'atuin sync'
}

# Configure Touch ID-backed sudo when supported
configure_sudo_auth() {
  require brew || return

  local brew_prefix='' pam_content=''
  brew_prefix=$(brew --prefix)

  pam_content=$(
    cat <<EOF
# Authenticate with Touch ID - even in tmux
auth  optional    $brew_prefix/lib/pam/pam_reattach.so ignore_ssh
auth  sufficient  pam_tid.so
EOF
  )

  run "printf '%s\n' \"$pam_content\" | sudo tee /etc/pam.d/sudo_local >/dev/null" &&
    logg -i 'UPDATED /etc/pam.d/sudo_local'
}

# Ensure preferred shell binaries are registered and set as default
change_shell_default() {
  local shell_paths=()

  if [[ $OS_TYPE == macos ]] && require brew; then
    shell_paths=("$(brew --prefix)/bin/bash" "$(brew --prefix)/bin/zsh")
  else

    while IFS= read -r shell_candidate; do
      [[ -n $shell_candidate ]] && shell_paths+=("$shell_candidate")
    done < <(command -v bash 2>/dev/null)
    while IFS= read -r shell_candidate; do
      [[ -n $shell_candidate ]] && shell_paths+=("$shell_candidate")
    done < <(command -v zsh 2>/dev/null)
  fi

  local new_shell=''
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
    run "chsh -s \"$new_shell\"" || logg -w "Failed to change default shell."
    logg -i "SHELL=$new_shell"
  else
    logg -w 'No shell candidates found to set as default.'
  fi
}

# Move hammerspoon entry point to $XDG_CONFIG_HOME
configure_hammerspoon() {
  run "defaults write org.hammerspoon.Hammerspoon MJConfigFile \"$XDG_CONFIG_HOME/hammerspoon/init.lua\" 2>/dev/null" || {
    logg -w "Hammerspoon configuration skipped on $DISTRO. Configure your window manager manually."
    return
  }

  logg -i 'Configure System Settings > Privacy & Security > Accessibility for Hammerspoon.'
}

# Install GUI applications recommended for Linux setups
install_linux_gui_apps() {
  [[ $OS_TYPE == linux ]] || return

  confirm 'Install recommended Linux GUI applications (Chrome, Slack, Spotify, etc.)' 'N' || {
    logg -w 'Skipping Linux GUI application installs.'
    return
  }

  notify -s 'Installing Linux GUI applications'

  [[ $PKG_MGR == apt ]] && install_linux_gui_apps_apt && return
  [[ $PKG_MGR == dnf ]] && install_linux_gui_apps_dnf && return

  logg -w "No GUI installer defined for package manager: $PKG_MGR"
}

# Install GUI tooling on Debian/Ubuntu systems
install_linux_gui_apps_apt() {
  local download_dir="$HOME/Downloads/linux-gui"
  local apt_update_needed=0

  run "mkdir -p \"$download_dir\""

  local onepassword_key='/usr/share/keyrings/1password-archive-keyring.gpg'
  local onepassword_list='/etc/apt/sources.list.d/1password.list'

  if [[ ! -f $onepassword_key ]]; then
    run "curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor -o \"$onepassword_key\""
    apt_update_needed=1
  fi

  if [[ ! -f $onepassword_list ]]; then
    run "sudo tee \"$onepassword_list\" >/dev/null <<EOF
deb [signed-by=$onepassword_key] https://downloads.1password.com/linux/debian/amd64 stable main
EOF"
    apt_update_needed=1
  fi

  local spotify_key='/usr/share/keyrings/spotify.gpg'
  local spotify_list='/etc/apt/sources.list.d/spotify.list'

  if [[ ! -f $spotify_key ]]; then
    run "curl -fsSL https://download.spotify.com/debian/pubkey.gpg | sudo gpg --dearmor -o \"$spotify_key\""
    apt_update_needed=1
  fi

  if [[ ! -f $spotify_list ]]; then
    run "sudo tee \"$spotify_list\" >/dev/null <<EOF
deb [signed-by=$spotify_key] http://repository.spotify.com stable non-free
EOF"
    apt_update_needed=1
  fi

  local ms_key='/usr/share/keyrings/ms.gpg'
  local ms_list='/etc/apt/sources.list.d/vscode.list'

  if [[ ! -f $ms_key ]]; then
    run "curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee \"$ms_key\" >/dev/null"
    apt_update_needed=1
  fi

  if [[ ! -f $ms_list ]]; then
    run "sudo tee \"$ms_list\" >/dev/null <<EOF
deb [arch=amd64 signed-by=$ms_key] https://packages.microsoft.com/repos/code stable main
EOF"
    apt_update_needed=1
  fi

  if ((apt_update_needed)); then run 'sudo apt update'; fi

  local -a apt_packages=()

  if ! dpkg -s 1password &>/dev/null; then apt_packages+=(1password); fi
  if ! dpkg -s anki &>/dev/null && ! command -v anki &>/dev/null; then apt_packages+=(anki); fi
  if ! dpkg -s nautilus-dropbox &>/dev/null; then apt_packages+=(nautilus-dropbox); fi
  if ! dpkg -s spotify-client &>/dev/null && ! command -v spotify &>/dev/null; then apt_packages+=(spotify-client); fi
  if ! dpkg -s code &>/dev/null && ! command -v code &>/dev/null; then apt_packages+=(code); fi
  if ! dpkg -s vlc &>/dev/null && ! command -v vlc &>/dev/null; then apt_packages+=(vlc); fi

  if [[ ${#apt_packages[@]} -gt 0 ]]; then
    run "sudo apt install -y ${apt_packages[*]}"
  else
    logg -i 'Apt-based GUI packages already present.'
  fi

  install_deb_package() {
    local pkg="$1"
    local url="$2"
    local label="$3"
    local filename="$4"
    local dest="$download_dir/${filename:-$pkg}.deb"

    if dpkg -s "$pkg" &>/dev/null; then
      logg -i "$label already installed."
      return
    fi

    logg -i "Downloading $label installer."
    run "curl -L \"$url\" -o \"$dest\""
    run "sudo apt install -y \"$dest\""
  }

  install_deb_package google-chrome-stable 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb' 'Google Chrome'
  install_deb_package slack-desktop 'https://downloads.slack-edge.com/desktop-releases/linux/x64/latest/slack-desktop-latest-amd64.deb' 'Slack'
  install_deb_package discord 'https://discord.com/api/download?platform=linux&format=deb' 'Discord'

  if ! command -v postman &>/dev/null; then
    if command -v flatpak &>/dev/null; then
      run 'flatpak install -y flathub com.getpostman.Postman'
    else
      logg -w 'Flatpak not available; skipping Postman installation. See gui-apps-linux.md for manual steps.'
    fi
  fi

  if ! command -v wezterm &>/dev/null; then
    if command -v flatpak &>/dev/null; then
      run 'flatpak install -y flathub org.wezfurlong.wezterm'
    else
      logg -w 'WezTerm missing and Flatpak unavailable. Download from https://github.com/wez/wezterm/releases.'
    fi
  fi

  if ! command -v thinkorswim &>/dev/null; then
    logg -w 'Thinkorswim requires the vendor installer (see gui-apps-linux.md). Skipping automated install.'
  fi
}

# Install GUI tooling on Fedora/RHEL systems
install_linux_gui_apps_dnf() {
  local download_dir="$HOME/Downloads/linux-gui"
  local dnf_refresh_needed=0

  run "mkdir -p \"$download_dir\""

  local rpmfusion_free='/etc/yum.repos.d/rpmfusion-free.repo'
  local rpmfusion_nonfree='/etc/yum.repos.d/rpmfusion-nonfree.repo'

  if [[ ! -f $rpmfusion_free ]]; then
    run "sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    dnf_refresh_needed=1
  fi

  if [[ ! -f $rpmfusion_nonfree ]]; then
    run "sudo dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    dnf_refresh_needed=1
  fi

  local onepassword_repo='/etc/yum.repos.d/1password.repo'
  if [[ ! -f $onepassword_repo ]]; then
    run 'sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc'
    run "sudo tee \"$onepassword_repo\" >/dev/null <<'EOF'
[1password]
name=1Password
baseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch
enabled=1
gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
EOF"
    dnf_refresh_needed=1
  fi

  local vscode_repo='/etc/yum.repos.d/vscode.repo'
  if [[ ! -f $vscode_repo ]]; then
    run 'sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc'
    run "sudo tee \"$vscode_repo\" >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF"
    dnf_refresh_needed=1
  fi

  local copr_repo='/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:wez:wezterm.repo'
  if [[ ! -f $copr_repo ]]; then
    run 'sudo dnf -y copr enable wez/wezterm'
    dnf_refresh_needed=1
  fi

  ((dnf_refresh_needed)) && run 'sudo dnf makecache'

  local -a dnf_packages=()

  if ! rpm -q 1password &>/dev/null; then dnf_packages+=(1password); fi
  if ! rpm -q anki &>/dev/null && ! command -v anki &>/dev/null; then dnf_packages+=(anki); fi
  if ! rpm -q nautilus-dropbox &>/dev/null; then dnf_packages+=(nautilus-dropbox); fi
  if ! rpm -q code &>/dev/null && ! command -v code &>/dev/null; then dnf_packages+=(code); fi
  if ! rpm -q vlc &>/dev/null && ! command -v vlc &>/dev/null; then dnf_packages+=(vlc); fi
  if ! rpm -q wezterm &>/dev/null && ! command -v wezterm &>/dev/null; then dnf_packages+=(wezterm); fi

  if [[ ${#dnf_packages[@]} -gt 0 ]]; then
    run "sudo dnf install -y ${dnf_packages[*]}"
  else
    logg -i 'DNF-based GUI packages already present.'
  fi

  install_rpm_package() {
    local pkg="$1"
    local url="$2"
    local label="$3"
    local filename="$4"
    local dest="$download_dir/${filename:-$pkg}.rpm"

    if rpm -q "$pkg" &>/dev/null; then
      logg -i "$label already installed."
      return
    fi

    logg -i "Downloading $label installer."
    run "curl -L \"$url\" -o \"$dest\""
    run "sudo dnf install -y \"$dest\""
  }

  install_rpm_package google-chrome-stable 'https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm' 'Google Chrome'
  install_rpm_package slack 'https://downloads.slack-edge.com/desktop-releases/linux/x64/latest/slack-desktop-latest-x86_64.rpm' 'Slack' 'slack-desktop'
  install_rpm_package discord 'https://discord.com/api/download?platform=linux&format=rpm' 'Discord'

  if ! command -v spotify &>/dev/null; then
    if command -v flatpak &>/dev/null; then
      run 'flatpak install -y flathub com.spotify.Client'
    else
      logg -w 'Flatpak not available; skipping Spotify installation. See gui-apps-linux.md for manual steps.'
    fi
  fi

  if ! command -v postman &>/dev/null; then
    if command -v flatpak &>/dev/null; then
      run 'flatpak install -y flathub com.getpostman.Postman'
    else
      logg -w 'Flatpak not available; skipping Postman installation. See gui-apps-linux.md for manual steps.'
    fi
  fi

  if ! command -v thinkorswim &>/dev/null; then
    logg -w 'Thinkorswim requires the vendor shell installer. Download from TD Ameritrade manually.'
  fi
}

# Install Rust toolchain manager, LSP, and cargo managed CLI utilities
install_rust_tooling() {
  export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
  export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"
  export PATH="$CARGO_HOME/bin:$PATH"

  # Install toolchain manager + pkg manager
  require rustup || run "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path"

  # Ensure toolchain manager + pkg manager installed properly
  require rustup || return
  require cargo || return

  # Install language server
  run 'rustup component add rust-analyzer' || logg -w 'rust-analyzer component not installed'

  # Cargo managed packages
  local crates=(
    atuin
    bat
    bob-nvim
    dust
    eza
    fd-find
    rainfrog
    ripgrep
    starship
    stylua
    tealdeer
    tokei
    uv
    yazi-fm
    zoxide
  )

  # Install all packages
  for crate in "${crates[@]}"; do
    run "cargo install --locked $crate" || logg -w "cargo install failed for $crate"
  done
}

# Install and configure ide tools
setup_ide() {
  # Install and configure Neovim version manager
  require bob || return

  # Install current stable + nightly Neovim builds
  run 'bob install stable'
  run 'bob install nightly'
  run 'bob use nightly'

  require nvim || return

  # Install Python tools
  require uv && {
    run 'uv tool install basedpyright'
    require basedpyright

    run 'uv tool install ruff'
    require ruff
  }
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
  export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
  export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
  export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
  export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

  notify 'SET UNIX DISTRO + PACKAGE MANAGER'
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

  notify 'CLONE DEVELOPER REPOS'
  clone_developer_repos

  notify 'INSTALL TEMPLATES'
  install_templates

  notify 'INSTALL SHELL PLUGIN MANAGERS'
  notify -s 'Install zap'
  [[ -f $XDG_DATA_HOME/zap/zap.zsh ]] || run 'zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 -k'

  notify -s 'Install ble.sh'
  run 'git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git'
  run "make -C ble.sh install PREFIX=\"$HOME/.local\"" 2>/dev/null || logg -w 'Failed to install ble.sh'
  run 'rm -rf ble.sh'

  notify 'SETUP ATUIN SYNC'
  setup_atuin_sync

  notify 'LOAD BAT THEMES'
  run 'bat cache --build 2>/dev/null' || logg -w 'bat not available - skipping cache rebuild.'

  notify 'SETUP SUDO AUTH'
  configure_sudo_auth

  notify 'SUPPRESS LOGIN BANNER'
  run 'touch ~/.hushlogin' && logg -i 'Ensured ~/.hushlogin exists'

  notify 'CHANGE SHELL'
  change_shell_default

  notify 'DESKTOP INTEGRATION'
  configure_hammerspoon

  notify 'INSTALL RUST TOOLING'
  install_rust_tooling

  notify 'SETUP IDE TOOLS'
  setup_ide

  # Exit confirmation messages
  printf '\n%s\n' "${CYAN}BOOTSTRAP COMPLETE - HAPPY DEVELOPING!...${RESET}"
  logg -w 'RESTART YOUR TERMINAL WINDOW TO LOAD THE NEW CONFIGURATION'
  echo
}

main "$@"
