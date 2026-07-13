# shellcheck shell=bash
# shellcheck disable=SC2034
detect_platform() {
  case "$(uname -s)" in
  Darwin)
    require xcode-select || exit 1
    xcode-select -p &>/dev/null || {
      logg -e "Apple Command Line Tools are not installed. Run 'xcode-select --install', finish the installer, and rerun bootstrap."
      exit 1
    }

    DISTRO=macOS
    OS_TYPE=macos
    PKG_MGR=brew
    if ! command -v brew &>/dev/null; then
      if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
      fi
    fi
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

    case "${ID_LIKE:-}${ID:-}" in
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

authorize() {
  require sudo || return

  run_optional 'sudo -v' || {
    logg -w 'Unable to refresh sudo credentials; privileged steps may prompt for password.'
    return
  }

  ((DRY_RUN)) && return

  {
    while true; do
      sleep 60
      sudo -n true || break
    done
  } &

  KEEP_SUDO_PID=$!
  trap '[[ -n ${KEEP_SUDO_PID:-} ]] && kill "$KEEP_SUDO_PID" 2>/dev/null' EXIT
}

use_op() {
  local op_available=0
  command -v op &>/dev/null && op_available=1

  USE_1PASSWORD=0
  ((FORCE_1PASSWORD)) && USE_1PASSWORD=1
  ((!USE_1PASSWORD && op_available)) && bootstrap_config_bool BOOTSTRAP_ENABLE_1PASSWORD 0 && USE_1PASSWORD=1
  ((!USE_1PASSWORD && op_available)) && bootstrap_config_bool BOOTSTRAP_INTERACTIVE 0 && confirm 'Enable 1Password CLI integrations' 'N' && USE_1PASSWORD=1
  ((USE_1PASSWORD && !op_available)) && logg -w '1Password CLI not detected. Skipping related steps.' && USE_1PASSWORD=0
}
