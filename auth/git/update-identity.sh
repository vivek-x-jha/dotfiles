#!/usr/bin/env bash

set -euo pipefail

DRY_RUN=0
USE_1PASSWORD=''
GIT_NAME=''
GIT_EMAIL=''
GIT_SIGNINGKEY=''
OP_VAULT=''

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
IDENTITY_FILE="$XDG_CONFIG_HOME/git/identity"
SSH_CONFIG_FILE="$XDG_CONFIG_HOME/ssh/config"
SSH_BACKEND_CONFIG_FILE="$XDG_CONFIG_HOME/ssh/identities/1password"
SSH_AGENT_MACOS_BACKEND_CONFIG_FILE="$XDG_CONFIG_HOME/ssh/identities/ssh-agent-macos"
ALLOWED_SIGNERS_FILE="$XDG_CONFIG_HOME/ssh/allowed_signers"
OPENSSH_SIGNING_KEY="$XDG_CONFIG_HOME/ssh/keys/id_ed25519_github_signing"

log() {
  printf '[git-identity] %s\n' "$*" >&2
}

warn() {
  printf '[git-identity] WARN: %s\n' "$*" >&2
}

usage() {
  cat <<'EOF'
Usage: update-identity.sh [options]

Options:
  --name <value>          Git user.name value
  --email <value>         Git user.email value
  --signing-key <value>   SSH public key for Git signing
  --op-vault <value>      1Password vault for key lookup
  --use-1password         Prefer 1Password Git SSH signing when available
  --no-1password          Use OpenSSH ssh-keygen signing
  --dry-run               Print planned changes without writing files
  -h, --help              Show this help
EOF
}

while (($#)); do
  case "$1" in
  --name)
    GIT_NAME="${2:-}"
    shift 2
    ;;
  --email)
    GIT_EMAIL="${2:-}"
    shift 2
    ;;
  --signing-key)
    GIT_SIGNINGKEY="${2:-}"
    shift 2
    ;;
  --op-vault)
    OP_VAULT="${2:-}"
    shift 2
    ;;
  --use-1password)
    USE_1PASSWORD=1
    shift
    ;;
  --no-1password)
    USE_1PASSWORD=0
    shift
    ;;
  --dry-run)
    DRY_RUN=1
    shift
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    printf 'Unknown option: %s\n\n' "$1" >&2
    usage >&2
    exit 2
    ;;
  esac
done

existing_config() {
  git config --file "$IDENTITY_FILE" "$1" 2>/dev/null || true
}

GIT_NAME="${GIT_NAME:-$(existing_config user.name)}"
GIT_EMAIL="${GIT_EMAIL:-$(existing_config user.email)}"
GIT_SIGNINGKEY="${GIT_SIGNINGKEY:-$(existing_config user.signingkey)}"

[[ -n $GIT_NAME ]] || {
  printf 'Git name is required. Pass --name.\n' >&2
  exit 2
}

[[ -n $GIT_EMAIL ]] || {
  printf 'Git email is required. Pass --email.\n' >&2
  exit 2
}

run() {
  local cmd="$1"

  if ((DRY_RUN)); then
    log "[dry-run] $cmd"
    return
  fi

  eval "$cmd"
}

run_git_config() {
  local key="$1"
  local value="$2"

  if ((DRY_RUN)); then
    log "[dry-run] git config --file $IDENTITY_FILE $key $value"
    return
  fi

  git config --file "$IDENTITY_FILE" "$key" "$value"
}

set_git_config() {
  local key="$1"
  local value="$2"

  run_git_config "$key" "$value"
}

