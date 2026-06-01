#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2034

clear

BOOTSTRAP_ENTRYPOINT="${BASH_SOURCE[0]}"
BOOTSTRAP_ROOT="$(cd "$(dirname "$BOOTSTRAP_ENTRYPOINT")" && pwd)"

# shellcheck source=bootstrap/lib/core.sh
source "$BOOTSTRAP_ROOT/bootstrap/lib/core.sh"
# shellcheck source=bootstrap/lib/validation.sh
source "$BOOTSTRAP_ROOT/bootstrap/lib/validation.sh"
# shellcheck source=bootstrap/lib/platform.sh
source "$BOOTSTRAP_ROOT/bootstrap/lib/platform.sh"
# shellcheck source=bootstrap/lib/packages.sh
source "$BOOTSTRAP_ROOT/bootstrap/lib/packages.sh"
# shellcheck source=bootstrap/lib/environment.sh
source "$BOOTSTRAP_ROOT/bootstrap/lib/environment.sh"
# shellcheck source=bootstrap/lib/extras.sh
source "$BOOTSTRAP_ROOT/bootstrap/lib/extras.sh"
# shellcheck source=bootstrap/lib/tooling.sh
source "$BOOTSTRAP_ROOT/bootstrap/lib/tooling.sh"
# shellcheck source=bootstrap/lib/orchestrator.sh
source "$BOOTSTRAP_ROOT/bootstrap/lib/orchestrator.sh"

usage() {
  cat <<'HELP'
Usage: bootstrap.sh [options]
  -p, --with-1password     Enable 1Password integration (requires op CLI)
  -c, --check              Validate repo files and shell syntax, then exit
  -d, --doctor             Validate installed workstation state, then exit
  -n, --dry-run            Print actions instead of executing them
  -i, --interactive        Prompt for configurable choices instead of using defaults
      --config PATH        Load an additional bootstrap config override
      --fresh              Use the fresh-machine profile label
      --partial            Use the partial-machine profile label
      --only TARGETS       Run only comma/space-separated bootstrap targets
      --skip TARGETS       Skip comma/space-separated bootstrap targets
      --list-targets       Show target names for --only/--skip
  -h, --help               Show this message
HELP
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -p | --with-1password) FORCE_1PASSWORD=1 ;;
    -c | --check) CHECK_MODE=1 ;;
    -d | --doctor) DOCTOR_MODE=1 ;;
    -n | --dry-run) DRY_RUN=1 ;;
    -i | --interactive) INTERACTIVE_OVERRIDE=1 ;;
    --fresh) BOOTSTRAP_PROFILE_OVERRIDE=fresh ;;
    --partial) BOOTSTRAP_PROFILE_OVERRIDE=partial ;;
    --only)
      shift
      [[ $# -gt 0 ]] || {
        logg -e '--only requires a target list'
        exit 1
      }
      BOOTSTRAP_ONLY_TARGETS_OVERRIDE="$1"
      BOOTSTRAP_PROFILE_OVERRIDE=partial
      ;;
    --skip)
      shift
      [[ $# -gt 0 ]] || {
        logg -e '--skip requires a target list'
        exit 1
      }
      BOOTSTRAP_SKIP_TARGETS_OVERRIDE="$1"
      ;;
    --list-targets)
      list_bootstrap_targets
      exit 0
      ;;
    --config)
      shift
      [[ $# -gt 0 ]] || {
        logg -e '--config requires a path'
        exit 1
      }
      BOOTSTRAP_CONFIG_PATH="$1"
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      logg -e "Unknown option: $1"
      usage
      exit 1
      ;;
    esac

    shift
  done
}

main() {
  parse_args "$@"
  init_xdg
  load_bootstrap_config
  apply_bootstrap_target_selection

  notify 'BEGIN BOOTSTRAP DEVELOPMENT SCRIPT'
  show_bootstrap_plan

  if ((CHECK_MODE)); then
    check_bootstrap
    exit $?
  fi

  notify 'SET UNIX DISTRO + PACKAGE MANAGER'
  detect_platform

  if ((DOCTOR_MODE)); then
    doctor_bootstrap
    exit $?
  fi

  notify 'AUTHORIZE & DETECT 1PASSWORD'
  authorize
  use_op

  notify 'INSTALL COMMANDS & APPS'
  install_command_phase

  notify 'SET ENVIRONMENT'
  run_configured_step BOOTSTRAP_COLLECT_ENVIRONMENT 'environment collection' collect_environment

  notify 'CREATE SYMLINKS & DIRECTORIES'
  run_configured_step BOOTSTRAP_CREATE_SYMLINKS 'XDG symlink setup' create_symlinks

  notify 'CONFIGURE CODEX UI'
  run_configured_step BOOTSTRAP_CONFIGURE_CODEX 'Codex configuration' configure_codex_phase

  notify 'CONFIGURE OS OPTIONS'
  run_configured_step BOOTSTRAP_CONFIGURE_OS 'OS defaults' configure_macos_defaults

  notify 'CONFIGURE GIT AND GITHUB CLI'
  run_configured_step BOOTSTRAP_CONFIGURE_GIT 'Git and GitHub configuration' configure_git_and_github

  notify 'CLONE DEVELOPER REPOS'
  run_configured_step BOOTSTRAP_CLONE_DEVELOPER_REPOS 'developer repo clone' clone_developer_repos

  notify 'INSTALL TEMPLATES'
  run_configured_step BOOTSTRAP_INSTALL_TEMPLATES 'template repository install' install_templates

  notify 'INSTALL SHELL PLUGIN MANAGERS'
  run_configured_step BOOTSTRAP_INSTALL_SHELL_PLUGINS 'shell plugin manager install' install_shell_plugins

  notify 'SETUP ATUIN SYNC'
  run_configured_step BOOTSTRAP_SETUP_ATUIN_SYNC 'Atuin sync setup' setup_atuin_sync

  notify 'LOAD BAT THEMES'
  run_configured_step BOOTSTRAP_LOAD_BAT_THEMES 'bat cache rebuild' load_bat_themes

  notify 'SETUP SUDO AUTH'
  run_configured_step BOOTSTRAP_CONFIGURE_SUDO_AUTH 'Touch ID sudo setup' configure_sudo_auth

  notify 'SUPPRESS LOGIN BANNER'
  run 'touch ~/.hushlogin' && logg -i 'Ensured ~/.hushlogin exists'

  notify 'CHANGE SHELL'
  run_configured_step BOOTSTRAP_CHANGE_SHELL 'default shell change' change_shell_default

  notify 'DESKTOP INTEGRATION'
  run_configured_step BOOTSTRAP_CONFIGURE_HAMMERSPOON 'desktop integration' configure_hammerspoon

  notify 'INSTALL RUST TOOLING'
  run_configured_step BOOTSTRAP_INSTALL_RUST_TOOLING 'Rust tooling install' install_rust_tooling

  notify 'SETUP IDE TOOLS'
  run_configured_step BOOTSTRAP_SETUP_IDE 'IDE tooling setup' setup_ide

  printf '\n%s\n' "${CYAN}BOOTSTRAP COMPLETE - HAPPY DEVELOPING!...${RESET}"
  logg -w 'RESTART YOUR TERMINAL WINDOW TO LOAD THE NEW CONFIGURATION'
  echo
}

main "$@"
