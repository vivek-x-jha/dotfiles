#!/usr/bin/env bash

take () { mkdir -p "$1" && cd "$1" || return; }

cheatsheet () {
  # Define column widths
  local key_width=13
  local desc_width=35
  local cmd_width=20
  local table_width=$((key_width + desc_width + cmd_width + 2)) # +2 for spacing

  # Print separator line that matches column layout
  print_separator() {
    printf "${BRIGHTBLACK}%-${table_width}s${RESET}\n" '' | tr ' ' '-'
  }

  print_separator
  printf "${YELLOW}%-6s ${BLUE}%-35s ${GREEN}%-40s${RESET}\n" 'Key' 'Desc' 'Cmd'
  print_separator

  # Flat array of bindings in the format 'KEY>:Description:Command'
  local bindings=(
    '<A-L>:clear terminal screen:clear'
    '<A-C>:jump to subdirectory:builtin cd --'
    '<C-E>:select autosuggestion:autosuggest-accept'
    '<C-R>:search shell command history:atuin-search'
    '<C-T>:fuzzy search files/directories:fzf'
    '<C-Y>:run autosuggestion:autosuggest-execute'
    '<C-U>:delete chars left of cursor:unix-line-discard'
    '<C-I>:accept autocomplete:fzf-completion'
    '<C-O>:reload shell:exec '"$(brew --prefix)"'/bin/'${ZSH_VERSION:+zsh}${BASH_VERSION:+bash}
    '<C-P>:search frequent directories:zoxide query --interactive'
    '<C-A>:invoke tmux hotkey:tmux prefix'
    '<C-D>:end input:logout'
    '<C-Z>:suspend process (restart with fg):kill -TSTP <pid>'
    '<C-C>:interrupt process:kill -INT <pid>'
    '<C-N>:open previous neovim session:nvim -S'
    '<Up>:search shell last command history:atuin-up-search'
  )

  # Color names mapped to base16 (you must have these env vars)
  local colornames=(
    BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
    BRIGHTBLACK BRIGHTRED BRIGHTGREEN BRIGHTYELLOW BRIGHTBLUE BRIGHTMAGENTA BRIGHTCYAN BRIGHTWHITE
  )

  local i=0
  for binding in "${bindings[@]}"; do
    local colorname="${colornames[$((i % 17))]}"
    local color="${!colorname}"  # Bash-style indirect reference
    printf "%b\n" "${color}${binding}${RESET}"
    ((i++))
  done | awk -F ':' -v k="$key_width" -v d="$desc_width" -v c="$cmd_width" '
    {
      printf "%-*s %-*s %-*s\n", k, $1, d, $2, c, ($3 ? $3 : "")
    }'
}

combinepdf () { gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$1" "${@:2}"; }

count_files () (
  shopt -s nullglob
  local dir=$1
  local files=("$dir"/* "$dir"/.*)
  echo "${#files[@]}"
)

list_tmux_sessions () {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --header="tmux switch/attach" \
        --border-label="  sessions " \
        --preview='tmux list-windows -t {}' \
        --preview-window=up:wrap:60%)

  [ -z "$session" ] && return 0

  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$session"
  else
    tmux attach-session -t "$session"
  fi
}

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
