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
TOTAL_STEPS=4

DRY_RUN=0
CHECK_MODE=0
DOCTOR_MODE=0
TUI_MODE=0
RESUME_MODE=0
BOOTSTRAP_FAILURES=0
BOOTSTRAP_RUN_ID="$(date '+%Y%m%d-%H%M%S')-$$"
BOOTSTRAP_STARTED_AT=$SECONDS
BOOTSTRAP_ACTIVE_RUN_ID="$BOOTSTRAP_RUN_ID"
BOOTSTRAP_RUN_STATE_DIR=''
BOOTSTRAP_TIMINGS=()
BOOTSTRAP_PLANNED_REPLACED_DIRS=()
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
BREWFILE_DEFAULT="$BOOTSTRAP_ROOT/manifests/Brewfile"
APT_MANIFEST_DEFAULT="$BOOTSTRAP_ROOT/manifests/apt-packages.txt"
DNF_MANIFEST_DEFAULT="$BOOTSTRAP_ROOT/manifests/dnf-packages.txt"
APT_MANIFEST_URL_DEFAULT="$GITHUB_RAW_BASE/manifests/apt-packages.txt"
DNF_MANIFEST_URL_DEFAULT="$GITHUB_RAW_BASE/manifests/dnf-packages.txt"

DEVELOPER_REPOS=(
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
  local progress=''

  case "$1" in
  -s) SUBSTEP=$((SUBSTEP + 1)) && minor=".$SUBSTEP" && shift ;;
  *) STEP=$((STEP + 1)) && SUBSTEP=0 ;;
  esac

  if [[ -n $minor ]]; then
    progress="${STEP}${minor}"
  else
    progress="$STEP/$TOTAL_STEPS"
  fi
  printf '\n%s\n' "${GREEN}${ICON} [$progress] $* ${ICON}${RESET}"
}

run() {
  local cmd="$1"
  local status=0

  ((DRY_RUN)) && logg -i "[dry-run] $cmd" && return 0

  eval "$cmd"
  status=$?
  if ((status != 0)); then
    BOOTSTRAP_FAILURES=$((BOOTSTRAP_FAILURES + 1))
    logg -e "Command failed with status $status (failure $BOOTSTRAP_FAILURES)."
  fi
  return "$status"
}

# Use only when failure is expected and explicitly handled by the caller.
run_optional() {
  local cmd="$1"

  ((DRY_RUN)) && logg -i "[dry-run] $cmd" && return 0
  eval "$cmd"
}

download_with_retry() {
  local url="$1"
  local destination="$2"
  local attempts="${3:-${BOOTSTRAP_RETRY_ATTEMPTS:-3}}"
  local delay="${4:-${BOOTSTRAP_RETRY_DELAY:-3}}"
  local attempt=1
  local wait="$delay"

  ((DRY_RUN)) && logg -i "[dry-run] curl -fsSL $url -o $destination" && return 0
  while ((attempt <= attempts)); do
    curl -fsSL "$url" -o "$destination" && return 0
    if ((attempt < attempts)); then
      logg -w "Download attempt $attempt/$attempts failed; retrying in ${wait}s: $url"
      sleep "$wait"
      wait=$((wait * 2))
    fi
    attempt=$((attempt + 1))
  done

  BOOTSTRAP_FAILURES=$((BOOTSTRAP_FAILURES + 1))
  logg -e "Download failed after $attempts attempt(s): $url"
  return 1
}

run_retry() {
  local attempts="${1:-${BOOTSTRAP_RETRY_ATTEMPTS:-3}}"
  local delay="${2:-${BOOTSTRAP_RETRY_DELAY:-3}}"
  local cmd="$3"
  local attempt=1
  local status=0
  local wait="$delay"

  ((DRY_RUN)) && logg -i "[dry-run] retry $attempts time(s): $cmd" && return 0
  while ((attempt <= attempts)); do
    eval "$cmd"
    status=$?
    ((status == 0)) && return 0
    if ((attempt < attempts)); then
      logg -w "Attempt $attempt/$attempts failed; retrying in ${wait}s."
      sleep "$wait"
      wait=$((wait * 2))
    fi
    attempt=$((attempt + 1))
  done

  BOOTSTRAP_FAILURES=$((BOOTSTRAP_FAILURES + 1))
  logg -e "Command failed after $attempts attempt(s) with status $status (failure $BOOTSTRAP_FAILURES)."
  return "$status"
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

bootstrap_realpath() {
  local path="$1"

  if command -v realpath &>/dev/null; then
    realpath "$path" 2>/dev/null
    return
  fi

  if command -v perl &>/dev/null; then
    perl -MCwd=realpath -e 'my $path = realpath($ARGV[0]); print $path if defined $path' "$path" 2>/dev/null
    return
  fi

  return 1
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

bootstrap_words_contain() {
  local needle="$1"
  local word=''
  shift

  while IFS= read -r word; do
    [[ $word == "$needle" ]] && return 0
  done < <(bootstrap_words "$*")
  return 1
}

bootstrap_brew_profile_rank() {
  case "$1" in
  core) printf '1' ;;
  developer) printf '2' ;;
  personal) printf '3' ;;
  *) return 1 ;;
  esac
}

