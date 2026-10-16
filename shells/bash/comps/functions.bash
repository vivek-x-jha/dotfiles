# shellcheck shell=bash

_dotfiles_functions() {
  local cur=${COMP_WORDS[COMP_CWORD]} prev=${COMP_WORDS[COMP_CWORD - 1]}
  local levels i target=0
  COMPREPLY=()

  case ${COMP_WORDS[0]} in
  l)
    # shellcheck disable=SC2034 # Dynamically scoped scratch variables used by Eva.
    local completions parse_help
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
  uvi)
    [[ $prev == -d || $prev == --desc ]] && return 0
    if [[ $cur == -* ]]; then
      mapfile -t COMPREPLY < <(compgen -W '-d --desc' -- "$cur")
    else
      for ((i = 1; i < COMP_CWORD; i++)); do
        case ${COMP_WORDS[i]} in
        -d|--desc) ((i += 1)) ;;
        *) target=1 ;;
        esac
      done
      ((target)) || mapfile -t COMPREPLY < <(compgen -d -- "$cur")
    fi
    ;;
  esac
  return 0
}

complete -F _dotfiles_functions cheatsheet edit-all fix-tmux-remotes list-256 list-colors toggle-tmux-client
complete -o filenames -F _dotfiles_functions take update-icons t uvi
complete -o filenames -o bashdefault -F _dotfiles_functions l
complete -o bashdefault -o default -o nospace -F _dotfiles_functions glg
