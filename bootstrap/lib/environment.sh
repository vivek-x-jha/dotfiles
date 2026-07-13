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
    run_optional 'op signin' || {
      logg -w 'Skipping 1Password features (signin failed).'
      USE_1PASSWORD=0
    }
  fi

  # Load any existing Git metadata as defaults
  local existing_git_name existing_git_email
  local existing_origin existing_github_name

  existing_git_name=$(git config --global user.name 2>/dev/null || true)
  existing_git_email=$(git config --global user.email 2>/dev/null || true)
  GIT_SIGNING_KEY_EXISTING=$(git config --global user.signingkey 2>/dev/null || true)
  GIT_SIGNING_PROGRAM_EXISTING=$(git config --global gpg.ssh.program 2>/dev/null || true)
  GIT_ALLOWED_SIGNERS_EXISTING=$(git config --global gpg.ssh.allowedSignersFile 2>/dev/null || true)
  GIT_SIGN_COMMITS_EXISTING=$(git config --global commit.gpgsign 2>/dev/null || true)
  SSH_IDENTITY_BACKEND_EXISTING=''
  if grep -q 'identities/1password' "$XDG_CONFIG_HOME/ssh/config" 2>/dev/null \
    || [[ $(bootstrap_realpath "$XDG_CONFIG_HOME/ssh/identity.conf" || true) == "$BOOTSTRAP_ROOT/auth/ssh/identities/1password" ]]; then
    SSH_IDENTITY_BACKEND_EXISTING=1password
  fi
  existing_origin=$(git -C "$BOOTSTRAP_ROOT" remote get-url origin 2>/dev/null || true)
  existing_github_name="$(printf '%s' "$existing_origin" | sed -n 's#.*github.com[:/]\([^/]*\)/.*#\1#p')"

  if ! bootstrap_config_bool BOOTSTRAP_INTERACTIVE 0; then
    GIT_NAME="${BOOTSTRAP_GIT_NAME:-$existing_git_name}"
    GIT_EMAIL="${BOOTSTRAP_GIT_EMAIL:-$existing_git_email}"
    GITHUB_NAME="${BOOTSTRAP_GITHUB_NAME:-$existing_github_name}"

    if ((USE_1PASSWORD)); then
      OP_VAULT="${BOOTSTRAP_OP_VAULT:-Private}"
      ATUIN_OP_TITLE="${BOOTSTRAP_ATUIN_OP_TITLE:-Atuin Sync}"
      ATUIN_USERNAME="${BOOTSTRAP_ATUIN_USERNAME:-${GIT_EMAIL:+${GIT_EMAIL%@*}}}"
      ATUIN_EMAIL="${BOOTSTRAP_ATUIN_EMAIL:-$GIT_EMAIL}"
    else
      OP_VAULT=''
      ATUIN_OP_TITLE=''
      ATUIN_USERNAME=''
      ATUIN_EMAIL=''
    fi

    MEDIA="${BOOTSTRAP_MEDIA:-}"

    logg -i "Git identity: ${GIT_NAME:-<preserved/unset>} <${GIT_EMAIL:-preserved/unset}>"
    logg -i "GitHub user: ${GITHUB_NAME:-<preserved/unset>}"
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

