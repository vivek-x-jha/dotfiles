#!/usr/bin/env zsh

# Requires colors autoload.
# See termcap(5).

# Set up once, and then reuse. This way it supports user overrides after the
# plugin is loaded.
declare -AHg less_termcap

# bold & blinking mode
less_termcap[mb]="$MAGENTA"
less_termcap[md]="$MAGENTA"
less_termcap[me]="$NONE"
# standout mode
less_termcap[so]="$YELLOW"
less_termcap[se]="$NONE"
# underlining
less_termcap[us]="$BLUE"
less_termcap[ue]="$NONE"

# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Absolute path to this file's directory.
declare -g __colored_man_pages_dir="${0:A:h}"

colored() {
  declare -ag environment
  # Convert associative array to plain array of NAME=VALUE items.
  for opt color in "${(@kv)less_termcap}"; do environment+=( "LESS_TERMCAP_${opt}=${color}" ); done
  # Prefer `less` whenever available, since we specifically configured environment for it.
  environment+=( PAGER="${commands[less]:-$PAGER}" )
  # See ./nroff script.
  [[ "$OSTYPE" != solaris* ]] || environment+=( PATH="${__colored_man_pages_dir}:$PATH" )
  command env $environment "$@"
}

# Colorize man and dman/debman (from debian-goodies)
man() { colored $0 "$@" }
dman() { colored $0 "$@" }
debman() { colored $0 "$@" }