select_ssh_backend() {
  local backend="$1"
  local include_path="$XDG_CONFIG_HOME/ssh/$backend"
  local tmp=''

  run "mkdir -p \"$(dirname "$SSH_CONFIG_FILE")\""

  if ((DRY_RUN)); then
    log "[dry-run] set SSH backend Include $include_path in $SSH_CONFIG_FILE"
    return
  fi

  tmp="$(mktemp)"
  if [[ -f $SSH_CONFIG_FILE ]]; then
    awk -v include_path="$include_path" '
      BEGIN { done = 0 }
      tolower($1) == "include" && $2 ~ /\/(config-(1password|ssh-agent|ssh-agent-macos)|identit(y|ies)\/(1password|ssh-agent|ssh-agent-macos))$/ && !done {
        print "Include " include_path
        done = 1
        next
      }
      { print }
      END {
        if (!done) print "Include " include_path
      }
    ' "$SSH_CONFIG_FILE" >"$tmp"
  else
    printf 'Include %s\n' "$include_path" >"$tmp"
  fi

  mv "$tmp" "$SSH_CONFIG_FILE"
}

op_available() {
  command -v op >/dev/null 2>&1
}

op_ssh_sign_program() {
  if [[ $(uname -s) == Darwin && -x /Applications/1Password.app/Contents/MacOS/op-ssh-sign ]]; then
    printf '%s\n' /Applications/1Password.app/Contents/MacOS/op-ssh-sign
    return
  fi

  command -v op-ssh-sign 2>/dev/null || true
}

default_1password_socket() {
  local existing_socket=''

  if [[ -f $SSH_BACKEND_CONFIG_FILE ]]; then
    existing_socket=$(awk 'tolower($1) == "identityagent" { $1 = ""; sub(/^[[:space:]]+/, ""); print; exit }' "$SSH_BACKEND_CONFIG_FILE")
    existing_socket="${existing_socket%\"}"
    existing_socket="${existing_socket#\"}"
  elif [[ -f $SSH_CONFIG_FILE ]]; then
    existing_socket=$(awk 'tolower($1) == "identityagent" { $1 = ""; sub(/^[[:space:]]+/, ""); print; exit }' "$SSH_CONFIG_FILE")
    existing_socket="${existing_socket%\"}"
    existing_socket="${existing_socket#\"}"
  fi

  [[ -n $existing_socket ]] && {
    printf '%s\n' "$existing_socket"
    return
  }

  if [[ $(uname -s) == Darwin ]]; then
    printf '%s\n' "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  else
    printf '%s\n' "$HOME/.1password/agent.sock"
  fi
}

fetch_1password_signing_key() {
  local vault_args=()

  [[ -n $OP_VAULT ]] && vault_args=(--vault "$OP_VAULT")
  op item get 'GitHub Signing Key' "${vault_args[@]}" --field 'public key' --reveal 2>/dev/null || true
}

confirm_1password_socket() {
  local socket="$1"
  local answer=''

  ((DRY_RUN)) && return

  if [[ -t 0 ]]; then
    printf '>>> 1Password IdentityAgent socket [%s]: ' "$socket"
    read -r answer
    ONEPASSWORD_SOCKET="${answer:-$socket}"
  else
    ONEPASSWORD_SOCKET="$socket"
  fi
}

update_ssh_identity_agent() {
  local socket="$1"
  local tmp=''

  run "mkdir -p \"$(dirname "$SSH_BACKEND_CONFIG_FILE")\""

  if ((DRY_RUN)); then
    log "[dry-run] set IdentityAgent $socket in $SSH_BACKEND_CONFIG_FILE"
    return
  fi

  if [[ -f $SSH_BACKEND_CONFIG_FILE && $(awk 'tolower($1) == "identityagent" { found = 1 } END { print found + 0 }' "$SSH_BACKEND_CONFIG_FILE") == 1 ]]; then
    tmp="$(mktemp)"
    awk -v socket="$socket" '
      tolower($1) == "identityagent" && !done {
        indent = match($0, /[^[:space:]]/) > 1 ? substr($0, 1, RSTART - 1) : "  "
        print indent "IdentityAgent      \"" socket "\""
        done = 1
        next
      }
      { print }
    ' "$SSH_BACKEND_CONFIG_FILE" >"$tmp"
    mv "$tmp" "$SSH_BACKEND_CONFIG_FILE"
  else
    tmp="$(mktemp)"
    [[ -f $SSH_BACKEND_CONFIG_FILE ]] && cat "$SSH_BACKEND_CONFIG_FILE" >"$tmp"
    printf '\nHost *\n  IdentityAgent      "%s"\n' "$socket" >>"$tmp"
    mv "$tmp" "$SSH_BACKEND_CONFIG_FILE"
  fi
}

