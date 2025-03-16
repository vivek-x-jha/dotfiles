#!/usr/bin/env bash

list_colors () {

  local colors=(
    "$BLACK_HEX"
    "$RED_HEX"
    "$GREEN_HEX"
    "$YELLOW_HEX"
    "$BLUE_HEX"
    "$MAGENTA_HEX"
    "$CYAN_HEX"
    "$WHITE_HEX"
    "$BRIGHTBLACK_HEX"
    "$BRIGHTRED_HEX"
    "$BRIGHTGREEN_HEX"
    "$BRIGHTYELLOW_HEX"
    "$BRIGHTBLUE_HEX"
    "$BRIGHTMAGENTA_HEX"
    "$BRIGHTCYAN_HEX"
    "$BRIGHTWHITE_HEX"
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

take () { mkdir -p "$1" && cd "$1" || return; }

count_files () (
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
    git switch $(git branch | fzf --header 'Switch Local  ' --preview 'git show --color=always "$(echo {} | awk "{print \$1}")"')
  else
    git switch "$@"
  fi
}
