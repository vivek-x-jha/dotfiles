#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2034

BOOTSTRAP_ENTRYPOINT="${BASH_SOURCE[0]}"
BOOTSTRAP_ROOT="$(cd "$(dirname "$BOOTSTRAP_ENTRYPOINT")" && pwd)"
export BOOTSTRAP_ROOT
export DOTFILES_DIR="$BOOTSTRAP_ROOT"

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
  -r, --resume             Resume checkpoints from the last incomplete matching plan
  -i, --interactive        Prompt for configurable choices instead of using defaults
      --tui                Open the sourdiesel-bootstrap orbital installer UI
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
    -r | --resume) RESUME_MODE=1 ;;
    -i | --interactive) INTERACTIVE_OVERRIDE=1 ;;
    --tui) TUI_MODE=1 ;;
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
  [[ -t 1 && -n ${TERM:-} ]] && clear
  init_xdg
  init_tool_environment
  load_bootstrap_config
  apply_bootstrap_target_selection
  resolve_bootstrap_profile
  resolve_bootstrap_dependency_plan

  ((TUI_MODE)) && {
    run_sourdiesel_bootstrap_tui
    exit $?
  }

  notify 'BEGIN BOOTSTRAP DEVELOPMENT SCRIPT'
  show_bootstrap_plan

  ((CHECK_MODE)) && {
    check_bootstrap
    exit $?
  }

  notify 'SET UNIX DISTRO + PACKAGE MANAGER'
  detect_platform

  ((DOCTOR_MODE)) && {
    doctor_bootstrap
    exit $?
  }

  init_bootstrap_run_state || exit 1

  notify 'AUTHORIZE & DETECT 1PASSWORD'
  bootstrap_needs_sudo && authorize
  use_op

  if [[ -n ${BOOTSTRAP_ONLY_TARGETS:-} ]]; then
    run_bootstrap_target_selection || true
  else
    run_all_bootstrap_targets
  fi

  run 'touch ~/.hushlogin' && logg -i 'Ensured ~/.hushlogin exists'
  run "rmdir \"$XDG_CONFIG_HOME/homebrew\" 2>/dev/null || true"

  finish_bootstrap
}

main "$@"
