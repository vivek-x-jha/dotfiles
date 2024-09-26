#!/usr/bin/env bash

is_installed() {
  local cmd="$1"
  if ! command -v "$cmd" &>/dev/null; then
    echo "[! $cmd: NOT INSTALLED]"
    return 1
  fi
}

symlink() {
  local src="$1"
  local cwd="$2"
  local tgt="$3"
  
  # Test: Valid Current Working Dir
  [ -d "$cwd" ] || return 1
  cd "$cwd"

  # Test: Valid Source File/Folder
  [ -e "$src" ] || return 1

  # Link Source to Target - remove original if directory
  [ -d "$tgt" ] && rm -rf "$tgt"
  ln -sf "$src" "$tgt"

  echo "[+ Link: $src -> $cwd/$tgt]"
}
