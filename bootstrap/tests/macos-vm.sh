#!/usr/bin/env bash
# Destructive end-to-end validation for a disposable Apple Silicon macOS VM.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONFIG="$ROOT/bootstrap/tests/macos-vm.env"
STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
LOG_DIR="$STATE_HOME/dotfiles/vm-validation"

[[ $(uname -s) == Darwin ]] || {
  printf 'error: macOS is required\n' >&2
  exit 1
}
[[ $(uname -m) == arm64 ]] || {
  printf 'error: an Apple Silicon (arm64) VM is required\n' >&2
  exit 1
}
[[ ${BOOTSTRAP_ALLOW_VM_INSTALL:-0} == 1 ]] || {
  printf 'error: this installs packages and changes macOS settings. Run only in a disposable VM with:\n' >&2
  printf '  BOOTSTRAP_ALLOW_VM_INSTALL=1 %s\n' "$0" >&2
  exit 1
}
[[ ! -e $STATE_HOME/dotfiles/bootstrap-complete ]] || {
  printf 'error: bootstrap completion state already exists; use a clean disposable VM account\n' >&2
  exit 1
}
xcode-select -p >/dev/null 2>&1 || {
  printf 'error: finish xcode-select --install before running this harness\n' >&2
  exit 1
}

mkdir -p "$LOG_DIR"
{
  sw_vers
  uname -m
  xcode-select -p
} | tee "$LOG_DIR/environment.log"
printf 'Running first complete core bootstrap...\n'
SECONDS=0
"$ROOT/bootstrap.sh" --fresh --config "$CONFIG" 2>&1 | tee "$LOG_DIR/first-run.log"
printf 'first_run_seconds=%s\n' "$SECONDS" | tee "$LOG_DIR/timings.txt"

printf 'Running convergence bootstrap...\n'
SECONDS=0
"$ROOT/bootstrap.sh" --partial --config "$CONFIG" 2>&1 | tee "$LOG_DIR/second-run.log"
printf 'second_run_seconds=%s\n' "$SECONDS" | tee -a "$LOG_DIR/timings.txt"

"$ROOT/bootstrap.sh" --doctor 2>&1 | tee "$LOG_DIR/doctor.log"
printf 'ok: complete run, convergence rerun, and doctor passed on Apple Silicon macOS\n'
