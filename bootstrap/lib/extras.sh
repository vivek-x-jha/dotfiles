# shellcheck shell=bash
# shellcheck disable=SC2034
clone_developer_repos() {
  require git || return

  local base="$HOME/Developer"
  run "mkdir -p \"$base\""

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
        if ! run "git -C \"$dest\" remote set-url origin \"$url\"" 2>/dev/null; then
          run "git -C \"$dest\" remote add origin \"$url\"" 2>/dev/null || logg -w "Failed to configure origin for $repo_name."
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
      run "git clone \"$url\" \"$dest\"" || logg -w "Failed to clone $repo_name from $url."
    fi
  done
}

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

configure_sudo_auth() {
  require brew || return

  local brew_prefix='' pam_content='' pam_tid_module='pam_tid.so'
  brew_prefix=$(brew --prefix)
  [[ -r /usr/lib/pam/pam_tid.so.2 ]] && pam_tid_module='pam_tid.so.2'

  pam_content=$(
    cat <<EOF
# Authenticate with Touch ID - even in tmux
auth  optional    $brew_prefix/lib/pam/pam_reattach.so ignore_ssh
auth  sufficient  $pam_tid_module
EOF
  )

  run "printf '%s\n' \"$pam_content\" | sudo tee /etc/pam.d/sudo_local >/dev/null" &&
    logg -i 'UPDATED /etc/pam.d/sudo_local'
}

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

configure_hammerspoon() {
  [[ $OS_TYPE == macos ]] || {
    logg -w "Skipping Hammerspoon configuration on $DISTRO"
    return
  }

  run "defaults write org.hammerspoon.Hammerspoon MJConfigFile \"$XDG_CONFIG_HOME/hammerspoon/init.lua\" 2>/dev/null" || {
    logg -w "Hammerspoon configuration skipped on $DISTRO. Configure your window manager manually."
    return
  }

  logg -i 'Configure System Settings > Privacy & Security > Accessibility for Hammerspoon.'
}
