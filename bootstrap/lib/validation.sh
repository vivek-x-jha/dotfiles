# shellcheck shell=bash
# shellcheck disable=SC2034
check_bootstrap() {
  local status=0
  local bootstrap_path="${BOOTSTRAP_ENTRYPOINT:-$HOME/.dotfiles/bootstrap.sh}"
  local path=''

  notify 'CHECK BOOTSTRAP'

  check_path() {
    local target="$1"
    [[ -e $target ]] && {
      logg -i "ok: $(pretty_path "$target")"
      return
    }

    logg -e "missing: $(pretty_path "$target")"
    status=1
  }

  check_cmd() {
    local label="$1"
    shift

    if "$@"; then
      logg -i "ok: $label"
    else
      logg -e "failed: $label"
      status=1
    fi
  }

  check_cmd 'bootstrap shell syntax' bash -n "$bootstrap_path"

  while IFS= read -r path; do
    check_cmd "bootstrap module syntax: $(pretty_path "$path")" bash -n "$path"
  done < <(find "$HOME/.dotfiles/bootstrap" -type f \( -name '*.sh' -o -name '*.env' \) -print | sort)

  while IFS= read -r path; do
    check_cmd "bash syntax: $(pretty_path "$path")" bash -n "$path"
  done < <(find "$HOME/.dotfiles/shells/bash/funcs" -maxdepth 1 -type f -print | sort)

  while IFS= read -r path; do
    check_cmd "zsh syntax: $(pretty_path "$path")" zsh -n "$path"
  done < <(find "$HOME/.dotfiles/shells/zsh/funcs" -maxdepth 1 -type f -print | sort)

  check_cmd 'zsh profile syntax' zsh -n "$HOME/.dotfiles/shells/zsh/.zprofile"
  check_cmd 'zshrc syntax' zsh -n "$HOME/.dotfiles/shells/zsh/.zshrc"
  check_cmd 'bash profile syntax' bash -n "$HOME/.dotfiles/shells/bash/.bash_profile"
  check_cmd 'bashrc syntax' bash -n "$HOME/.dotfiles/shells/bash/.bashrc"
  check_cmd 'shared profile syntax' bash -n "$HOME/.dotfiles/shells/profile"

  check_path "$HOME/.dotfiles/manifests/Brewfile"
  check_path "$HOME/.dotfiles/manifests/apt-packages.txt"
  check_path "$HOME/.dotfiles/manifests/dnf-packages.txt"
  check_path "$HOME/.dotfiles/bootstrap/config/defaults.env"
  check_path "$HOME/.dotfiles/bootstrap/lib/core.sh"
  check_path "$HOME/.dotfiles/bootstrap/lib/environment.sh"
  check_path "$HOME/.dotfiles/bootstrap/lib/extras.sh"
  check_path "$HOME/.dotfiles/bootstrap/lib/orchestrator.sh"
  check_path "$HOME/.dotfiles/bootstrap/lib/packages.sh"
  check_path "$HOME/.dotfiles/bootstrap/lib/platform.sh"
  check_path "$HOME/.dotfiles/bootstrap/lib/tooling.sh"
  check_path "$HOME/.dotfiles/bootstrap/lib/validation.sh"
  check_path "$HOME/.dotfiles/shells/env"
  check_path "$HOME/.dotfiles/shells/starship.toml"
  check_path "$HOME/.dotfiles/cli/fzf/fzf.sh"
  check_path "$HOME/.dotfiles/auth/git/themes/sourdiesel"
  check_path "$HOME/.dotfiles/cli/matplotlib/matplotlibrc"
  check_path "$HOME/.dotfiles/cli/npm/npmrc"
  check_path "$HOME/.dotfiles/ai/codex/scripts/apply_preferences.py"
  check_path "$HOME/.dotfiles/ai/codex/themes/sourdiesel.toml"
  check_path "$HOME/.dotfiles/editors/nvim/init.lua"
  check_path "$HOME/.dotfiles/editors/vscode/settings.json"
  check_path "$HOME/.dotfiles/terminals/tmux/tmux.conf"

  if command -v shellcheck &>/dev/null; then
    local shellcheck_paths=("$bootstrap_path")
    while IFS= read -r path; do
      shellcheck_paths+=("$path")
    done < <(find "$HOME/.dotfiles/bootstrap" -type f \( -name '*.sh' -o -name '*.env' \) -print | sort)

    check_cmd 'shellcheck bootstrap' shellcheck "${shellcheck_paths[@]}"
  else
    logg -w 'shellcheck unavailable; skipping shellcheck validation.'
  fi

  return "$status"
}

