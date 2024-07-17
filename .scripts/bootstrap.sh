#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load Installation Scripts
scripts=(".init" "install.sh" "setup.sh")
for script in "${scripts[@]}"; do source "$SCRIPT_DIR/$script"; done

echo "[TUI BOOSTRAP SUCCESS]"