backup_bootstrap_target() {
  local target="$1"
  local relative backup suffix=0

  case "$target" in
  "$HOME"/*) relative="${target#"$HOME"/}" ;;
  *) relative="external/${target#/}" ;;
  esac

  backup="$XDG_STATE_HOME/dotfiles/backups/$BOOTSTRAP_RUN_ID/$relative"
  local base_backup="$backup"
  while [[ -e $backup || -L $backup ]]; do
    suffix=$((suffix + 1))
    backup="$base_backup.$suffix"
  done

  run "mkdir -p \"$(dirname "$backup")\"" || return
  run "mv \"$target\" \"$backup\"" || return
  logg -w "Preserved existing $(pretty_path "$target") at $(pretty_path "$backup")"
}

ensure_bootstrap_dir() {
  local target="$1"

  [[ -d $target && ! -L $target ]] && return 0
  if [[ -e $target || -L $target ]]; then
    ((DRY_RUN)) && BOOTSTRAP_PLANNED_REPLACED_DIRS+=("$target")
    backup_bootstrap_target "$target"
  fi
  run "mkdir -p \"$target\""
}

ensure_bootstrap_symlink() {
  local source="$1"
  local target="$2"
  local current=''
  local current_real=''
  local source_real=''
  local planned_dir=''
  local target_is_planned=0

  if [[ ! -e $source && ! -L $source ]]; then
    if ! ((DRY_RUN)) || [[ $source != "$XDG_DATA_HOME/vscode" ]]; then
      logg -e "Managed source missing: $(pretty_path "$source")"
      BOOTSTRAP_FAILURES=$((BOOTSTRAP_FAILURES + 1))
      return 1
    fi
  fi

  if [[ -L $target ]]; then
    current=$(readlink "$target" 2>/dev/null || true)
    if [[ $current == "$source" ]]; then
      logg -i "ok: $(pretty_path "$target") -> $(pretty_path "$source")"
      return 0
    fi

    current_real=$(bootstrap_realpath "$target" || true)
    source_real=$(bootstrap_realpath "$source" || true)
    if [[ -n $current_real && $current_real == "$source_real" ]]; then
      logg -i "ok: $(pretty_path "$target") -> $(pretty_path "$source")"
      return 0
    fi
  fi

  run "mkdir -p \"$(dirname "$target")\"" || return
  if ((DRY_RUN)); then
    for planned_dir in "${BOOTSTRAP_PLANNED_REPLACED_DIRS[@]}"; do
      [[ $target == "$planned_dir"/* ]] && target_is_planned=1 && break
    done
  fi
  ((target_is_planned)) || { [[ ! -e $target && ! -L $target ]] || backup_bootstrap_target "$target"; }
  run "ln -s \"$source\" \"$target\"" || return
  logg -i "linked: $(pretty_path "$target") -> $(pretty_path "$source")"
}

seed_bootstrap_file() {
  local source="$1"
  local target="$2"

  [[ -e $target || -L $target ]] && return 0
  run "mkdir -p \"$(dirname "$target")\"" || return
  run "cp \"$source\" \"$target\""
}

set_git_file_value() {
  local file="$1"
  local key="$2"
  local value="$3"
  local status=0

  [[ -n $value ]] || return 0
  if ((DRY_RUN)); then
    logg -i "[dry-run] preserve Git key $key in $(pretty_path "$file")"
    return 0
  fi

  git config --file "$file" "$key" "$value"
  status=$?
  if ((status != 0)); then
    BOOTSTRAP_FAILURES=$((BOOTSTRAP_FAILURES + 1))
    logg -e "Unable to preserve Git key: $key"
  fi
  return "$status"
}

prepare_git_config_home() {
  local git_dir="$XDG_CONFIG_HOME/git"
  local git_config="$git_dir/config"
  local include_path="$BOOTSTRAP_ROOT/auth/git/base"
  local legacy_layout=0
  local legacy_name='' legacy_email='' legacy_signing_key=''
  local legacy_format='' legacy_allowed_signers='' legacy_program='' legacy_sign=''

  if [[ -L $git_dir ]] \
    && [[ $(bootstrap_realpath "$git_dir" || true) == "$BOOTSTRAP_ROOT/auth/git" ]]; then
    legacy_layout=1
    legacy_name=$(git config --file "$git_config" user.name 2>/dev/null || true)
    legacy_email=$(git config --file "$git_config" user.email 2>/dev/null || true)
    legacy_signing_key=$(git config --file "$git_config" user.signingkey 2>/dev/null || true)
    legacy_format=$(git config --file "$git_config" gpg.format 2>/dev/null || true)
    legacy_allowed_signers=$(git config --file "$git_config" gpg.ssh.allowedSignersFile 2>/dev/null || true)
    legacy_program=$(git config --file "$git_config" gpg.ssh.program 2>/dev/null || true)
    legacy_sign=$(git config --file "$git_config" commit.gpgsign 2>/dev/null || true)
    GIT_NAME="${GIT_NAME:-$legacy_name}"
    GIT_EMAIL="${GIT_EMAIL:-$legacy_email}"
    GIT_SIGNING_KEY_EXISTING="${GIT_SIGNING_KEY_EXISTING:-$legacy_signing_key}"
    GIT_SIGNING_PROGRAM_EXISTING="${GIT_SIGNING_PROGRAM_EXISTING:-$legacy_program}"
    GIT_ALLOWED_SIGNERS_EXISTING="${GIT_ALLOWED_SIGNERS_EXISTING:-$legacy_allowed_signers}"
    GIT_SIGN_COMMITS_EXISTING="${GIT_SIGN_COMMITS_EXISTING:-$legacy_sign}"
  fi

  ensure_bootstrap_dir "$git_dir" || return
  ensure_bootstrap_symlink "$BOOTSTRAP_ROOT/auth/git/themes/sourdiesel" "$git_dir/themes/sourdiesel" || return

  if [[ ! -f $git_config ]] || ! git config --file "$git_config" --get-all include.path 2>/dev/null | grep -Fxq "$include_path"; then
    run "git config --file \"$git_config\" --add include.path \"$include_path\"" || return
  fi

  if ((legacy_layout)); then
    set_git_file_value "$git_config" user.name "$legacy_name" || return
    set_git_file_value "$git_config" user.email "$legacy_email" || return
    set_git_file_value "$git_config" user.signingkey "$legacy_signing_key" || return
    set_git_file_value "$git_config" gpg.format "$legacy_format" || return
    set_git_file_value "$git_config" gpg.ssh.allowedSignersFile "$legacy_allowed_signers" || return
    set_git_file_value "$git_config" gpg.ssh.program "$legacy_program" || return
    set_git_file_value "$git_config" commit.gpgsign "$legacy_sign" || return
  fi
}

prepare_ssh_config_home() {
  local ssh_dir="$XDG_CONFIG_HOME/ssh"
  local ssh_config="$ssh_dir/config"
  local include_line="Include \"$BOOTSTRAP_ROOT/auth/ssh/base\""

  if [[ ${SSH_IDENTITY_BACKEND_EXISTING:-} != 1password ]] \
    && grep -q 'identities/1password' "$ssh_config" 2>/dev/null; then
    SSH_IDENTITY_BACKEND_EXISTING=1password
  fi

  ensure_bootstrap_dir "$ssh_dir" || return
  if [[ -L $ssh_config ]]; then
    backup_bootstrap_target "$ssh_config" || return
  fi
  if [[ ! -f $ssh_config ]] || ! grep -Fxq "$include_line" "$ssh_config"; then
    if ((DRY_RUN)); then
      logg -i "[dry-run] append managed include to $(pretty_path "$ssh_config")"
    else
      printf '%s\n' "$include_line" >>"$ssh_config" || {
        BOOTSTRAP_FAILURES=$((BOOTSTRAP_FAILURES + 1))
        logg -e "Unable to update $(pretty_path "$ssh_config")"
        return 1
      }
      chmod 600 "$ssh_config" || true
    fi
  fi
  seed_bootstrap_file "$BOOTSTRAP_ROOT/auth/ssh/known_hosts" "$ssh_dir/known_hosts" || return
  if [[ -n ${GIT_SIGNING_KEY_EXISTING:-} ]]; then
    seed_bootstrap_file "$BOOTSTRAP_ROOT/auth/ssh/allowed_signers" "$ssh_dir/allowed_signers" || return
  fi

  if ((USE_1PASSWORD)) || [[ ${SSH_IDENTITY_BACKEND_EXISTING:-} == 1password ]]; then
    ensure_bootstrap_symlink "$BOOTSTRAP_ROOT/auth/ssh/identities/1password" "$ssh_dir/identity.conf" || return
  fi

  if ((USE_1PASSWORD)); then
    ensure_bootstrap_dir "$XDG_CONFIG_HOME/1Password/ssh" || return
    seed_bootstrap_file "$BOOTSTRAP_ROOT/auth/1Password/ssh/agent.toml" "$XDG_CONFIG_HOME/1Password/ssh/agent.toml"
  fi
}

create_symlinks() {
  local dir source target skill_dir skill_name installed_skill installed_real
  local dirs=(
    "$XDG_CACHE_HOME" "$XDG_CACHE_HOME/npm" "$HOME/.local/bin"
    "$XDG_STATE_HOME/bash" "$XDG_STATE_HOME/codex" "$XDG_STATE_HOME/codex/skills"
    "$XDG_STATE_HOME/jupyter/runtime" "$XDG_STATE_HOME/less" "$XDG_STATE_HOME/mycli"
    "$XDG_STATE_HOME/mysql" "$XDG_STATE_HOME/pi/agent" "$XDG_STATE_HOME/pi/agent/extensions"
    "$XDG_STATE_HOME/pi/agent/skills" "$XDG_STATE_HOME/pi/agent/themes" "$XDG_STATE_HOME/python"
    "$XDG_STATE_HOME/ipython" "$XDG_STATE_HOME/zsh" "$XDG_CONFIG_HOME/claude"
    "$XDG_CONFIG_HOME/herdr" "$XDG_CONFIG_HOME/jupyter"
    "$XDG_DATA_HOME/jupyter" "$XDG_DATA_HOME/zsh" "$XDG_DATA_HOME/vscode"
  )
  local symlinks=(
    "$BOOTSTRAP_ROOT/cli/atuin" "$XDG_CONFIG_HOME/atuin"
    "$BOOTSTRAP_ROOT/cli/bat" "$XDG_CONFIG_HOME/bat"
    "$BOOTSTRAP_ROOT/cli/btop" "$XDG_CONFIG_HOME/btop"
    "$BOOTSTRAP_ROOT/ai/herdr/config.toml" "$XDG_CONFIG_HOME/herdr/config.toml"
    "$BOOTSTRAP_ROOT/ai/herdr/scripts/herdr-balance-panes" "$HOME/.local/bin/herdr-balance-panes"
    "$BOOTSTRAP_ROOT/ai/herdr/scripts/herdr-codex-title-watch" "$HOME/.local/bin/herdr-codex-title-watch"
    "$BOOTSTRAP_ROOT/ai/herdr/scripts/herdr-resurrect" "$HOME/.local/bin/herdr-resurrect"
    "$BOOTSTRAP_ROOT/cli/dust" "$XDG_CONFIG_HOME/dust"
    "$BOOTSTRAP_ROOT/cli/eva" "$XDG_CONFIG_HOME/eva"
    "$BOOTSTRAP_ROOT/cli/fzf" "$XDG_CONFIG_HOME/fzf"
    "$BOOTSTRAP_ROOT/cli/gh" "$XDG_CONFIG_HOME/gh"
    "$BOOTSTRAP_ROOT/cli/zsh-patina" "$XDG_CONFIG_HOME/zsh-patina"
    "$BOOTSTRAP_ROOT/ai/AGENTS.md" "$XDG_CONFIG_HOME/claude/CLAUDE.md"
    "$BOOTSTRAP_ROOT/ai/claude-code/settings.json" "$XDG_CONFIG_HOME/claude/settings.json"
    "$BOOTSTRAP_ROOT/cli/glow" "$XDG_CONFIG_HOME/glow"
    "$BOOTSTRAP_ROOT/cli/matplotlib" "$XDG_CONFIG_HOME/matplotlib"
    "$BOOTSTRAP_ROOT/cli/mycli" "$XDG_CONFIG_HOME/mycli"
    "$BOOTSTRAP_ROOT/cli/npm" "$XDG_CONFIG_HOME/npm"
    "$BOOTSTRAP_ROOT/ai/AGENTS.md" "$XDG_STATE_HOME/codex/AGENTS.md"
    "$BOOTSTRAP_ROOT/ai/AGENTS.md" "$XDG_STATE_HOME/pi/agent/AGENTS.md"
    "$BOOTSTRAP_ROOT/ai/pi/models.json" "$XDG_STATE_HOME/pi/agent/models.json"
    "$BOOTSTRAP_ROOT/ai/pi/extensions/handoff-alias.ts" "$XDG_STATE_HOME/pi/agent/extensions/handoff-alias.ts"
    "$BOOTSTRAP_ROOT/ai/pi/extensions/herdr-agent-state.ts" "$XDG_STATE_HOME/pi/agent/extensions/herdr-agent-state.ts"
    "$BOOTSTRAP_ROOT/ai/pi/extensions/statusline.ts" "$XDG_STATE_HOME/pi/agent/extensions/statusline.ts"
    "$BOOTSTRAP_ROOT/ai/pi/extensions/thread-title.ts" "$XDG_STATE_HOME/pi/agent/extensions/thread-title.ts"
    "$BOOTSTRAP_ROOT/ai/pi/extensions/tsconfig.json" "$XDG_STATE_HOME/pi/agent/extensions/tsconfig.json"
    "$BOOTSTRAP_ROOT/ai/pi/skills/handoff" "$XDG_STATE_HOME/pi/agent/skills/handoff"
    "$BOOTSTRAP_ROOT/ai/pi/themes/sourdiesel.json" "$XDG_STATE_HOME/pi/agent/themes/sourdiesel.json"
    "$BOOTSTRAP_ROOT/editors/nvim" "$XDG_CONFIG_HOME/nvim"
    "$BOOTSTRAP_ROOT/editors/vscode" "$XDG_CONFIG_HOME/vscode"
    "$BOOTSTRAP_ROOT/shells" "$XDG_CONFIG_HOME/shells"
    "$BOOTSTRAP_ROOT/terminals/tmux" "$XDG_CONFIG_HOME/tmux"
    "$BOOTSTRAP_ROOT/terminals/wezterm" "$XDG_CONFIG_HOME/wezterm"
    "$BOOTSTRAP_ROOT/shells/starship.toml" "$XDG_CONFIG_HOME/starship.toml"
    "$XDG_DATA_HOME/vscode" "$HOME/.vscode"
    "$BOOTSTRAP_ROOT/shells/bash/.bash_profile" "$HOME/.bash_profile"
    "$BOOTSTRAP_ROOT/shells/bash/.bashrc" "$HOME/.bashrc"
    "$BOOTSTRAP_ROOT/shells/env" "$HOME/.zshenv"
  )

  for dir in "${dirs[@]}"; do ensure_bootstrap_dir "$dir" || return; done
  prepare_git_config_home || return
  prepare_ssh_config_home || return

  for installed_skill in "$XDG_STATE_HOME/codex/skills"/*; do
    [[ -L $installed_skill ]] || continue
    skill_name="${installed_skill##*/}"
    bootstrap_codex_skill_enabled "$skill_name" && continue
    installed_real=$(bootstrap_realpath "$installed_skill" || true)
    [[ $installed_real == "$BOOTSTRAP_ROOT/ai/codex/skills/$skill_name" ]] || continue
    run "rm -f \"$installed_skill\"" || return
    logg -i "removed disabled personal Codex skill: $skill_name"
  done

  for skill_dir in "$BOOTSTRAP_ROOT/ai/codex/skills"/*; do
    [[ -d $skill_dir && -f $skill_dir/SKILL.md ]] || continue
    skill_name="${skill_dir##*/}"
    bootstrap_codex_skill_enabled "$skill_name" || continue
    symlinks+=("$skill_dir" "$XDG_STATE_HOME/codex/skills/$skill_name")
  done

  if [[ $OS_TYPE == macos ]]; then
    symlinks+=(
      "$BOOTSTRAP_ROOT/apps/hammerspoon" "$XDG_CONFIG_HOME/hammerspoon"
      "$BOOTSTRAP_ROOT/apps/karabiner" "$XDG_CONFIG_HOME/karabiner"
      "$BOOTSTRAP_ROOT/editors/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
    )
  else
    symlinks+=("$BOOTSTRAP_ROOT/editors/vscode/settings.json" "$XDG_CONFIG_HOME/Code/User/settings.json")
  fi

  [[ -z ${MEDIA:-} ]] && logg -w 'Media path not set. Skipping media symlinks...'
  if [[ -n ${MEDIA:-} && -d $HOME/$MEDIA ]]; then
    symlinks+=(
      "$HOME/$MEDIA/content" "$HOME/Movies/content"
      "$HOME/$MEDIA/icons" "$HOME/Pictures/icons"
      "$HOME/$MEDIA/screenshots" "$HOME/Pictures/screenshots"
      "$HOME/$MEDIA/wallpapers" "$HOME/Pictures/wallpapers"
      "$HOME/$MEDIA/education" "$HOME/Documents/education"
      "$HOME/$MEDIA/finances" "$HOME/Documents/finances"
    )
  fi

  for ((dir = 0; dir < ${#symlinks[@]}; dir += 2)); do
    source="${symlinks[dir]}"
    target="${symlinks[dir + 1]}"
    ensure_bootstrap_symlink "$source" "$target" || return
  done
}

configure_codex_environment() {
  local codex_home="${CODEX_HOME:-$XDG_STATE_HOME/codex}"
  local nvim_log_file="${NVIM_LOG_FILE:-$XDG_STATE_HOME/nvim/nvim.log}"
  local pi_agent_dir="${PI_CODING_AGENT_DIR:-$XDG_STATE_HOME/pi/agent}"
  local ollama_host="${OLLAMA_HOST:-127.0.0.1:11434}"
  local ollama_flash_attention="${OLLAMA_FLASH_ATTENTION:-1}"
  local ollama_kv_cache_type="${OLLAMA_KV_CACHE_TYPE:-q8_0}"
  export CODEX_HOME="$codex_home"
  export NVIM_LOG_FILE="$nvim_log_file"
  export PI_CODING_AGENT_DIR="$pi_agent_dir"
  export OLLAMA_HOST="$ollama_host"
  export OLLAMA_FLASH_ATTENTION="$ollama_flash_attention"
  export OLLAMA_KV_CACHE_TYPE="$ollama_kv_cache_type"

  [[ $OS_TYPE == macos ]] || return
  require launchctl || return

  run "launchctl setenv XDG_CONFIG_HOME \"$XDG_CONFIG_HOME\""
  run "launchctl setenv XDG_CACHE_HOME \"$XDG_CACHE_HOME\""
  run "launchctl setenv XDG_DATA_HOME \"$XDG_DATA_HOME\""
  run "launchctl setenv XDG_STATE_HOME \"$XDG_STATE_HOME\""
  run "launchctl setenv CODEX_HOME \"$codex_home\""
  run "launchctl setenv NVIM_LOG_FILE \"$nvim_log_file\""
  run "launchctl setenv PI_CODING_AGENT_DIR \"$pi_agent_dir\""
  run "launchctl setenv OLLAMA_HOST \"$ollama_host\""
  run "launchctl setenv OLLAMA_FLASH_ATTENTION \"$ollama_flash_attention\""
  run "launchctl setenv OLLAMA_KV_CACHE_TYPE \"$ollama_kv_cache_type\""
  logg -i "Agent launch environment: CODEX_HOME=$(pretty_path "$codex_home"), PI_CODING_AGENT_DIR=$(pretty_path "$pi_agent_dir"), OLLAMA_HOST=$ollama_host"
}

configure_codex_ui() {
  local codex_home="${CODEX_HOME:-$XDG_STATE_HOME/codex}"
  local config_path="$codex_home/config.toml"
  local script_path="$BOOTSTRAP_ROOT/ai/codex/scripts/apply_preferences.py"
  local preferences_path="$BOOTSTRAP_ROOT/ai/codex/config/preferences.toml"
  local theme_path="$BOOTSTRAP_ROOT/ai/codex/themes/sourdiesel.toml"

  require python3 || {
    logg -w 'Python 3 unavailable. Skipping Codex UI preference configuration.'
    return
  }

  [[ -f $script_path && -f $preferences_path && -f $theme_path ]] || {
    logg -w 'Codex preference source files missing. Skipping Codex configuration.'
    return
  }

  run "mkdir -p \"$codex_home\""
  run "python3 \"$script_path\" \"$config_path\" \"$preferences_path\"" || logg -w 'Codex portable preference configuration failed.'
  run "python3 \"$script_path\" \"$config_path\" \"$theme_path\"" || logg -w 'Codex UI preference configuration failed.'
  logg -i "Codex portable preferences: $(pretty_path "$preferences_path")"
  logg -i "Codex SourDiesel UI preferences: $(pretty_path "$theme_path")"
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

    run "defaults write \"$dom\" \"$key\" \"$opt\" \"$val\""
  done

  # Reset dock for settings to take effect
  run_optional 'killall Dock' || true
}

set_git_global() {
  local key="$1"
  local value="$2"
  local status=0

  ((DRY_RUN)) && {
    logg -i "[dry-run] git config --global $key <configured value>"
    return 0
  }

  git config --global "$key" "$value"
  status=$?
  if ((status != 0)); then
    BOOTSTRAP_FAILURES=$((BOOTSTRAP_FAILURES + 1))
    logg -e "Unable to configure Git key: $key"
  fi
  return "$status"
}

configure_git_and_github() {
  local remote_url="${BOOTSTRAP_GIT_REMOTE:-}"
  local signing_key="${BOOTSTRAP_GIT_SIGNING_KEY:-${GIT_SIGNING_KEY_EXISTING:-}}"
  local signing_program="${BOOTSTRAP_GIT_SIGNING_PROGRAM:-${GIT_SIGNING_PROGRAM_EXISTING:-}}"
  local allowed_signers="${BOOTSTRAP_GIT_ALLOWED_SIGNERS_FILE:-${GIT_ALLOWED_SIGNERS_EXISTING:-$XDG_CONFIG_HOME/ssh/allowed_signers}}"

  prepare_git_config_home || return
  prepare_ssh_config_home || return

  if [[ -n ${GIT_NAME:-} ]]; then
    set_git_global user.name "$GIT_NAME" || return
  else
    logg -w 'Git user.name is unset; preserving that state. Set BOOTSTRAP_GIT_NAME or rerun with --interactive.'
  fi

  if [[ -n ${GIT_EMAIL:-} ]]; then
    set_git_global user.email "$GIT_EMAIL" || return
  else
    logg -w 'Git user.email is unset; preserving that state. Set BOOTSTRAP_GIT_EMAIL or rerun with --interactive.'
  fi

  if bootstrap_config_bool BOOTSTRAP_GIT_SIGN_COMMITS 0; then
    [[ -n $signing_key ]] || {
      logg -e 'BOOTSTRAP_GIT_SIGN_COMMITS=1 requires BOOTSTRAP_GIT_SIGNING_KEY or an existing signing key.'
      BOOTSTRAP_FAILURES=$((BOOTSTRAP_FAILURES + 1))
      return 1
    }
    set_git_global user.signingkey "$signing_key" || return
    set_git_global gpg.format ssh || return
    [[ -n $signing_program ]] && set_git_global gpg.ssh.program "$signing_program"
    set_git_global gpg.ssh.allowedSignersFile "$allowed_signers" || return
    set_git_global commit.gpgsign true || return
  elif [[ ${GIT_SIGN_COMMITS_EXISTING:-} == true && -n $signing_key ]]; then
    set_git_global user.signingkey "$signing_key" || return
    set_git_global gpg.format ssh || return
    [[ -n $signing_program ]] && set_git_global gpg.ssh.program "$signing_program"
    [[ -n $allowed_signers ]] && set_git_global gpg.ssh.allowedSignersFile "$allowed_signers"
    set_git_global commit.gpgsign true || return
  fi

  if bootstrap_config_bool BOOTSTRAP_CONFIGURE_GIT_REMOTE 0; then
    if [[ -z $remote_url && -z ${GITHUB_NAME:-} ]]; then
      logg -e 'Remote configuration requires BOOTSTRAP_GIT_REMOTE or BOOTSTRAP_GITHUB_NAME.'
      BOOTSTRAP_FAILURES=$((BOOTSTRAP_FAILURES + 1))
      return 1
    fi
    [[ -n $remote_url ]] || remote_url="git@github.com:$GITHUB_NAME/dotfiles.git"
    if ((DRY_RUN)); then
      logg -i "[dry-run] git -C $BOOTSTRAP_ROOT remote set-url origin $remote_url"
    else
      git -C "$BOOTSTRAP_ROOT" remote set-url origin "$remote_url" || {
        BOOTSTRAP_FAILURES=$((BOOTSTRAP_FAILURES + 1))
        logg -e 'Failed to update the dotfiles origin remote.'
        return 1
      }
    fi

    if [[ $remote_url != *vivek-x-jha/dotfiles.git* ]] && ! git -C "$BOOTSTRAP_ROOT" remote get-url upstream &>/dev/null; then
      run "git -C \"$BOOTSTRAP_ROOT\" remote add upstream https://github.com/vivek-x-jha/dotfiles.git" || return
    fi
  else
    logg -i 'Preserving the dotfiles Git remotes.'
  fi

  if ((USE_1PASSWORD)); then
    local agent_file="$XDG_CONFIG_HOME/1Password/ssh/agent.toml"
    if [[ -f $agent_file ]]; then
      if ((DRY_RUN)); then
        logg -i "[dry-run] update 1Password SSH agent vault in $(pretty_path "$agent_file")"
      else
        perl -pi -e "s/vault = \"Private\"/vault = \"$OP_VAULT\"/g" "$agent_file" || {
          BOOTSTRAP_FAILURES=$((BOOTSTRAP_FAILURES + 1))
          return 1
        }
      fi
    else
      logg -w "1Password SSH agent config not found at $agent_file"
    fi
  fi

  if command -v gh &>/dev/null && confirm_config BOOTSTRAP_GH_AUTH 'Authenticate GitHub CLI' 'N'; then
    run "cd \"$BOOTSTRAP_ROOT\" && gh auth login" || return
    [[ -n ${GITHUB_NAME:-} ]] && run "cd \"$BOOTSTRAP_ROOT\" && gh repo set-default \"$GITHUB_NAME/dotfiles\""
  elif ! command -v gh &>/dev/null; then
    logg -w 'GitHub CLI not installed. Skipping gh auth.'
  fi
}
