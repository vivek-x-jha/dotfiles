# shellcheck shell=bash
# shellcheck disable=SC2034

configure_codex_phase() {
  configure_codex_environment
  configure_codex_ui
}

bootstrap_normalize_target() {
  case "$1" in
  environment) printf 'env' ;;
  links) printf 'symlinks' ;;
  github) printf 'git' ;;
  developer-repos) printf 'repos' ;;
  plugins) printf 'shell-plugins' ;;
  themes) printf 'bat' ;;
  touchid) printf 'sudo' ;;
  desktop) printf 'hammerspoon' ;;
  editor) printf 'ide' ;;
  macos) printf 'os' ;;
  *) printf '%s' "$1" ;;
  esac
}

bootstrap_target_dependencies() {
  case "$(bootstrap_normalize_target "$1")" in
  symlinks) printf '%s\n' env ;;
  codex) printf '%s\n' symlinks ;;
  git) printf '%s\n' env symlinks ;;
  shell-plugins) printf '%s\n' symlinks ;;
  atuin)
    printf '%s\n' packages
    [[ ${PKG_MGR:-} == brew ]] || printf '%s\n' rust
    printf '%s\n' env symlinks
    ;;
  bat) printf '%s\n' packages symlinks ;;
  hammerspoon) printf '%s\n' packages symlinks ;;
  rust) printf '%s\n' packages ;;
  ide) printf '%s\n' packages rust symlinks ;;
  gh | glow) printf '%s\n' packages ;;
  herdr) printf '%s\n' symlinks ;;
  esac
}

bootstrap_target_explicitly_skipped() {
  local candidate=''
  while IFS= read -r candidate; do
    [[ $(bootstrap_normalize_target "$candidate") == "$(bootstrap_normalize_target "$1")" ]] && return 0
  done < <(bootstrap_words "${BOOTSTRAP_SKIP_TARGETS:-}")
  return 1
}

bootstrap_target_status_var() {
  local target
  target="$(bootstrap_normalize_target "$1")"
  target="$(printf '%s' "$target" | tr '[:lower:]-' '[:upper:]_')"
  printf 'BOOTSTRAP_TARGET_STATUS_%s' "$target"
}

bootstrap_target_status() {
  local var
  var="$(bootstrap_target_status_var "$1")"
  printf '%s' "${!var:-pending}"
}

set_bootstrap_target_status() {
  local var
  var="$(bootstrap_target_status_var "$1")"
  printf -v "$var" '%s' "$2"
}

run_bootstrap_target_with_dependencies() {
  local target dependency dependency_status status
  local before started duration target_var target_configured
  target="$(bootstrap_normalize_target "$1")"
  status="$(bootstrap_target_status "$target")"

  case "$status" in
  success) return 0 ;;
  failed | skipped) return 1 ;;
  running)
    BOOTSTRAP_FAILURES=$((BOOTSTRAP_FAILURES + 1))
    logg -e "Dependency cycle detected at target: $target"
    set_bootstrap_target_status "$target" failed
    return 1
    ;;
  esac

  if bootstrap_target_explicitly_skipped "$target"; then
    set_bootstrap_target_status "$target" skipped
    logg -w "Skipping explicitly disabled dependency target: $target"
    return 1
  fi

  if bootstrap_checkpoint_complete "$target"; then
    set_bootstrap_target_status "$target" success
    record_bootstrap_timing "$target" 0 resumed
    logg -i "Resume checkpoint: skipping completed target $target"
    return 0
  fi

  set_bootstrap_target_status "$target" running
  while IFS= read -r dependency; do
    [[ -n $dependency ]] || continue
    if ! run_bootstrap_target_with_dependencies "$dependency"; then
      dependency_status="$(bootstrap_target_status "$dependency")"
      set_bootstrap_target_status "$target" skipped
      if [[ $dependency_status == skipped ]]; then
        BOOTSTRAP_FAILURES=$((BOOTSTRAP_FAILURES + 1))
      fi
      logg -e "Skipping target $target because dependency $dependency is $dependency_status."
      return 1
    fi
  done < <(bootstrap_target_dependencies "$target")

  notify -s "Target: $target"
  before=$BOOTSTRAP_FAILURES
  started=$SECONDS
  target_var="$(bootstrap_target_var "$target")" || target_var=''
  if [[ -n $target_var ]]; then
    target_configured="${!target_var:-0}"
    printf -v "$target_var" '%s' 1
  fi
  run_bootstrap_target "$target"
  status=$?
  [[ -n $target_var ]] && printf -v "$target_var" '%s' "$target_configured"
  duration=$((SECONDS - started))
  if ((status != 0 || BOOTSTRAP_FAILURES > before)); then
    if ((status != 0 && BOOTSTRAP_FAILURES == before)); then
      BOOTSTRAP_FAILURES=$((BOOTSTRAP_FAILURES + 1))
    fi
    set_bootstrap_target_status "$target" failed
    record_bootstrap_timing "$target" "$duration" failed
    logg -e "Target failed: $target"
    return 1
  fi

  set_bootstrap_target_status "$target" success
  [[ $target == packages ]] && use_op
  write_bootstrap_checkpoint "$target" "$duration" || logg -w "Unable to write checkpoint for $target"
  record_bootstrap_timing "$target" "$duration" success
  return 0
}

