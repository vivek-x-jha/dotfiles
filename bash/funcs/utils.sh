#!/usr/bin/env bash

list_colors () {

  local colors=(
    "#cccccc"
    "#ffc7c7"
    "#ceffc9"
    "#fdf7cd"
    "#c4effa"
    "#eccef0"
    "#8ae7c5"
    "#f4f3f2"

    "#5c617d"
    "#f096b7"
    "#d2fd9d"
    "#f3b175"
    "#80d7fe"
    "#c9ccfb"
    "#47e7b1"
    "#ffffff"
  )

  for hex in "${colors[@]}"; do
    # Convert hex to RGB
    local r=$((16#${hex:1:2}))
    local g=$((16#${hex:3:2}))
    local b=$((16#${hex:5:2}))
    
    # Create the ANSI escape sequence for the color
    local ansi="\e[38;2;${r};${g};${b}m"

    printf "${ansi}(%s) The quick brown fox jumps over the lazy dog${RESET}\n" "$hex"
  done
}

take () {
  local dir="$1"

  [ -d "$dir" ] || mkdir -p "$dir"
  cd "$dir"
}

count-files () (
  shopt -s nullglob
  local dir=$1
  local files=("$dir"/* "$dir"/.*)
  echo "${#files[@]}"
)

combinepdf () {
  gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$1" "${@:2}"
}

tmux_list_sessions () {
  # TODO standardize with header
  tmux list-sessions | awk -F '[ :()]+' 'BEGIN { \
  printf "%-13s %-5s %-25s\n", "Session", "Win", "Date Created"; \
  print "·······································"} \
  { printf "%-13s %-5s %s %s %s (%s:%s)\n", $1, $2, $6, $7, $11, $8, $9 }'
}

gsw () {
  # Function overload for git switch fuzzy finding
  if (( $# == 0 )) && command -v fzf; then
    git switch $(git branch | fzf --header 'Switch Local  ')
  else
    git switch "$@"
  fi
}
