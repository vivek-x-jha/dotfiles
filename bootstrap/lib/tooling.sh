# shellcheck shell=bash
# shellcheck disable=SC2034
cleanup_legacy_agent_tools() {
  local package path target

  if command -v cargo &>/dev/null; then
    for package in cia eza; do
      if cargo install --list 2>/dev/null | grep -q "^${package} v"; then
        run "cargo uninstall \"$package\"" || logg -w "Unable to uninstall legacy Cargo package: $package"
      fi
    done
  fi

  for path in \
    "$XDG_CONFIG_HOME/cia" \
    "$XDG_CONFIG_HOME/eza" \
    "$HOME/Library/Application Support/eza"; do
    [[ -L $path ]] || continue
    target=$(readlink "$path" 2>/dev/null || true)
    case "$target" in
    *dotfiles/cli/cia | *dotfiles/cli/eza)
      run "rm -f \"$path\"" || logg -w "Unable to remove legacy link: $(pretty_path "$path")"
      ;;
    esac
  done
}

install_herdr() {
  cleanup_legacy_agent_tools

  if command -v herdr &>/dev/null; then
    logg -i 'herdr already available; skipping install.'
    return 0
  fi

  require curl || return 1
  run_retry "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" \
    'curl -fsSL https://herdr.dev/install.sh | sh'
  ((DRY_RUN)) || require herdr
}

install_cargo_tool() {
  local crate="$1"
  local bin="$2"

  if command -v "$bin" &>/dev/null; then
    logg -i "$bin already available; skipping Cargo install."
    return 0
  fi

  if command -v cargo-binstall &>/dev/null; then
    if run_optional "cargo binstall --no-confirm \"$crate\""; then
      return 0
    fi
    logg -w "No usable prebuilt release for $crate; falling back to cargo install."
  fi

  run_retry "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" \
    "cargo install --locked \"$crate\""
}

install_rust_tooling() {
  export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
  export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"
  export PATH="$CARGO_HOME/bin:$PATH"

  require rustup || run_retry "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" \
    "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path"

  require rustup || return
  require cargo || return

  run_retry "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" \
    'rustup component add rust-analyzer rustfmt clippy' || logg -w 'Rust editor components not installed'

  # Prefer commands supplied by the developer Homebrew profile. Missing tools use
  # cargo-binstall when available and compile from source only as a fallback.
  local tools=(
    'atuin:atuin'
    'bat:bat'
    'bob-nvim:bob'
    'cargo-update:cargo-install-update'
    'du-dust:dust'
    'fd-find:fd'
    'rainfrog:rainfrog'
    'ripgrep:rg'
    'starship:starship'
    'stylua:stylua'
    'tealdeer:tldr'
    'tokei:tokei'
    'uv:uv'
    'zoxide:zoxide'
    'zsh-patina:zsh-patina'
  )
  local item crate bin

  for item in "${tools[@]}"; do
    crate=${item%%:*}
    bin=${item##*:}
    install_cargo_tool "$crate" "$bin" || logg -w "Cargo tool unavailable after install: $crate"
  done

  if ! command -v eva &>/dev/null; then
    run_retry "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" \
      'cargo install --locked --git https://github.com/vivek-x-jha/eva eva' \
      || logg -w 'cargo install failed for eva'
  fi

  require zsh-patina && run 'zsh-patina restart'
}

setup_ide() {
  if ((DRY_RUN)); then
    run_retry "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" 'bob install stable'
    if bootstrap_config_bool BOOTSTRAP_INSTALL_NVIM_NIGHTLY 0; then
      run_retry "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" 'bob install nightly'
      run 'bob use nightly'
    else
      run 'bob use stable'
    fi
    run_retry "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" \
      'uv tool install basedpyright'
    run_retry "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" \
      'uv tool install ruff'
    run_retry "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" \
      'npm install -g typescript typescript-language-server eslint prettier vscode-langservers-extracted'
    return 0
  fi

  require bob || return

  run_retry "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" 'bob install stable'
  if bootstrap_config_bool BOOTSTRAP_INSTALL_NVIM_NIGHTLY 0; then
    run_retry "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" 'bob install nightly'
    run 'bob use nightly'
  else
    run 'bob use stable'
  fi

  require nvim || return

  require uv || return
  command -v basedpyright &>/dev/null || run_retry \
    "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" \
    'uv tool install basedpyright'
  require basedpyright || return

  command -v ruff &>/dev/null || run_retry \
    "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" \
    'uv tool install ruff'
  require ruff || return

  require npm || return
  if ! command -v typescript-language-server &>/dev/null \
    || ! command -v vscode-eslint-language-server &>/dev/null \
    || ! command -v eslint &>/dev/null \
    || ! command -v prettier &>/dev/null; then
    run_retry "${BOOTSTRAP_RETRY_ATTEMPTS:-3}" "${BOOTSTRAP_RETRY_DELAY:-3}" \
      'npm install -g typescript typescript-language-server eslint prettier vscode-langservers-extracted'
  else
    logg -i 'Global TypeScript/JavaScript IDE tools already available.'
  fi
  require typescript-language-server || return
  require vscode-eslint-language-server || return
  require eslint || return
  require prettier || return
}
