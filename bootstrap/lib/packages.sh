# shellcheck shell=bash
# shellcheck disable=SC2034
prepare_brewfile_install_file() {
  local brewfile="$1"
  local casks=()
  local cask=''
  local cask_mode=''
  local token=''
  local selected_tokens=''
  local selected_name=''
  local skip_names=''
  local keep_names=''
  local matched=0
  local skipped=0
  local idx=0

  BREWFILE_INSTALL_PATH="$brewfile"
  BREWFILE_SOURCE_TEMP=''
  BREWFILE_SELECTED_TEMP=''

  if [[ $brewfile =~ ^https?:// ]]; then
    BREWFILE_SOURCE_TEMP="$(mktemp)"
    if ((DRY_RUN)); then
      logg -i "[dry-run] curl -fsSL \"$brewfile\" -o \"$BREWFILE_SOURCE_TEMP\""
      BREWFILE_INSTALL_PATH="$brewfile"
      BREWFILE_SOURCE_TEMP=''
      logg -w 'Cask customization is skipped for remote Brewfiles during dry-run.'
      return 0
    fi

    curl -fsSL "$brewfile" -o "$BREWFILE_SOURCE_TEMP" || {
      logg -w "Unable to download Brewfile: $brewfile"
      return 1
    }
    BREWFILE_INSTALL_PATH="$BREWFILE_SOURCE_TEMP"
  fi

  while IFS= read -r cask; do
    casks+=("$cask")
  done < <(sed -n 's/^[[:space:]]*cask[[:space:]]*"\([^"]*\)".*/\1/p' "$BREWFILE_INSTALL_PATH")

  ((${#casks[@]})) || return 0

  cask_mode="${BOOTSTRAP_BREW_CASK_MODE:-all}"
  selected_tokens="${BOOTSTRAP_BREW_CASKS:-${BOOTSTRAP_BREW_SKIP_CASKS:-}}"
  [[ -n ${BOOTSTRAP_BREW_SKIP_CASKS:-} && -z ${BOOTSTRAP_BREW_CASKS:-} ]] && cask_mode=skip

  if [[ $cask_mode == all && -z $selected_tokens ]]; then
    bootstrap_config_bool BOOTSTRAP_INTERACTIVE 0 || return 0
    confirm 'Customize casks before install' 'N' || return 0
    cask_mode=skip

    logg -i 'Available Brewfile casks:'
    for idx in "${!casks[@]}"; do
      printf '  %2d. %s\n' "$((idx + 1))" "${casks[$idx]}"
    done

    read -rp '>>> Enter casks to skip (names or numbers, comma/space separated; <Enter> for none): ' selected_tokens
  fi
  [[ $cask_mode == all || -z $selected_tokens ]] && return 0
  [[ $cask_mode == skip || $cask_mode == only ]] || {
    logg -w "Unknown Homebrew cask mode '$cask_mode'; expected all, skip, or only. Installing all casks."
    return 0
  }

  for token in $(printf '%s' "$selected_tokens" | tr ',' ' '); do
    selected_name=''
    if [[ $token =~ ^[0-9]+$ ]]; then
      idx=$((10#$token))
      if ((idx >= 1 && idx <= ${#casks[@]})); then
        selected_name="${casks[$((idx - 1))]}"
      fi
    else
      for cask in "${casks[@]}"; do
        [[ $token == "$cask" ]] && selected_name="$cask" && break
      done
    fi

    if [[ -n $selected_name ]]; then
      keep_names="${keep_names}${keep_names:+ }$selected_name"
      matched=$((matched + 1))
    else
      logg -w "Ignoring unknown cask selection: $token"
    fi
  done

  ((matched)) || return 0

  if [[ $cask_mode == skip ]]; then
    skip_names="$keep_names"
  else
    for cask in "${casks[@]}"; do
      [[ " $keep_names " == *" $cask "* ]] && continue
      skip_names="${skip_names}${skip_names:+ }$cask"
      skipped=$((skipped + 1))
    done
  fi

  [[ $cask_mode == skip ]] && skipped=$matched
  ((skipped)) || return 0

  BREWFILE_SELECTED_TEMP="$(mktemp)"
  awk -v skip="$skip_names" '
    BEGIN {
      n = split(skip, selected, " ")
      for (i = 1; i <= n; i++) skipped[selected[i]] = 1
    }
    {
      name = $0
      if (name ~ /^[[:space:]]*cask[[:space:]]+"/) {
        sub(/^[[:space:]]*cask[[:space:]]+"/, "", name)
        sub(/".*/, "", name)
        if (name in skipped) next
      }
      print
    }
  ' "$BREWFILE_INSTALL_PATH" >"$BREWFILE_SELECTED_TEMP"

  BREWFILE_INSTALL_PATH="$BREWFILE_SELECTED_TEMP"
  if [[ $cask_mode == only ]]; then
    logg -i "Installing only selected cask(s): $keep_names"
  fi
  logg -i "Skipping $skipped cask(s): $skip_names"
}

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

install_package_sets() {
  if [[ $PKG_MGR == brew ]]; then
    if confirm_config BOOTSTRAP_INSTALL_PACKAGES 'Install packages & apps from Brewfile' 'Y'; then
      notify -s 'Select Brewfile'
      local brewfile
      local brewfile_input=''
      local install_brewfile
      brewfile="${BOOTSTRAP_BREWFILE:-$BREWFILE_DEFAULT}"
      if bootstrap_config_bool BOOTSTRAP_INTERACTIVE 0; then
        read -rp ">>> Enter Brewfile path or URL (<Enter> to use $brewfile): " brewfile_input
        [[ -n $brewfile_input ]] && brewfile="$brewfile_input"
      fi
      [[ -z $brewfile ]] && brewfile="$BREWFILE_DEFAULT"
      logg -i "Using Brewfile: $brewfile"

      if [[ $brewfile =~ ^https?:// ]]; then
        if prepare_brewfile_install_file "$brewfile"; then
          install_brewfile="$BREWFILE_INSTALL_PATH"
          if [[ $install_brewfile == "$brewfile" ]]; then
            run "curl -fsSL \"$brewfile\" | brew bundle --file=-"
          else
            run "brew bundle --file=\"$install_brewfile\""
          fi
          [[ -n $BREWFILE_SOURCE_TEMP ]] && rm -f "$BREWFILE_SOURCE_TEMP"
          [[ -n $BREWFILE_SELECTED_TEMP ]] && rm -f "$BREWFILE_SELECTED_TEMP"
        fi
      else
        [[ $brewfile =~ ^~ ]] && brewfile="${HOME}${brewfile:1}"
        brewfile="${brewfile/#\~/$HOME}"
        if [[ -f $brewfile ]]; then
          if prepare_brewfile_install_file "$brewfile"; then
            install_brewfile="$BREWFILE_INSTALL_PATH"
            run "brew bundle --file=\"$install_brewfile\""
            [[ -n $BREWFILE_SELECTED_TEMP ]] && rm -f "$BREWFILE_SELECTED_TEMP"
          fi
        else
          logg -w "Invalid Brewfile path: $brewfile"
        fi
      fi
    fi

    if confirm_config BOOTSTRAP_BREW_REFRESH_SNAPSHOT 'Refresh Brewfile snapshot' 'N'; then
      notify -s 'Refresh Brewfile snapshot'
      run "brew bundle dump --force --file=\"$HOME/.dotfiles/Brewfile\""
    fi

    if confirm_config BOOTSTRAP_BREW_CLEANUP "Run brew cleanup & doctor" 'N'; then
      notify -s 'Running brew maintenance'
      run 'brew cleanup'
      run 'brew doctor'
    fi

    if confirm_config BOOTSTRAP_BREW_UPGRADE "Update brew formulae & casks" 'N'; then
      notify -s 'Updating Homebrew packages'
      run 'brew upgrade --formula -y'
      run 'brew upgrade --cask --greedy -y'
    fi
  elif [[ $PKG_MGR == dnf ]]; then
    local dnf_exec="${DNF_CMD:-$(command -v dnf 2>/dev/null || command -v dnf5 2>/dev/null)}"

    if [[ -z $dnf_exec ]]; then
      logg -e 'dnf command not found after initialization.'
      exit 1
    fi

    if confirm_config BOOTSTRAP_DNF_UPGRADE 'Upgrade Fedora packages' 'Y'; then
      notify -s 'Upgrading system packages'
      run "sudo $dnf_exec upgrade --refresh -y"
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
      if confirm_config BOOTSTRAP_INSTALL_PACKAGES "Install dnf packages from $(pretty_path "$dnf_manifest")" 'Y'; then
        notify -s 'Installing dnf packages'
        mapfile -t dnf_packages < <(grep -vE '^(#|\s*$)' "$dnf_manifest")
        if [[ ${#dnf_packages[@]} -gt 0 ]]; then
          run "sudo $dnf_exec install -y ${dnf_packages[*]}"
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
    if confirm_config BOOTSTRAP_APT_UPDATE "Update apt package lists" 'Y'; then
      notify -s 'Updating apt cache'
      run 'sudo apt update'
    fi

    if confirm_config BOOTSTRAP_APT_UPGRADE "Upgrade installed apt packages" 'N'; then
      notify -s 'Upgrading apt packages'
      run 'sudo apt upgrade -y'
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
      if confirm_config BOOTSTRAP_INSTALL_PACKAGES "Install apt packages from $(pretty_path "$apt_manifest")" 'Y'; then
        notify -s 'Installing apt packages'
        mapfile -t apt_packages < <(grep -vE '^(#|\s*$)' "$apt_manifest")
        if [[ ${#apt_packages[@]} -gt 0 ]]; then
          run "sudo apt install -y ${apt_packages[*]}"
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

install_fzf() {
  notify -s 'Installing fzf'

  local fzf_dir="$XDG_DATA_HOME/fzf"
  run "mkdir -p \"$XDG_DATA_HOME\""

  if [[ -d $fzf_dir/.git ]]; then
    run "git -C \"$fzf_dir\" pull --ff-only"
  elif [[ -e $fzf_dir ]]; then
    logg -w "fzf path already exists and is not a git checkout: $(pretty_path "$fzf_dir")"
    logg -w 'Skipping fzf git install.'
    return
  else
    run "git clone --depth 1 https://github.com/junegunn/fzf.git \"$fzf_dir\""
  fi

  [[ -L $fzf_dir/bin/fzf ]] && run "rm -f \"$fzf_dir/bin/fzf\""

  [[ -x $fzf_dir/install ]] && {
    run "PATH=\"/usr/bin:/bin:/usr/sbin:/sbin\" \"$fzf_dir/install\" --bin --no-update-rc"
    return
  }

  logg -w "fzf installer not found: $(pretty_path "$fzf_dir/install")"
}

ensure_apt_keyring_repo() {
  local key_path="$1"
  local key_command="$2"
  local list_path="$3"
  local list_line="$4"

  run 'sudo mkdir -p /etc/apt/keyrings'

  [[ -f $key_path ]] || {
    require gpg || return
    run "$key_command"
  }

  [[ -f $list_path ]] || run "printf '%s\n' '$list_line' | sudo tee \"$list_path\" >/dev/null"
}

ensure_dnf_repo_file() {
  local repo_path="$1"
  local repo_content="$2"

  [[ -f $repo_path ]] && return

  if ((DRY_RUN)); then
    logg -i "[dry-run] write dnf repo file $repo_path"
    return
  fi

  printf '%s\n' "$repo_content" | sudo tee "$repo_path" >/dev/null
}

install_gh() {
  [[ $OS_TYPE == linux ]] || return
  command -v gh &>/dev/null && return

  notify -s 'Installing GitHub CLI'

  if [[ $PKG_MGR == apt ]]; then
    local github_key='/etc/apt/keyrings/githubcli-archive-keyring.gpg'
    local github_list='/etc/apt/sources.list.d/github-cli.list'
    local github_arch
    github_arch="$(dpkg --print-architecture 2>/dev/null || printf amd64)"

    ensure_apt_keyring_repo \
      "$github_key" \
      "curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee \"$github_key\" >/dev/null && sudo chmod go+r \"$github_key\"" \
      "$github_list" \
      "deb [arch=$github_arch signed-by=$github_key] https://cli.github.com/packages stable main" || return

    run 'sudo apt update'
    run 'sudo apt install -y gh'
    return
  fi

  if [[ $PKG_MGR == dnf ]]; then
    local dnf_exec="${DNF_CMD:-$(command -v dnf 2>/dev/null || command -v dnf5 2>/dev/null)}"

    [[ -n $dnf_exec ]] || {
      logg -w 'dnf command not found. Skipping GitHub CLI install.'
      return
    }

    run "sudo $dnf_exec install -y gh"
    return
  fi

  logg -w "No GitHub CLI installer defined for package manager: $PKG_MGR"
}

install_glow() {
  [[ $OS_TYPE == linux ]] || return
  command -v glow &>/dev/null && return

  notify -s 'Installing Glow'

  if [[ $PKG_MGR == apt ]]; then
    local charm_key='/etc/apt/keyrings/charm.gpg'
    local charm_list='/etc/apt/sources.list.d/charm.list'

    ensure_apt_keyring_repo \
      "$charm_key" \
      "curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o \"$charm_key\"" \
      "$charm_list" \
      "deb [signed-by=$charm_key] https://repo.charm.sh/apt/ * *" || return

    run 'sudo apt update'
    run 'sudo apt install -y glow'
    return
  fi

  if [[ $PKG_MGR == dnf ]]; then
    local charm_repo='/etc/yum.repos.d/charm.repo'
    local dnf_exec="${DNF_CMD:-$(command -v dnf 2>/dev/null || command -v dnf5 2>/dev/null)}"

    [[ -n $dnf_exec ]] || {
      logg -w 'dnf command not found. Skipping Glow install.'
      return
    }

    ensure_dnf_repo_file "$charm_repo" \
"[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key"

    run "sudo $dnf_exec install -y glow"
    return
  fi

  logg -w "No Glow installer defined for package manager: $PKG_MGR"
}

install_linux_gui_apps() {
  [[ $OS_TYPE == linux ]] || return

  bootstrap_config_bool BOOTSTRAP_INSTALL_LINUX_GUI_APPS 0 || {
    logg -w 'Skipping Linux GUI application installs.'
    return
  }

  notify -s 'Installing Linux GUI applications'

  [[ $PKG_MGR == apt ]] && install_linux_gui_apps_apt && return
  [[ $PKG_MGR == dnf ]] && install_linux_gui_apps_dnf && return

  logg -w "No GUI installer defined for package manager: $PKG_MGR"
}

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
