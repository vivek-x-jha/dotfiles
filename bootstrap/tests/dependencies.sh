#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2034
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FIXTURE="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-dependencies.XXXXXX")"
trap 'rm -rf "$FIXTURE"' EXIT

export HOME="$FIXTURE/home"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
mkdir -p "$HOME"

BOOTSTRAP_ROOT="$ROOT"
BOOTSTRAP_ENTRYPOINT="$ROOT/bootstrap.sh"
# shellcheck source=../lib/core.sh
source "$ROOT/bootstrap/lib/core.sh"
# shellcheck source=../lib/orchestrator.sh
source "$ROOT/bootstrap/lib/orchestrator.sh"
# shellcheck source=../defaults.env
source "$ROOT/bootstrap/defaults.env"

BOOTSTRAP_PROFILE=partial
BOOTSTRAP_ONLY_TARGETS=ide
BOOTSTRAP_SKIP_TARGETS=''
BOOTSTRAP_EFFECTIVE_BREW_PROFILE=developer
BOOTSTRAP_FAILURES=0
DRY_RUN=0
RESUME_MODE=0
EXECUTION_LOG="$FIXTURE/executed"
FAIL_TARGET=''

use_op() { :; }
run_bootstrap_target() {
  printf '%s\n' "$1" >>"$EXECUTION_LOG"
  [[ $1 != "$FAIL_TARGET" ]]
}

init_bootstrap_run_state
run_bootstrap_target_with_dependencies ide
expected=$'packages\nrust\nenv\nsymlinks\nide'
[[ $(<"$EXECUTION_LOG") == "$expected" ]]
[[ $(bootstrap_target_status ide) == success ]]
[[ -f $BOOTSTRAP_RUN_STATE_DIR/checkpoints/ide.ok ]]

# Explicit resume skips a completed target only when the saved plan matches.
printf '%s\n' "$BOOTSTRAP_ACTIVE_RUN_ID" >"$XDG_STATE_HOME/dotfiles/last-incomplete"
: >"$EXECUTION_LOG"
unset BOOTSTRAP_TARGET_STATUS_PACKAGES BOOTSTRAP_TARGET_STATUS_RUST \
  BOOTSTRAP_TARGET_STATUS_ENV BOOTSTRAP_TARGET_STATUS_SYMLINKS BOOTSTRAP_TARGET_STATUS_IDE
RESUME_MODE=1
init_bootstrap_run_state
run_bootstrap_target_with_dependencies ide
[[ ! -s $EXECUTION_LOG ]]
[[ $(bootstrap_target_status ide) == success ]]

# Transient commands use bounded retries without recording intermediate failures.
cat >"$FIXTURE/flaky" <<'EOF'
#!/usr/bin/env bash
count=0
[[ -f $1 ]] && count=$(<"$1")
count=$((count + 1))
printf '%s\n' "$count" >"$1"
((count >= 3))
EOF
chmod +x "$FIXTURE/flaky"
BOOTSTRAP_FAILURES=0
if ! run_retry 3 0 "\"$FIXTURE/flaky\" \"$FIXTURE/retry-count\"" >"$FIXTURE/retry.log" 2>&1; then
  printf 'expected transient retry to recover\n' >&2
  exit 1
fi
grep -q 'Attempt 2/3 failed' "$FIXTURE/retry.log"
[[ $(<"$FIXTURE/retry-count") == 3 ]]
((BOOTSTRAP_FAILURES == 0))

# A failed prerequisite prevents downstream work.
RESUME_MODE=0
BOOTSTRAP_RUN_ID="failure-$$"
BOOTSTRAP_ACTIVE_RUN_ID="$BOOTSTRAP_RUN_ID"
BOOTSTRAP_FAILURES=0
BOOTSTRAP_TIMINGS=()
unset BOOTSTRAP_TARGET_STATUS_PACKAGES BOOTSTRAP_TARGET_STATUS_RUST \
  BOOTSTRAP_TARGET_STATUS_ENV BOOTSTRAP_TARGET_STATUS_SYMLINKS BOOTSTRAP_TARGET_STATUS_IDE
FAIL_TARGET=packages
: >"$EXECUTION_LOG"
init_bootstrap_run_state
if run_bootstrap_target_with_dependencies ide >"$FIXTURE/failure.log" 2>&1; then
  printf 'expected dependency failure\n' >&2
  exit 1
fi
grep -q 'Skipping target ide because dependency packages is failed' "$FIXTURE/failure.log"
[[ $(<"$EXECUTION_LOG") == packages ]]
[[ $(bootstrap_target_status packages) == failed ]]
[[ $(bootstrap_target_status ide) == skipped ]]
((BOOTSTRAP_FAILURES == 1))

printf 'ok: dependency ordering, checkpoints, and downstream skipping\n'
