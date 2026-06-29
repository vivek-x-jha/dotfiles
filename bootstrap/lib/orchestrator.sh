# shellcheck shell=bash
# shellcheck disable=SC2034

install_command_phase() {
  setup_package_manager
  run_configured_step BOOTSTRAP_INSTALL_PACKAGES 'package manifest install' install_package_sets
  run_configured_step BOOTSTRAP_INSTALL_FZF 'fzf install' install_fzf
  run_configured_step BOOTSTRAP_INSTALL_GH 'GitHub CLI install' install_gh
  run_configured_step BOOTSTRAP_INSTALL_GLOW 'Glow install' install_glow
}

configure_codex_phase() {
  configure_codex_environment
  configure_codex_ui
}

install_shell_plugins() {
  notify -s 'Install zap'
  [[ -f $XDG_DATA_HOME/zap/zap.zsh ]] || run 'zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 -k'

  notify -s 'Install ble.sh'
  run 'git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git'
  run "make -C ble.sh install PREFIX=\"$HOME/.local\"" 2>/dev/null || logg -w 'Failed to install ble.sh'
  run 'rm -rf ble.sh'
}

load_bat_themes() {
  run 'bat cache --build 2>/dev/null' || logg -w 'bat not available - skipping cache rebuild.'
}

run_sourdiesel_bootstrap_tui() {
  local manifest="$BOOTSTRAP_ROOT/tools/sourdiesel-bootstrap/Cargo.toml"
  local args=(--root "$BOOTSTRAP_ROOT")
  ((DRY_RUN)) && args+=(--dry-run)

  if command -v sourdiesel-bootstrap &>/dev/null; then
    SOURDIESEL_BOOTSTRAP_ROOT="$BOOTSTRAP_ROOT" sourdiesel-bootstrap "${args[@]}"
    return
  fi

  local cargo_cmd=''
  cargo_cmd="$(command -v cargo 2>/dev/null || true)"
  [[ -z $cargo_cmd && -x $HOME/.cargo/bin/cargo ]] && cargo_cmd="$HOME/.cargo/bin/cargo"
  [[ -z $cargo_cmd && -x /opt/homebrew/bin/cargo ]] && cargo_cmd=/opt/homebrew/bin/cargo
  [[ -z $cargo_cmd && -x /usr/local/bin/cargo ]] && cargo_cmd=/usr/local/bin/cargo

  if [[ -n $cargo_cmd && -f $manifest ]]; then
    SOURDIESEL_BOOTSTRAP_ROOT="$BOOTSTRAP_ROOT" "$cargo_cmd" run --quiet --manifest-path "$manifest" -- "${args[@]}"
    return
  fi

  sourdiesel_bootstrap_menu_fallback
}

sourdiesel_bootstrap_menu_fallback() {
  local selection target

  logg -w 'sourdiesel-bootstrap Rust UI is unavailable; using plain bootstrap menu fallback.'
  while true; do
    printf '\n%s\n' 'sourdiesel-bootstrap fallback menu'
    list_bootstrap_targets | nl -w2 -s'. '
    printf ' q. quit\n'
    read -rp 'Select a target to run with --partial --only: ' selection

    [[ $selection == q || $selection == Q ]] && return 0
    [[ $selection =~ ^[0-9]+$ ]] || {
      logg -w 'Enter a target number or q.'
      continue
    }

    target="$(list_bootstrap_targets | sed -n "${selection}p")"
    [[ -n $target ]] || {
      logg -w "No target at index: $selection"
      continue
    }

    logg -i "Running target: $target"
    local command_args=(--partial --only "$target")
    ((DRY_RUN)) && command_args+=(--dry-run)
    "$BOOTSTRAP_ROOT/bootstrap.sh" "${command_args[@]}"
  done
}
