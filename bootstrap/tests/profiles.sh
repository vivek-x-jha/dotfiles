#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2034
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BOOTSTRAP_ROOT="$ROOT"
XDG_CONFIG_HOME="${TMPDIR:-/tmp}/dotfiles-profile-test-config"
FORCE_1PASSWORD=0
BOOTSTRAP_FAILURES=0
DRY_RUN=0

# shellcheck source=../lib/core.sh
source "$ROOT/bootstrap/lib/core.sh"
# shellcheck source=../lib/packages.sh
source "$ROOT/bootstrap/lib/packages.sh"
# shellcheck source=../defaults.env
source "$ROOT/bootstrap/defaults.env"

# Profile composition is tested independently from this personal repo's enabled phases.
BOOTSTRAP_INSTALL_RUST_TOOLING=0
BOOTSTRAP_SETUP_IDE=0

assert_contains() {
  grep -Fq "$2" "$1" || {
    printf 'missing from %s: %s\n' "$1" "$2" >&2
    exit 1
  }
}

assert_not_contains() {
  if grep -Fq "$2" "$1"; then
    printf 'unexpected in %s: %s\n' "$1" "$2" >&2
    exit 1
  fi
}

build_profile() {
  BOOTSTRAP_EFFECTIVE_BREW_PROFILE="$1"
  prepare_brew_profile_file
}

core_file="$(build_profile core)"
assert_contains "$core_file" 'brew "bat"'
assert_contains "$core_file" 'cask "wezterm"'
assert_not_contains "$core_file" 'brew "node"'
assert_not_contains "$core_file" 'cask "visual-studio-code"'

developer_file="$(build_profile developer)"
assert_contains "$developer_file" 'brew "node"'
assert_not_contains "$developer_file" 'brew "cargo-binstall"'
assert_contains "$developer_file" 'cask "visual-studio-code"'
assert_not_contains "$developer_file" 'cask "spotify"'

personal_file="$(build_profile personal)"
assert_contains "$personal_file" 'cask "spotify"'
assert_contains "$personal_file" 'brew "node"'

BOOTSTRAP_ONLY_TARGETS=ide
BOOTSTRAP_INSTALL_RUST_TOOLING=1
rust_file="$(build_profile developer)"
assert_contains "$rust_file" 'brew "cargo-binstall"'
BOOTSTRAP_ONLY_TARGETS=''
BOOTSTRAP_INSTALL_RUST_TOOLING=0

FORCE_1PASSWORD=1
onepassword_file="$(build_profile core)"
assert_contains "$onepassword_file" 'cask "1password"'
assert_contains "$onepassword_file" 'cask "1password-cli"'

rm -f "$core_file" "$developer_file" "$personal_file" "$rust_file" "$onepassword_file"
printf 'ok: cumulative Homebrew profiles\n'