require_bootstrap_brew_profile() {
  local required="$1"
  local configured="${BOOTSTRAP_EFFECTIVE_BREW_PROFILE:-${BOOTSTRAP_BREW_PROFILE:-core}}"
  local configured_rank required_rank

  configured_rank="$(bootstrap_brew_profile_rank "$configured")" || {
    logg -e "Unknown Homebrew profile: $configured"
    return 1
  }
  required_rank="$(bootstrap_brew_profile_rank "$required")" || return 1
  if ((configured_rank < required_rank)); then
    BOOTSTRAP_EFFECTIVE_BREW_PROFILE="$required"
    logg -i "Raised Homebrew profile from $configured to $required for selected dependencies."
  else
    BOOTSTRAP_EFFECTIVE_BREW_PROFILE="$configured"
  fi
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

init_tool_environment() {
  export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
  export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"
  export PATH="$HOME/.local/bin:$XDG_DATA_HOME/fzf/bin:$CARGO_HOME/bin:$XDG_DATA_HOME/bob/nvim-bin:$PATH"
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

resolve_bootstrap_profile() {
  [[ ${BOOTSTRAP_PROFILE:-auto} == auto ]] || return 0

  if [[ -f $XDG_STATE_HOME/dotfiles/bootstrap-complete ]] \
    || [[ -e $XDG_CONFIG_HOME/shells ]] \
    || command -v brew &>/dev/null; then
    BOOTSTRAP_PROFILE=partial
  else
    BOOTSTRAP_PROFILE=fresh
  fi
}

bootstrap_codex_skill_enabled() {
  case "$1" in
  build-clean-latex | generate-practice-sheet | manage-2fa | revise-practice-sheet)
    bootstrap_config_bool BOOTSTRAP_INSTALL_PERSONAL_AI_SKILLS 0
    ;;
  *) return 0 ;;
  esac
}

bootstrap_needs_sudo() {
  local target dependency var
  if [[ -n ${BOOTSTRAP_ONLY_TARGETS:-} ]]; then
    while IFS= read -r target; do
      [[ $(bootstrap_normalize_target "$target") == packages ]] && return 0
      while IFS= read -r dependency; do
        [[ $dependency == packages ]] && return 0
      done < <(bootstrap_target_dependencies "$target")
    done < <(bootstrap_words "$BOOTSTRAP_ONLY_TARGETS")
  fi

  bootstrap_config_bool BOOTSTRAP_INSTALL_PACKAGES 1 && return 0
  while IFS= read -r target; do
    var="$(bootstrap_target_var "$target")" || continue
    bootstrap_config_bool "$var" 0 || continue
    while IFS= read -r dependency; do
      [[ $dependency == packages ]] && return 0
    done < <(bootstrap_target_dependencies "$target")
  done < <(list_bootstrap_targets)
  bootstrap_config_bool BOOTSTRAP_CONFIGURE_SUDO_AUTH 0 && return 0
  bootstrap_config_bool BOOTSTRAP_CHANGE_SHELL 0 && return 0
  return 1
}

