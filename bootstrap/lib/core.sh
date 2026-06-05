# shellcheck shell=bash
# shellcheck disable=SC2034

GREEN=$'\e[0;32m'
YELLOW=$'\e[0;33m'
MAGENTA=$'\e[0;35m'
CYAN=$'\e[0;36m'
WHITE=$'\e[0;37m'
RESET=$'\e[0m'
ICON='󰓒'

STEP=0
SUBSTEP=0
TOTAL_STEPS=20

DRY_RUN=0
CHECK_MODE=0
DOCTOR_MODE=0
INTERACTIVE_OVERRIDE=0
BOOTSTRAP_PROFILE_OVERRIDE=''
BOOTSTRAP_ONLY_TARGETS_OVERRIDE=''
BOOTSTRAP_SKIP_TARGETS_OVERRIDE=''

USE_1PASSWORD=0
FORCE_1PASSWORD=0
KEEP_SUDO_PID=''

OS_TYPE=''
DISTRO=''
PKG_MGR=''
DNF_CMD=''

GITHUB_RAW_BASE='https://raw.githubusercontent.com/vivek-x-jha/dotfiles/refs/heads/main'
BREWFILE_DEFAULT="$HOME/.dotfiles/manifests/Brewfile"
APT_MANIFEST_DEFAULT="$HOME/.dotfiles/manifests/apt-packages.txt"
DNF_MANIFEST_DEFAULT="$HOME/.dotfiles/manifests/dnf-packages.txt"
APT_MANIFEST_URL_DEFAULT="$GITHUB_RAW_BASE/manifests/apt-packages.txt"
DNF_MANIFEST_URL_DEFAULT="$GITHUB_RAW_BASE/manifests/dnf-packages.txt"

DEVELOPER_REPOS=(
  vivek-x-jha/agent-smith
  vivek-x-jha/dcp
  vivek-x-jha/legacy-latex
  vivek-x-jha/notes
  vivek-x-jha/nvim-launcher
  vivek-x-jha/practice-sheets
  rasbt/LLMs-from-scratch
  vivek-x-jha/weather-tool
)

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

notify() {
  local minor=''

  case "$1" in
  -s) SUBSTEP=$((SUBSTEP + 1)) && minor=".$SUBSTEP" && shift ;;
  *) STEP=$((STEP + 1)) && SUBSTEP=0 ;;
  esac

  printf '\n%s\n' "${GREEN}${ICON} [${STEP}${minor}/${TOTAL_STEPS}] $* ${ICON}${RESET}"
}

run() {
  local cmd="$1"

  ((DRY_RUN)) && logg -i "[dry-run] $cmd" && return
  eval "$cmd"
}

require() {
  local bin="$1"

  command -v "$bin" &>/dev/null || {
    logg -w "$bin unavailable or not in PATH. Skipping..."
    return 1
  }
}

pretty_path() {
  local path="$1"

  [[ $path == "$HOME"* ]] && printf '~%s' "${path#"$HOME"}" && return
  printf '%s' "$path"
}

bootstrap_lower() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

bootstrap_bool() {
  case "$(bootstrap_lower "${1:-}")" in
  1 | true | yes | y | on) return 0 ;;
  *) return 1 ;;
  esac
}

bootstrap_config_bool() {
  local var="$1"
  local default="${2:-0}"
  local value="${!var:-$default}"

  bootstrap_bool "$value"
}

confirm() {
  local prompt="$1"
  local default="${2:-}"
  local suffix answer

  if ! bootstrap_config_bool BOOTSTRAP_INTERACTIVE 0; then
    case "$default" in
    y | Y)
      logg -i "$prompt: yes (configured default)"
      return 0
      ;;
    n | N | '')
      logg -i "$prompt: no (configured default)"
      return 1
      ;;
    esac
  fi

  case "$default" in
  y | Y) suffix=" [${CYAN}Y${RESET}/n]" ;;
  n | N) suffix=" [y/${CYAN}N${RESET}]" ;;
  *) suffix=' [y/n]' ;;
  esac

  while true; do
    read -rp ">>> $prompt$suffix: "
    answer=${REPLY:-$default}

    case "$(bootstrap_lower "$answer")" in
    y | yes) return 0 ;;
    n | no) return 1 ;;
    esac

    logg -w 'Invalid input - please answer: <y,yes,n,no>'
  done
}

confirm_config() {
  local var="$1"
  local prompt="$2"
  local default="${3:-N}"
  local configured="${!var:-}"

  if [[ -n $configured ]]; then
    default=N
    bootstrap_bool "$configured" && default=Y
  fi

  confirm "$prompt" "$default"
}

init_xdg() {
  export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
  export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
  export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
  export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
}

source_if_exists() {
  local path="$1"
  [[ -f $path ]] || return 1
  # shellcheck disable=SC1090
  source "$path"
}

