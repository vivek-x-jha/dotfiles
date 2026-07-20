# shellcheck shell=bash

_hs() {
  local cur prev
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD - 1]}

  case $prev in
    -c|-m|-t) return 0 ;;
  esac

  if [[ $cur == -* ]]; then
    mapfile -t COMPREPLY < <(compgen -W '-A -c -C -h -i -m -n -N -P -q -s -t --' -- "$cur")
  elif [[ $cur == ./* || $cur == /* || $cur == ~* ]]; then
    mapfile -t COMPREPLY < <(compgen -f -- "$cur")
  fi
}

complete -F _hs -o bashdefault -o default hs
