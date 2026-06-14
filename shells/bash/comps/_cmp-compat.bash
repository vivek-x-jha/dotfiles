# Minimal bash-completion compatibility layer.
#
# Several generated completion scripts in this repo expect helpers from the
# bash-completion package. Some systems do not have that package installed, so
# provide the small subset our scripts use.
# shellcheck shell=bash

_get_comp_words_by_ref() {
  local cur_name prev_name words_name cword_name

  while (($#)); do
    case $1 in
      -n)
        shift 2
        ;;
      --)
        shift
        break
        ;;
      -*)
        shift
        ;;
      *)
        break
        ;;
    esac
  done

  cur_name=${1:-cur}
  prev_name=${2:-prev}
  words_name=${3:-words}
  cword_name=${4:-cword}

  printf -v "$cur_name" '%s' "${COMP_WORDS[COMP_CWORD]}"
  printf -v "$prev_name" '%s' "${COMP_WORDS[COMP_CWORD-1]}"
  eval "$words_name=(\"\${COMP_WORDS[@]}\")"
  printf -v "$cword_name" '%s' "$COMP_CWORD"
}

_init_completion() {
  _get_comp_words_by_ref "$@" cur prev words cword
}

_split_longopt() {
  [[ ${cur-} == --*=* ]] || return 1

  cur=${cur#*=}
  return 0
}

_filedir() {
  local dironly=0

  while (($#)); do
    case $1 in
      -d) dironly=1 ;;
    esac
    shift
  done

  if ((dironly)); then
    mapfile -t COMPREPLY < <(compgen -d -- "${cur-}")
  else
    mapfile -t COMPREPLY < <(compgen -f -- "${cur-}")
  fi
}
