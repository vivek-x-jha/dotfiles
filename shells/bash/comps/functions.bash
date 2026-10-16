# shellcheck shell=bash

_dotfiles_functions() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local levels
  COMPREPLY=()

  case ${COMP_WORDS[0]} in
  l)
    # shellcheck disable=SC2034 # Dynamically scoped scratch variables used by Eva.
    local completions parse_help prev
    _eva
    ;;
  glg)
    declare -F __git_func_wrap >/dev/null && __git_func_wrap _git_log
    ;;
  take|update-icons)
    ((COMP_CWORD == 1)) && mapfile -t COMPREPLY < <(compgen -d -- "$cur")
    ;;
  t)
    ((COMP_CWORD > 2)) && return 0
    if [[ $cur == -* ]]; then
      levels=$(printf -- '-%s ' {1..99})
      ((COMP_CWORD == 1)) && levels+=' -h --help'
      mapfile -t COMPREPLY < <(compgen -W "$levels" -- "$cur")
    elif ((COMP_CWORD == 1)); then
      mapfile -t COMPREPLY < <(compgen -d -- "$cur")
    fi
    ;;
  esac
  return 0
}

complete -F _dotfiles_functions cheatsheet edit-all list-256 list-colors
complete -o filenames -F _dotfiles_functions take update-icons t
complete -o filenames -o bashdefault -F _dotfiles_functions l
complete -o bashdefault -o default -o nospace -F _dotfiles_functions glg