load_bootstrap_config() {
  local default_config="$BOOTSTRAP_ROOT/bootstrap/defaults.env"
  local user_config="$XDG_CONFIG_HOME/dotfiles/bootstrap.env"

  source_if_exists "$default_config" || {
    logg -e "Bootstrap defaults missing: $(pretty_path "$default_config")"
    exit 1
  }

  source_if_exists "$user_config" && logg -i "Loaded user bootstrap config: $(pretty_path "$user_config")"
  if [[ -n ${BOOTSTRAP_CONFIG_PATH:-} ]]; then
    source_if_exists "$BOOTSTRAP_CONFIG_PATH" || {
      logg -e "Explicit bootstrap config missing: $(pretty_path "$BOOTSTRAP_CONFIG_PATH")"
      exit 1
    }
    logg -i "Loaded explicit bootstrap config: $(pretty_path "$BOOTSTRAP_CONFIG_PATH")"
  fi

  if ((INTERACTIVE_OVERRIDE)); then
    BOOTSTRAP_INTERACTIVE=1
  fi

  [[ -n $BOOTSTRAP_PROFILE_OVERRIDE ]] && BOOTSTRAP_PROFILE="$BOOTSTRAP_PROFILE_OVERRIDE"
  [[ -n $BOOTSTRAP_ONLY_TARGETS_OVERRIDE ]] && BOOTSTRAP_ONLY_TARGETS="$BOOTSTRAP_ONLY_TARGETS_OVERRIDE"
  [[ -n $BOOTSTRAP_SKIP_TARGETS_OVERRIDE ]] && BOOTSTRAP_SKIP_TARGETS="$BOOTSTRAP_SKIP_TARGETS_OVERRIDE"
}

bootstrap_words() {
  printf '%s\n' "$*" | tr ',' ' ' | tr -s '[:space:]' '\n' | sed '/^$/d'
}

bootstrap_target_var() {
  case "$1" in
  packages) printf 'BOOTSTRAP_INSTALL_PACKAGES' ;;
  fzf) printf 'BOOTSTRAP_INSTALL_FZF' ;;
  gh) printf 'BOOTSTRAP_INSTALL_GH' ;;
  glow) printf 'BOOTSTRAP_INSTALL_GLOW' ;;
  env | environment) printf 'BOOTSTRAP_COLLECT_ENVIRONMENT' ;;
  symlinks | links) printf 'BOOTSTRAP_CREATE_SYMLINKS' ;;
  codex) printf 'BOOTSTRAP_CONFIGURE_CODEX' ;;
  os | macos) printf 'BOOTSTRAP_CONFIGURE_OS' ;;
  git | github) printf 'BOOTSTRAP_CONFIGURE_GIT' ;;
  repos | developer-repos) printf 'BOOTSTRAP_CLONE_DEVELOPER_REPOS' ;;
  templates) printf 'BOOTSTRAP_INSTALL_TEMPLATES' ;;
  shell-plugins | plugins) printf 'BOOTSTRAP_INSTALL_SHELL_PLUGINS' ;;
  atuin) printf 'BOOTSTRAP_SETUP_ATUIN_SYNC' ;;
  bat | themes) printf 'BOOTSTRAP_LOAD_BAT_THEMES' ;;
  sudo | touchid) printf 'BOOTSTRAP_CONFIGURE_SUDO_AUTH' ;;
  shell) printf 'BOOTSTRAP_CHANGE_SHELL' ;;
  hammerspoon | desktop) printf 'BOOTSTRAP_CONFIGURE_HAMMERSPOON' ;;
  rust) printf 'BOOTSTRAP_INSTALL_RUST_TOOLING' ;;
  ide | editor) printf 'BOOTSTRAP_SETUP_IDE' ;;
  *) return 1 ;;
  esac
}

list_bootstrap_targets() {
  cat <<'TARGETS'
packages
fzf
gh
glow
env
symlinks
codex
os
git
repos
templates
shell-plugins
atuin
bat
sudo
shell
hammerspoon
rust
ide
TARGETS
}

set_all_bootstrap_targets() {
  local value="$1"
  local target var

  while IFS= read -r target; do
    var="$(bootstrap_target_var "$target")" || continue
    printf -v "$var" '%s' "$value"
  done < <(list_bootstrap_targets)
}

set_bootstrap_targets() {
  local value="$1"
  shift
  local target var

  while IFS= read -r target; do
    var="$(bootstrap_target_var "$target")" || {
      logg -e "Unknown bootstrap target: $target"
      logg -i 'Run ./bootstrap.sh --list-targets to see valid targets.'
      exit 1
    }
    printf -v "$var" '%s' "$value"
  done < <(bootstrap_words "$*")
}

apply_bootstrap_target_selection() {
  if [[ -n ${BOOTSTRAP_ONLY_TARGETS:-} ]]; then
    BOOTSTRAP_PROFILE="${BOOTSTRAP_PROFILE_OVERRIDE:-partial}"
    set_all_bootstrap_targets 0
    set_bootstrap_targets 1 "$BOOTSTRAP_ONLY_TARGETS"
  fi

  [[ -n ${BOOTSTRAP_SKIP_TARGETS:-} ]] && set_bootstrap_targets 0 "$BOOTSTRAP_SKIP_TARGETS"
}

run_configured_step() {
  local var="$1"
  local label="$2"
  shift 2

  if confirm_config "$var" "$label" 'Y'; then
    "$@"
    return
  fi

  logg -w "Skipping $label (${var}=0)"
}

show_bootstrap_plan() {
  local onepassword_note=''
  ((FORCE_1PASSWORD)) && onepassword_note=' (forced)'

  logg -i "Bootstrap profile: ${BOOTSTRAP_PROFILE:-default}"
  logg -i "Interactive prompts: ${BOOTSTRAP_INTERACTIVE:-0}"
  logg -i "Only targets: ${BOOTSTRAP_ONLY_TARGETS:-<none>}"
  logg -i "Skipped targets: ${BOOTSTRAP_SKIP_TARGETS:-<none>}"
  logg -i "1Password integration: ${BOOTSTRAP_ENABLE_1PASSWORD:-0}${onepassword_note}"
  logg -i "Optional extras: repos=${BOOTSTRAP_CLONE_DEVELOPER_REPOS:-0}, templates=${BOOTSTRAP_INSTALL_TEMPLATES:-0}, atuin=${BOOTSTRAP_SETUP_ATUIN_SYNC:-0}"
}