doctor_bootstrap() {
  local status=0
  local expected=''
  local actual=''

  notify 'DOCTOR BOOTSTRAP'

  doctor_ok() {
    logg -i "ok: $*"
  }

  doctor_warn() {
    logg -w "$*"
  }

  doctor_fail() {
    logg -e "failed: $*"
    status=1
  }

  doctor_dir() {
    local target="$1"
    [[ -d $target ]] && doctor_ok "dir: $(pretty_path "$target")" && return
    doctor_fail "missing dir: $(pretty_path "$target")"
  }

  doctor_file() {
    local target="$1"
    [[ -f $target ]] && doctor_ok "file: $(pretty_path "$target")" && return
    doctor_fail "missing file: $(pretty_path "$target")"
  }

  doctor_cmd() {
    local bin="$1"
    local required="${2:-required}"

    if command -v "$bin" &>/dev/null; then
      doctor_ok "command: $bin"
      return
    fi

    [[ $required == required ]] && doctor_fail "missing command: $bin" && return
    doctor_warn "optional command unavailable: $bin"
  }

  doctor_symlink() {
    local link="$1"
    local target="$2"
    local required="${3:-required}"
    local actual_real=''
    local target_real=''

    if [[ ! -L $link ]]; then
      [[ $required == required ]] && doctor_fail "missing symlink: $(pretty_path "$link")" && return
      doctor_warn "optional symlink missing: $(pretty_path "$link")"
      return
    fi

    actual=$(readlink "$link") || {
      doctor_fail "unreadable symlink: $(pretty_path "$link")"
      return
    }
    actual="${actual%/}"

    if [[ $actual == "$target" ]]; then
      doctor_ok "symlink: $(pretty_path "$link") -> $target"
      return
    fi

    if command -v realpath &>/dev/null; then
      actual_real=$(realpath "$link" 2>/dev/null || true)
      target_real=$(cd "$(dirname "$link")" && realpath "$target" 2>/dev/null || true)

      if [[ -n $actual_real && $actual_real == "$target_real" ]]; then
        doctor_ok "symlink: $(pretty_path "$link") -> $target"
        return
      fi
    fi

    [[ $required == required ]] && doctor_fail "symlink target mismatch: $(pretty_path "$link") -> $actual (expected $target)" && return
    doctor_warn "optional symlink target mismatch: $(pretty_path "$link") -> $actual (expected $target)"
  }

  doctor_run() {
    local label="$1"
    shift

    if "$@" &>/dev/null; then
      doctor_ok "$label"
      return
    fi

    doctor_warn "$label unavailable"
  }

  logg -i "XDG_CONFIG_HOME=$(pretty_path "$XDG_CONFIG_HOME")"
  logg -i "XDG_CACHE_HOME=$(pretty_path "$XDG_CACHE_HOME")"
  logg -i "XDG_DATA_HOME=$(pretty_path "$XDG_DATA_HOME")"
  logg -i "XDG_STATE_HOME=$(pretty_path "$XDG_STATE_HOME")"

  doctor_dir "$XDG_CONFIG_HOME"
  doctor_dir "$XDG_CACHE_HOME"
  doctor_dir "$XDG_DATA_HOME"
  doctor_dir "$XDG_STATE_HOME"
  doctor_dir "$XDG_CACHE_HOME/npm"
  doctor_dir "$XDG_STATE_HOME/bash"
  doctor_dir "$XDG_STATE_HOME/codex"
  doctor_dir "$XDG_STATE_HOME/jupyter/runtime"
  doctor_dir "$XDG_STATE_HOME/less"
  doctor_dir "$XDG_STATE_HOME/mycli"
  doctor_dir "$XDG_STATE_HOME/mysql"
  doctor_dir "$XDG_STATE_HOME/python"
  doctor_dir "$XDG_STATE_HOME/ipython"
  doctor_dir "$XDG_STATE_HOME/zsh"
  doctor_dir "$XDG_CONFIG_HOME/claude"
  doctor_dir "$XDG_CONFIG_HOME/jupyter"
  doctor_dir "$XDG_CONFIG_HOME/npm"
  doctor_dir "$XDG_DATA_HOME/jupyter"
  doctor_dir "$XDG_DATA_HOME/zsh"
  doctor_dir "$XDG_DATA_HOME/vscode"
  doctor_file "$XDG_STATE_HOME/codex/config.toml"

  doctor_symlink "$XDG_CONFIG_HOME/atuin" ../.dotfiles/cli/atuin
  doctor_symlink "$XDG_CONFIG_HOME/bat" ../.dotfiles/cli/bat
  doctor_symlink "$XDG_CONFIG_HOME/btop" ../.dotfiles/cli/btop
  doctor_symlink "$XDG_CONFIG_HOME/dust" ../.dotfiles/cli/dust
  doctor_symlink "$XDG_CONFIG_HOME/eza" ../.dotfiles/cli/eza
  doctor_symlink "$XDG_CONFIG_HOME/fzf" ../.dotfiles/cli/fzf
  doctor_symlink "$XDG_CONFIG_HOME/gh" ../.dotfiles/cli/gh
  doctor_symlink "$XDG_CONFIG_HOME/git" ../.dotfiles/auth/git
  doctor_symlink "$XDG_CONFIG_HOME/glow" ../.dotfiles/cli/glow
  doctor_symlink "$XDG_CONFIG_HOME/mycli" ../.dotfiles/cli/mycli
  doctor_symlink "$XDG_CONFIG_HOME/nvim" ../.dotfiles/editors/nvim
  doctor_symlink "$XDG_CONFIG_HOME/shells" ../.dotfiles/shells
  doctor_symlink "$XDG_CONFIG_HOME/ssh" ../.dotfiles/auth/ssh
  doctor_symlink "$XDG_CONFIG_HOME/tmux" ../.dotfiles/terminals/tmux
  doctor_symlink "$XDG_CONFIG_HOME/wezterm" ../.dotfiles/terminals/wezterm
  doctor_symlink "$XDG_CONFIG_HOME/claude/settings.json" ../../.dotfiles/ai/claude/settings.json
  doctor_symlink "$XDG_CONFIG_HOME/starship.toml" shells/starship.toml
  doctor_symlink "$HOME/.vscode" .local/share/vscode
  doctor_symlink "$HOME/.bash_profile" .config/shells/bash/.bash_profile
  doctor_symlink "$HOME/.bashrc" .config/shells/bash/.bashrc
  doctor_symlink "$HOME/.zshenv" .config/shells/env

  if [[ $OS_TYPE == macos ]]; then
    doctor_symlink "$XDG_CONFIG_HOME/hammerspoon" ../.dotfiles/apps/hammerspoon optional
    doctor_symlink "$XDG_CONFIG_HOME/karabiner" ../.dotfiles/apps/karabiner optional
    doctor_symlink "$HOME/Library/Application Support/eza" ../../.dotfiles/cli/eza optional
    doctor_symlink "$HOME/Library/Application Support/Code/User/settings.json" ../../../../.dotfiles/editors/vscode/settings.json optional
  else
    doctor_symlink "$XDG_CONFIG_HOME/Code/User/settings.json" ../../../.dotfiles/editors/vscode/settings.json optional
  fi

  if ((FORCE_1PASSWORD)); then
    doctor_cmd op required
    doctor_symlink "$XDG_CONFIG_HOME/1Password" ../.dotfiles/auth/1Password
  else
    doctor_cmd op optional
    doctor_symlink "$XDG_CONFIG_HOME/1Password" ../.dotfiles/auth/1Password optional
  fi

  doctor_cmd git
  doctor_cmd bash
  doctor_cmd zsh
  doctor_cmd "$PKG_MGR"
  doctor_cmd eza optional
  doctor_cmd fzf optional
  doctor_cmd rg optional
  doctor_cmd atuin optional
  doctor_cmd bat optional
  doctor_cmd tmux optional
  doctor_cmd nvim optional
  doctor_cmd uv optional
  doctor_cmd cargo optional

  doctor_file "$XDG_CONFIG_HOME/atuin/config.toml"
  doctor_file "$XDG_CONFIG_HOME/git/themes/sourdiesel"
  command -v atuin &>/dev/null && {
    doctor_run 'atuin info' atuin info
    doctor_run 'atuin status' atuin status
  }

  expected=$(git config --global user.name || true)
  if [[ -n $expected ]]; then
    doctor_ok 'git global user.name set'
  else
    doctor_fail 'git global user.name unset'
  fi

  expected=$(git config --global user.email || true)
  if [[ -n $expected ]]; then
    doctor_ok 'git global user.email set'
  else
    doctor_fail 'git global user.email unset'
  fi

  expected=$(git -C "$HOME/.dotfiles" remote get-url origin 2>/dev/null || true)
  if [[ -n $expected ]]; then
    doctor_ok "dotfiles origin: $expected"
  else
    doctor_fail 'dotfiles origin remote missing'
  fi

  return "$status"
}
