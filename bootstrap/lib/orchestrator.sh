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