ensure_openssh_signing_key() {
  local public_key=''

  command -v ssh-keygen >/dev/null 2>&1 || {
    printf 'ssh-keygen is required for OpenSSH fallback signing.\n' >&2
    exit 1
  }

  run "mkdir -p \"$(dirname "$OPENSSH_SIGNING_KEY")\""

  if [[ ! -f $OPENSSH_SIGNING_KEY ]]; then
    run "ssh-keygen -t ed25519 -C \"$GIT_EMAIL\" -f \"$OPENSSH_SIGNING_KEY\" -N ''"
  fi

  if ((DRY_RUN)); then
    public_key="ssh-ed25519 <generated> $GIT_EMAIL"
  else
    public_key="$(cat "$OPENSSH_SIGNING_KEY.pub")"
  fi

  printf '%s\n' "$public_key"
}

if [[ -z $USE_1PASSWORD ]]; then
  if op_available && [[ -n $(op_ssh_sign_program) ]]; then
    USE_1PASSWORD=1
  else
    USE_1PASSWORD=0
  fi
fi

SIGNING_PROGRAM=''
ONEPASSWORD_SOCKET=''

if ((USE_1PASSWORD)); then
  SIGNING_PROGRAM="$(op_ssh_sign_program)"

  if [[ -z $SIGNING_PROGRAM ]] || ! op_available; then
    warn '1Password signing unavailable. Falling back to OpenSSH signing.'
    USE_1PASSWORD=0
  else
    GIT_SIGNINGKEY="${GIT_SIGNINGKEY:-$(fetch_1password_signing_key)}"
    if [[ -z $GIT_SIGNINGKEY ]]; then
      warn 'No 1Password signing public key found. Falling back to OpenSSH signing.'
      USE_1PASSWORD=0
    else
      ONEPASSWORD_SOCKET="$(default_1password_socket)"
      confirm_1password_socket "$ONEPASSWORD_SOCKET"
      update_ssh_identity_agent "$ONEPASSWORD_SOCKET"
    fi
  fi
fi

if ! ((USE_1PASSWORD)); then
  SIGNING_PROGRAM=ssh-keygen
  GIT_SIGNINGKEY="$(ensure_openssh_signing_key)"
fi

if ((USE_1PASSWORD)); then
  select_ssh_backend identities/1password
elif [[ $(uname -s) == Darwin && -f $SSH_AGENT_MACOS_BACKEND_CONFIG_FILE ]]; then
  select_ssh_backend identities/ssh-agent-macos
else
  select_ssh_backend identities/ssh-agent
fi

run "mkdir -p \"$(dirname "$IDENTITY_FILE")\""
set_git_config user.name "$GIT_NAME"
set_git_config user.email "$GIT_EMAIL"
set_git_config user.signingkey "$GIT_SIGNINGKEY"
set_git_config gpg.ssh.program "$SIGNING_PROGRAM"

run "mkdir -p \"$(dirname "$ALLOWED_SIGNERS_FILE")\""
if ((DRY_RUN)); then
  log "[dry-run] write allowed signer for $GIT_EMAIL to $ALLOWED_SIGNERS_FILE"
else
  printf '%s\n' "$GIT_EMAIL $GIT_SIGNINGKEY" >"$ALLOWED_SIGNERS_FILE"
fi

log "identity file: $IDENTITY_FILE"
log "signing program: $SIGNING_PROGRAM"
log "allowed signers: $ALLOWED_SIGNERS_FILE"
