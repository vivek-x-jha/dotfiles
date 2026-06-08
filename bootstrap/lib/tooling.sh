# shellcheck shell=bash
# shellcheck disable=SC2034
install_rust_tooling() {
  export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
  export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"
  export PATH="$CARGO_HOME/bin:$PATH"

  # Install toolchain manager + pkg manager
  require rustup || run "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path"

  # Ensure toolchain manager + pkg manager installed properly
  require rustup || return
  require cargo || return

  # Install language server
  run 'rustup component add rust-analyzer' || logg -w 'rust-analyzer component not installed'

  # Cargo managed packages
  local crates=(
    atuin
    bat
    bob-nvim
    cargo-update
    dust
    eza
    fd-find
    rainfrog
    ripgrep
    starship
    stylua
    tealdeer
    tokei
    uv
    zoxide
    zsh-patina
  )

  # Install all packages
  for crate in "${crates[@]}"; do
    run "cargo install --locked $crate" || logg -w "cargo install failed for $crate"
  done
}

setup_ide() {
  # Install and configure Neovim version manager
  require bob || return

  # Install current stable + nightly Neovim builds
  run 'bob install stable'
  run 'bob install nightly'
  run 'bob use nightly'

  require nvim || return

  # Install Python tools
  require uv && {
    run 'uv tool install basedpyright'
    require basedpyright

    run 'uv tool install ruff'
    require ruff
  }
}
