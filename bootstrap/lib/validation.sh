# shellcheck shell=bash
# shellcheck disable=SC2034
check_bootstrap() {
  local status=0
  local bootstrap_path="${BOOTSTRAP_ENTRYPOINT:-$BOOTSTRAP_ROOT/bootstrap.sh}"
  local path=''
  local skill_dir=''

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

  find_toml_python() {
    local candidate=''
    for candidate in python3 /opt/homebrew/bin/python3 /usr/local/bin/python3; do
      if command -v "$candidate" &>/dev/null \
        && "$candidate" -c 'import tomllib' &>/dev/null; then
        command -v "$candidate"
        return
      fi
    done

    command -v python3
  }

  check_symlink() {
    local link="$1"
    local target="$2"
    local actual=''

    if [[ -L $link ]]; then
      actual=$(readlink "$link")
      if [[ $actual == "$target" ]]; then
        logg -i "ok: $(pretty_path "$link") -> $target"
        return
      fi
    fi

    logg -e "invalid symlink: $(pretty_path "$link") -> ${actual:-<not a symlink>} (expected $target)"
    status=1
  }

  check_cmd 'bootstrap shell syntax' bash -n "$bootstrap_path"
  check_cmd 'one-shot installer shell syntax' sh -n "$BOOTSTRAP_ROOT/install.sh"

  while IFS= read -r path; do
    check_cmd "bootstrap module syntax: $(pretty_path "$path")" bash -n "$path"
  done < <(find "$BOOTSTRAP_ROOT/bootstrap" -type f \( -name '*.sh' -o -name '*.env' \) -print | sort)

  while IFS= read -r path; do
    check_cmd "bash syntax: $(pretty_path "$path")" bash -n "$path"
  done < <(find "$BOOTSTRAP_ROOT/shells/bash/funcs" -maxdepth 1 -type f -print | sort)

  while IFS= read -r path; do
    check_cmd "zsh syntax: $(pretty_path "$path")" zsh -n "$path"
  done < <(find "$BOOTSTRAP_ROOT/shells/zsh/funcs" -maxdepth 1 -type f -print | sort)

  check_symlink "$BOOTSTRAP_ROOT/shells/zsh/.zprofile" ../profile
  check_symlink "$BOOTSTRAP_ROOT/shells/zsh/.zshenv" ../env
  check_cmd 'zsh env syntax' zsh -n "$BOOTSTRAP_ROOT/shells/zsh/.zshenv"
  check_cmd 'zsh profile syntax' zsh -n "$BOOTSTRAP_ROOT/shells/zsh/.zprofile"
  check_cmd 'zshrc syntax' zsh -n "$BOOTSTRAP_ROOT/shells/zsh/.zshrc"
  check_cmd 'bash profile syntax' bash -n "$BOOTSTRAP_ROOT/shells/bash/.bash_profile"
  check_cmd 'bashrc syntax' bash -n "$BOOTSTRAP_ROOT/shells/bash/.bashrc"
  check_cmd 'shared profile syntax' bash -n "$BOOTSTRAP_ROOT/shells/profile"

  check_path "$BOOTSTRAP_ROOT/install.sh"
  check_path "$BOOTSTRAP_ROOT/manifests/Brewfile"
  check_path "$BOOTSTRAP_ROOT/manifests/Brewfile.developer"
  check_path "$BOOTSTRAP_ROOT/manifests/Brewfile.personal"
  check_path "$BOOTSTRAP_ROOT/manifests/Brewfile.rust"
  check_path "$BOOTSTRAP_ROOT/manifests/Brewfile.1password"
  check_path "$BOOTSTRAP_ROOT/manifests/apt-packages.txt"
  check_path "$BOOTSTRAP_ROOT/manifests/dnf-packages.txt"
  check_path "$BOOTSTRAP_ROOT/bootstrap/defaults.env"
  check_path "$BOOTSTRAP_ROOT/docs/known-issues.md"
  check_path "$BOOTSTRAP_ROOT/docs/agent-memory.md"
  check_path "$BOOTSTRAP_ROOT/bootstrap/lib/core.sh"
  check_path "$BOOTSTRAP_ROOT/bootstrap/lib/environment.sh"
  check_path "$BOOTSTRAP_ROOT/bootstrap/lib/extras.sh"
  check_path "$BOOTSTRAP_ROOT/bootstrap/lib/orchestrator.sh"
  check_path "$BOOTSTRAP_ROOT/bootstrap/lib/packages.sh"
  check_path "$BOOTSTRAP_ROOT/bootstrap/lib/platform.sh"
  check_path "$BOOTSTRAP_ROOT/bootstrap/lib/tooling.sh"
  check_path "$BOOTSTRAP_ROOT/bootstrap/lib/validation.sh"
  check_path "$BOOTSTRAP_ROOT/shells/env"
  check_path "$BOOTSTRAP_ROOT/shells/starship.toml"
  check_path "$BOOTSTRAP_ROOT/cli/fzf/config"
  check_path "$BOOTSTRAP_ROOT/ai/herdr/config.toml"
  check_path "$BOOTSTRAP_ROOT/ai/herdr/scripts/herdr-codex-title-watch"
  check_path "$BOOTSTRAP_ROOT/ai/pi/README.md"
  check_path "$BOOTSTRAP_ROOT/ai/pi/models.json"
  check_path "$BOOTSTRAP_ROOT/ai/pi/extensions/handoff-alias.ts"
  check_path "$BOOTSTRAP_ROOT/ai/pi/extensions/herdr-agent-state.ts"
  check_path "$BOOTSTRAP_ROOT/ai/pi/extensions/statusline.ts"
  check_path "$BOOTSTRAP_ROOT/ai/pi/extensions/thread-title.ts"
  check_path "$BOOTSTRAP_ROOT/ai/pi/extensions/tsconfig.json"
  check_path "$BOOTSTRAP_ROOT/ai/pi/skills/handoff/SKILL.md"
  check_path "$BOOTSTRAP_ROOT/ai/pi/themes/sourdiesel.json"
  check_path "$BOOTSTRAP_ROOT/auth/git/base"
  check_path "$BOOTSTRAP_ROOT/auth/git/themes/sourdiesel"
  check_path "$BOOTSTRAP_ROOT/auth/ssh/base"
  check_path "$BOOTSTRAP_ROOT/cli/matplotlib/matplotlibrc"
  check_path "$BOOTSTRAP_ROOT/cli/npm/npmrc"
  check_path "$BOOTSTRAP_ROOT/ai/AGENTS.md"
  check_path "$BOOTSTRAP_ROOT/ai/templates/AGENTS.md"
  check_path "$BOOTSTRAP_ROOT/ai/templates/known-issues.md"
  check_path "$BOOTSTRAP_ROOT/ai/templates/agent-memory.md"
  check_path "$BOOTSTRAP_ROOT/ai/claude-code/CLAUDE.md"
  check_path "$BOOTSTRAP_ROOT/ai/claude-code/settings.json"
  check_path "$BOOTSTRAP_ROOT/ai/codex/AGENTS.md"
  check_path "$BOOTSTRAP_ROOT/ai/codex/scripts/apply_preferences.py"
  check_path "$BOOTSTRAP_ROOT/ai/codex/config/preferences.toml"
  for skill_dir in "$BOOTSTRAP_ROOT/ai/codex/skills"/*; do
    [[ -d $skill_dir ]] || continue
    check_path "$skill_dir/SKILL.md"
    [[ -d $skill_dir/agents ]] && check_path "$skill_dir/agents/openai.yaml"
  done
  check_path "$BOOTSTRAP_ROOT/ai/codex/themes/sourdiesel.toml"
  check_path "$BOOTSTRAP_ROOT/themes/sourdiesel/palette.toml"
  check_path "$BOOTSTRAP_ROOT/themes/sourdiesel/README.md"
  check_path "$BOOTSTRAP_ROOT/themes/sourdiesel/tool.py"
  local toml_python
  toml_python="$(find_toml_python)"
  check_cmd 'SourDiesel color inventory' "$toml_python" "$BOOTSTRAP_ROOT/themes/sourdiesel/tool.py" check
  check_cmd 'SourDiesel color inventory tests' "$toml_python" -m unittest discover \
    -s "$BOOTSTRAP_ROOT/themes/sourdiesel" -p 'test_*.py'
  check_path "$BOOTSTRAP_ROOT/editors/nvim/init.lua"
  check_path "$BOOTSTRAP_ROOT/editors/vscode/settings.json"
  check_path "$BOOTSTRAP_ROOT/terminals/tmux/tmux.conf"
  check_cmd 'bootstrap idempotence fixtures' "$BOOTSTRAP_ROOT/bootstrap/tests/idempotence.sh"
  check_cmd 'Homebrew profile fixtures' "$BOOTSTRAP_ROOT/bootstrap/tests/profiles.sh"
  check_cmd 'dependency and checkpoint fixtures' "$BOOTSTRAP_ROOT/bootstrap/tests/dependencies.sh"
  check_cmd 'one-shot installer fixtures' "$BOOTSTRAP_ROOT/bootstrap/tests/install.sh"
  check_path "$BOOTSTRAP_ROOT/bootstrap/tests/macos-vm.sh"
  check_path "$BOOTSTRAP_ROOT/bootstrap/tests/macos-vm.env"

  if command -v shellcheck &>/dev/null; then
    local shellcheck_paths=("$bootstrap_path" "$BOOTSTRAP_ROOT/install.sh")
    while IFS= read -r path; do
      shellcheck_paths+=("$path")
    done < <(find "$BOOTSTRAP_ROOT/bootstrap" -type f \( -name '*.sh' -o -name '*.env' \) -print | sort)

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
  local skill_dir=''
  local skill_name=''

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

    case "$target" in
    *'.dotfiles/'*) target="$BOOTSTRAP_ROOT/${target#*.dotfiles/}" ;;
    esac

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
  doctor_dir "$XDG_STATE_HOME/pi/agent"
  doctor_dir "$XDG_STATE_HOME/pi/agent/extensions"
  doctor_dir "$XDG_STATE_HOME/pi/agent/themes"
  doctor_dir "$XDG_STATE_HOME/python"
  doctor_dir "$XDG_STATE_HOME/ipython"
  doctor_dir "$XDG_STATE_HOME/zsh"
  doctor_dir "$XDG_CONFIG_HOME/claude"
  doctor_dir "$XDG_CONFIG_HOME/herdr"
  doctor_dir "$XDG_CONFIG_HOME/jupyter"
  doctor_dir "$XDG_CONFIG_HOME/npm"
  doctor_dir "$XDG_DATA_HOME/jupyter"
  doctor_dir "$XDG_DATA_HOME/zsh"
  doctor_dir "$XDG_DATA_HOME/vscode"
  doctor_file "$XDG_STATE_HOME/codex/config.toml"
  doctor_symlink "$XDG_CONFIG_HOME/claude/CLAUDE.md" ../../.dotfiles/ai/AGENTS.md
  doctor_symlink "$XDG_STATE_HOME/codex/AGENTS.md" ../../../.dotfiles/ai/AGENTS.md
  doctor_symlink "$XDG_STATE_HOME/pi/agent/AGENTS.md" ../../../../.dotfiles/ai/AGENTS.md

  doctor_symlink "$XDG_CONFIG_HOME/atuin" ../.dotfiles/cli/atuin
  doctor_symlink "$XDG_CONFIG_HOME/bat" ../.dotfiles/cli/bat
  doctor_symlink "$XDG_CONFIG_HOME/btop" ../.dotfiles/cli/btop
  doctor_symlink "$XDG_CONFIG_HOME/herdr/config.toml" ../../.dotfiles/ai/herdr/config.toml
  doctor_symlink "$HOME/.local/bin/herdr-codex-title-watch" ../../.dotfiles/ai/herdr/scripts/herdr-codex-title-watch
  doctor_symlink "$XDG_CONFIG_HOME/dust" ../.dotfiles/cli/dust
  doctor_symlink "$XDG_CONFIG_HOME/eva" ../.dotfiles/cli/eva
  doctor_symlink "$XDG_CONFIG_HOME/fzf" ../.dotfiles/cli/fzf
  doctor_symlink "$XDG_CONFIG_HOME/gh" ../.dotfiles/cli/gh
  if [[ -L $XDG_CONFIG_HOME/git ]] \
    && [[ $(bootstrap_realpath "$XDG_CONFIG_HOME/git" || true) == "$BOOTSTRAP_ROOT/auth/git" ]]; then
    doctor_warn 'legacy Git directory symlink detected; the next symlink/bootstrap run will migrate it safely'
  else
    doctor_dir "$XDG_CONFIG_HOME/git"
    doctor_file "$XDG_CONFIG_HOME/git/config"
    doctor_symlink "$XDG_CONFIG_HOME/git/themes/sourdiesel" "$BOOTSTRAP_ROOT/auth/git/themes/sourdiesel"
  fi
  doctor_symlink "$XDG_CONFIG_HOME/glow" ../.dotfiles/cli/glow
  doctor_symlink "$XDG_CONFIG_HOME/mycli" ../.dotfiles/cli/mycli
  doctor_symlink "$XDG_STATE_HOME/pi/agent/models.json" ../../../../.dotfiles/ai/pi/models.json
  doctor_symlink "$XDG_STATE_HOME/pi/agent/extensions/handoff-alias.ts" ../../../../../.dotfiles/ai/pi/extensions/handoff-alias.ts
  doctor_symlink "$XDG_STATE_HOME/pi/agent/extensions/herdr-agent-state.ts" ../../../../../.dotfiles/ai/pi/extensions/herdr-agent-state.ts
  doctor_symlink "$XDG_STATE_HOME/pi/agent/extensions/statusline.ts" ../../../../../.dotfiles/ai/pi/extensions/statusline.ts
  doctor_symlink "$XDG_STATE_HOME/pi/agent/extensions/thread-title.ts" ../../../../../.dotfiles/ai/pi/extensions/thread-title.ts
  doctor_symlink "$XDG_STATE_HOME/pi/agent/extensions/tsconfig.json" ../../../../../.dotfiles/ai/pi/extensions/tsconfig.json
  doctor_symlink "$XDG_STATE_HOME/pi/agent/skills/handoff" ../../../../../.dotfiles/ai/pi/skills/handoff
  doctor_symlink "$XDG_STATE_HOME/pi/agent/themes/sourdiesel.json" ../../../../../.dotfiles/ai/pi/themes/sourdiesel.json
  doctor_symlink "$XDG_CONFIG_HOME/nvim" ../.dotfiles/editors/nvim
  doctor_symlink "$XDG_CONFIG_HOME/shells" ../.dotfiles/shells
  doctor_symlink "$XDG_CONFIG_HOME/shells/zsh/.zshenv" ../env
  doctor_symlink "$XDG_CONFIG_HOME/shells/zsh/.zprofile" ../profile
  if [[ -L $XDG_CONFIG_HOME/ssh ]] \
    && [[ $(bootstrap_realpath "$XDG_CONFIG_HOME/ssh" || true) == "$BOOTSTRAP_ROOT/auth/ssh" ]]; then
    doctor_warn 'legacy SSH directory symlink detected; the next symlink/bootstrap run will migrate it safely'
  else
    doctor_dir "$XDG_CONFIG_HOME/ssh"
    doctor_file "$XDG_CONFIG_HOME/ssh/config"
    if grep -Fxq "Include \"$BOOTSTRAP_ROOT/auth/ssh/base\"" "$XDG_CONFIG_HOME/ssh/config" 2>/dev/null; then
      doctor_ok 'SSH config includes portable dotfiles defaults'
    else
      doctor_fail 'SSH config is missing the portable dotfiles include'
    fi
    doctor_file "$XDG_CONFIG_HOME/ssh/known_hosts"
  fi
  doctor_symlink "$XDG_CONFIG_HOME/tmux" ../.dotfiles/terminals/tmux
  doctor_symlink "$XDG_CONFIG_HOME/wezterm" ../.dotfiles/terminals/wezterm
  doctor_symlink "$XDG_CONFIG_HOME/claude/settings.json" ../../.dotfiles/ai/claude-code/settings.json
  for skill_dir in "$BOOTSTRAP_ROOT/ai/codex/skills"/*; do
    [[ -d $skill_dir && -f $skill_dir/SKILL.md ]] || continue
    skill_name="${skill_dir##*/}"
    bootstrap_codex_skill_enabled "$skill_name" || continue
    doctor_symlink \
      "$XDG_STATE_HOME/codex/skills/$skill_name" \
      "../../../../.dotfiles/ai/codex/skills/$skill_name"
  done
  doctor_symlink "$XDG_CONFIG_HOME/starship.toml" shells/starship.toml
  doctor_symlink "$HOME/.vscode" .local/share/vscode
  doctor_symlink "$HOME/.bash_profile" .config/shells/bash/.bash_profile
  doctor_symlink "$HOME/.bashrc" .config/shells/bash/.bashrc
  doctor_symlink "$HOME/.zshenv" .config/shells/env

  if [[ $OS_TYPE == macos ]]; then
    doctor_symlink "$XDG_CONFIG_HOME/hammerspoon" ../.dotfiles/apps/hammerspoon optional
    doctor_symlink "$XDG_CONFIG_HOME/karabiner" ../.dotfiles/apps/karabiner optional
    doctor_symlink "$HOME/Library/Application Support/Code/User/settings.json" ../../../../.dotfiles/editors/vscode/settings.json optional
  else
    doctor_symlink "$XDG_CONFIG_HOME/Code/User/settings.json" ../../../.dotfiles/editors/vscode/settings.json optional
  fi

  if ((FORCE_1PASSWORD)); then
    doctor_cmd op required
    doctor_dir "$XDG_CONFIG_HOME/1Password/ssh"
    doctor_file "$XDG_CONFIG_HOME/1Password/ssh/agent.toml"
    doctor_symlink "$XDG_CONFIG_HOME/ssh/identity.conf" "$BOOTSTRAP_ROOT/auth/ssh/identities/1password"
  else
    doctor_cmd op optional
    [[ -e $XDG_CONFIG_HOME/1Password/ssh/agent.toml ]] \
      && doctor_file "$XDG_CONFIG_HOME/1Password/ssh/agent.toml"
  fi

  doctor_cmd git
  doctor_cmd bash
  doctor_cmd zsh
  doctor_cmd "$PKG_MGR"
  doctor_cmd eva optional
  doctor_cmd fzf optional
  doctor_cmd rg optional
  doctor_cmd atuin optional
  doctor_cmd bat optional
  doctor_cmd herdr
  doctor_cmd tmux optional
  doctor_cmd nvim optional
  doctor_cmd ollama optional
  doctor_cmd uv optional
  doctor_cmd cargo optional

  doctor_file "$XDG_CONFIG_HOME/atuin/config.toml"
  doctor_symlink "$XDG_CONFIG_HOME/zsh-patina" ../.dotfiles/cli/zsh-patina
  doctor_file "$XDG_CONFIG_HOME/zsh-patina/config.toml"
  doctor_file "$XDG_CONFIG_HOME/git/themes/sourdiesel"
  command -v atuin &>/dev/null && {
    doctor_run 'atuin info' atuin info
    doctor_run 'atuin status' atuin status
  }

  expected=$(git config --global user.name || true)
  if [[ -n $expected ]]; then
    doctor_ok 'git global user.name set'
  else
    doctor_warn 'git global user.name unset (set it in bootstrap.env or use --interactive)'
  fi

  expected=$(git config --global user.email || true)
  if [[ -n $expected ]]; then
    doctor_ok 'git global user.email set'
  else
    doctor_warn 'git global user.email unset (set it in bootstrap.env or use --interactive)'
  fi

  expected=$(git -C "$BOOTSTRAP_ROOT" remote get-url origin 2>/dev/null || true)
  if [[ -n $expected ]]; then
    doctor_ok "dotfiles origin: $expected"
  else
    doctor_fail 'dotfiles origin remote missing'
  fi

  return "$status"
}