bootstrap_source_fingerprint() {
  local file
  {
    for file in \
      "$BOOTSTRAP_ROOT/bootstrap.sh" \
      "$BOOTSTRAP_ROOT/bootstrap/defaults.env" \
      "$BOOTSTRAP_ROOT"/bootstrap/lib/*.sh \
      "$BOOTSTRAP_ROOT"/manifests/Brewfile*; do
      [[ -f $file ]] && cksum "$file"
    done
  } | cksum | awk '{print $1 ":" $2}'
}

bootstrap_plan_signature() {
  local target var

  printf 'root=%s\n' "$BOOTSTRAP_ROOT"
  printf 'source=%s\n' "$(bootstrap_source_fingerprint)"
  printf 'brew_profile=%s\n' "${BOOTSTRAP_EFFECTIVE_BREW_PROFILE:-${BOOTSTRAP_BREW_PROFILE:-core}}"
  printf 'brewfile=%s\n' "${BOOTSTRAP_BREWFILE:-}"
  printf 'brew_cask_mode=%s\n' "${BOOTSTRAP_BREW_CASK_MODE:-all}"
  printf 'brew_casks=%s\n' "${BOOTSTRAP_BREW_CASKS:-}"
  printf 'onepassword=%s:%s\n' "${BOOTSTRAP_ENABLE_1PASSWORD:-0}" "$FORCE_1PASSWORD"
  printf 'nvim_nightly=%s\n' "${BOOTSTRAP_INSTALL_NVIM_NIGHTLY:-0}"
  printf 'only=%s\n' "${BOOTSTRAP_ONLY_TARGETS:-}"
  printf 'skip=%s\n' "${BOOTSTRAP_SKIP_TARGETS:-}"
  while IFS= read -r target; do
    var="$(bootstrap_target_var "$target")" || continue
    printf '%s=%s\n' "$var" "${!var:-0}"
  done < <(list_bootstrap_targets)
}

init_bootstrap_run_state() {
  local state_root="$XDG_STATE_HOME/dotfiles/runs"
  local last_incomplete="$XDG_STATE_HOME/dotfiles/last-incomplete"
  local saved_plan current_plan

  current_plan="$(bootstrap_plan_signature)"
  if ((RESUME_MODE)); then
    [[ -f $last_incomplete ]] || {
      logg -e "No incomplete bootstrap run is available to resume."
      return 1
    }
    BOOTSTRAP_ACTIVE_RUN_ID="$(<"$last_incomplete")"
    BOOTSTRAP_RUN_STATE_DIR="$state_root/$BOOTSTRAP_ACTIVE_RUN_ID"
    [[ -f $BOOTSTRAP_RUN_STATE_DIR/plan ]] || {
      logg -e "Resume metadata is missing for run $BOOTSTRAP_ACTIVE_RUN_ID."
      return 1
    }
    saved_plan="$(<"$BOOTSTRAP_RUN_STATE_DIR/plan")"
    [[ $saved_plan == "$current_plan" ]] || {
      logg -e 'The current bootstrap plan differs from the incomplete run; rerun without --resume.'
      return 1
    }
    logg -i "Resuming bootstrap run: $BOOTSTRAP_ACTIVE_RUN_ID"
    return 0
  fi

  BOOTSTRAP_RUN_STATE_DIR="$state_root/$BOOTSTRAP_ACTIVE_RUN_ID"
  ((DRY_RUN)) && return 0
  mkdir -p "$BOOTSTRAP_RUN_STATE_DIR/checkpoints" || return 1
  printf '%s\n' "$current_plan" >"$BOOTSTRAP_RUN_STATE_DIR/plan"
}

bootstrap_checkpoint_name() {
  printf '%s' "$1" | tr '[:upper:]-' '[:lower:]_'
}

bootstrap_checkpoint_complete() {
  local name
  ((RESUME_MODE)) || return 1
  name="$(bootstrap_checkpoint_name "$1")"
  [[ -f $BOOTSTRAP_RUN_STATE_DIR/checkpoints/$name.ok ]]
}

write_bootstrap_checkpoint() {
  local target="$1"
  local duration="$2"
  local name

  ((DRY_RUN)) && return 0
  name="$(bootstrap_checkpoint_name "$target")"
  mkdir -p "$BOOTSTRAP_RUN_STATE_DIR/checkpoints" || return 1
  printf 'completed_at=%s\nduration_seconds=%s\n' \
    "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$duration" \
    >"$BOOTSTRAP_RUN_STATE_DIR/checkpoints/$name.ok"
}

record_bootstrap_timing() {
  local target="$1"
  local duration="$2"
  local status="$3"

  BOOTSTRAP_TIMINGS+=("$target|$duration|$status")
  logg -i "Timing: $target ${duration}s ($status)"
}

show_bootstrap_timings() {
  local item target remainder duration status
  ((${#BOOTSTRAP_TIMINGS[@]})) || return 0

  logg -i 'Phase timing summary:'
  for item in "${BOOTSTRAP_TIMINGS[@]}"; do
    target=${item%%|*}
    remainder=${item#*|}
    duration=${remainder%%|*}
    status=${remainder##*|}
    printf '  %-18s %5ss  %s\n' "$target" "$duration" "$status"
  done
  printf '  %-18s %5ss  %s\n' total "$((SECONDS - BOOTSTRAP_STARTED_AT))" elapsed
}

finish_bootstrap() {
  show_bootstrap_timings
  if ((BOOTSTRAP_FAILURES > 0)); then
    if ((!DRY_RUN)); then
      mkdir -p "$XDG_STATE_HOME/dotfiles" || true
      printf '%s\n' "$BOOTSTRAP_ACTIVE_RUN_ID" >"$XDG_STATE_HOME/dotfiles/last-incomplete" || true
    fi
    printf '\n%s\n' "${MAGENTA}BOOTSTRAP INCOMPLETE${RESET}"
    if ((DRY_RUN)); then
      logg -e "$BOOTSTRAP_FAILURES planned operation(s) failed validation. Fix the plan and rerun the dry-run."
    else
      logg -e "$BOOTSTRAP_FAILURES operation(s) failed. Fix the cause, then run the same plan with --resume."
    fi
    return 1
  fi

  run "mkdir -p \"$XDG_STATE_HOME/dotfiles\"" || {
    logg -e 'Unable to write bootstrap completion state.'
    return 1
  }
  if ((!DRY_RUN)); then
    if ! printf '%s\n' "$BOOTSTRAP_ROOT" >"$XDG_STATE_HOME/dotfiles/root" \
      || ! printf 'completed_at=%s\nprofile=%s\nroot=%s\n' \
        "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "${BOOTSTRAP_PROFILE:-unknown}" "$BOOTSTRAP_ROOT" \
        >"$XDG_STATE_HOME/dotfiles/bootstrap-complete"; then
      logg -e 'Unable to record bootstrap completion state.'
      return 1
    fi
  fi

  if ((!DRY_RUN)) && [[ -f $XDG_STATE_HOME/dotfiles/last-incomplete ]] \
    && [[ $(<"$XDG_STATE_HOME/dotfiles/last-incomplete") == "$BOOTSTRAP_ACTIVE_RUN_ID" ]]; then
    rm -f "$XDG_STATE_HOME/dotfiles/last-incomplete"
  fi

  printf '\n%s\n' "${CYAN}BOOTSTRAP COMPLETE - HAPPY DEVELOPING!...${RESET}"
  logg -w 'RESTART YOUR TERMINAL WINDOW TO LOAD THE NEW CONFIGURATION'
  echo
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

resolve_bootstrap_dependency_plan() {
  BOOTSTRAP_EFFECTIVE_BREW_PROFILE="${BOOTSTRAP_BREW_PROFILE:-core}"
  bootstrap_brew_profile_rank "$BOOTSTRAP_EFFECTIVE_BREW_PROFILE" >/dev/null || {
    logg -e "Unknown Homebrew profile: $BOOTSTRAP_EFFECTIVE_BREW_PROFILE"
    exit 1
  }

  if bootstrap_config_bool BOOTSTRAP_SETUP_IDE 0 \
    || bootstrap_words_contain ide "${BOOTSTRAP_ONLY_TARGETS:-}" \
    || bootstrap_words_contain editor "${BOOTSTRAP_ONLY_TARGETS:-}"; then
    require_bootstrap_brew_profile developer || exit 1
    if ! bootstrap_words_contain rust "${BOOTSTRAP_SKIP_TARGETS:-}"; then
      BOOTSTRAP_INSTALL_RUST_TOOLING=1
    fi
  fi
}

show_bootstrap_plan() {
  local onepassword_note=''
  ((FORCE_1PASSWORD)) && onepassword_note=' (forced)'

  logg -i "Bootstrap profile: ${BOOTSTRAP_PROFILE:-default}"
  logg -i "Interactive prompts: ${BOOTSTRAP_INTERACTIVE:-0}"
  logg -i "Only targets: ${BOOTSTRAP_ONLY_TARGETS:-<none>}"
  logg -i "Skipped targets: ${BOOTSTRAP_SKIP_TARGETS:-<none>}"
  logg -i "1Password integration: ${BOOTSTRAP_ENABLE_1PASSWORD:-0}${onepassword_note}"
  logg -i "Homebrew profile: ${BOOTSTRAP_EFFECTIVE_BREW_PROFILE:-${BOOTSTRAP_BREW_PROFILE:-core}}"
  logg -i "Optional extras: repos=${BOOTSTRAP_CLONE_DEVELOPER_REPOS:-0}, templates=${BOOTSTRAP_INSTALL_TEMPLATES:-0}, atuin=${BOOTSTRAP_SETUP_ATUIN_SYNC:-0}, rust=${BOOTSTRAP_INSTALL_RUST_TOOLING:-0}, ide=${BOOTSTRAP_SETUP_IDE:-0}"
}
