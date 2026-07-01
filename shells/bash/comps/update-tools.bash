#!/usr/bin/env bash
# shellcheck shell=bash

_update_tools() {
  local cur prev opts

  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD - 1]}

  opts='-a --all -d --ds-store -z --zsh -t --tmux -l --tldr -f --fzf -n --nvim --pi -r --rust -b --brew -i --icons -e --tex --icons-dir -h --help'

  case "$prev" in
  --icons-dir)
    mapfile -t COMPREPLY < <(compgen -d -- "$cur")
    return 0
    ;;
  esac

  [[ $cur == -* ]] && {
    mapfile -t COMPREPLY < <(compgen -W "$opts" -- "$cur")
    return 0
  }

  if [[ $cur == */* || -z $cur ]]; then
    mapfile -t COMPREPLY < <(compgen -d -- "$cur")
  fi
}

complete -F _update_tools -o bashdefault -o default update-tools