run_bootstrap_target_selection() {
  local target

  notify 'RUN SELECTED BOOTSTRAP TARGETS'
  while IFS= read -r target; do
    run_bootstrap_target_with_dependencies "$target" || true
  done < <(bootstrap_words "$BOOTSTRAP_ONLY_TARGETS")

  ((BOOTSTRAP_FAILURES == 0))
}

run_all_bootstrap_targets() {
  local target var

  notify 'RUN BOOTSTRAP TARGETS'
  while IFS= read -r target; do
    var="$(bootstrap_target_var "$target")" || continue
    if bootstrap_config_bool "$var" 0; then
      run_bootstrap_target_with_dependencies "$target" || true
    else
      logg -w "Skipping target $target (${var}=0)"
    fi
  done < <(list_bootstrap_targets)
}

run_bootstrap_target() {
  case "$1" in
  packages)
    setup_package_manager || return
    install_package_sets
    ;;
  fzf) install_fzf ;;
  gh) install_gh ;;
  glow) install_glow ;;
  herdr) install_herdr ;;
  env | environment) collect_environment ;;
  symlinks | links) create_symlinks ;;
  codex) configure_codex_phase ;;
  os | macos) configure_macos_defaults ;;
  git | github)
    collect_environment
    configure_git_and_github
    ;;
  repos | developer-repos) clone_developer_repos ;;
  templates) install_templates ;;
  shell-plugins | plugins) install_shell_plugins ;;
  atuin)
    collect_environment
    setup_atuin_sync
    ;;
  bat | themes) load_bat_themes ;;
  sudo | touchid)
    authorize
    configure_sudo_auth
    ;;
  shell) change_shell_default ;;
  hammerspoon | desktop) configure_hammerspoon ;;
  rust) install_rust_tooling ;;
  ide | editor) setup_ide ;;
  *)
    logg -e "Unknown bootstrap target: $1"
    return 1
    ;;
  esac
}

install_shell_plugins() {
  notify -s 'Install zap'
  [[ -f $XDG_DATA_HOME/zap/zap.zsh ]] || \
    run_retry "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" \
      'zsh <(curl -fsSL https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 -k' || return

  notify -s 'Install ble.sh'
  if [[ -f $XDG_DATA_HOME/blesh/ble.sh ]]; then
    logg -i 'ble.sh already installed.'
    return 0
  fi

  local blesh_tmp=''
  blesh_tmp="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-blesh.XXXXXX")" || return
  run_retry "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" \
    "git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git \"$blesh_tmp\"" || {
    rm -rf "$blesh_tmp"
    return 1
  }
  run "make -C \"$blesh_tmp\" install PREFIX=\"$HOME/.local\"" 2>/dev/null
  local status=$?
  rm -rf "$blesh_tmp"
  ((status == 0)) || logg -w 'Failed to install ble.sh'
  return "$status"
}

load_bat_themes() {
  require bat || return 1
  run 'bat cache --build 2>/dev/null'
}
