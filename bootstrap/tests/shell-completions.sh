#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2034
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FIXTURE="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-completions.XXXXXX")"
trap 'rm -rf "$FIXTURE"' EXIT
mkdir -p "$FIXTURE/project" "$FIXTURE/project space" "$FIXTURE/icons"
touch "$FIXTURE/plain-file"
cd "$FIXTURE"
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
git init -q -b completion-test
git -c user.name='Completion Test' -c user.email='completions@example.invalid' \
  -c commit.gpgsign=false -c core.hooksPath=/dev/null commit --allow-empty -qm 'test: completion fixture'

# Fake packaged files exercise the actual loader without requiring Homebrew.
mkdir -p "$FIXTURE/brew/etc/bash_completion.d"
for cmd in atuin bat bob dust fd rg starship tldr uv; do
  printf 'complete -W packaged %s\n' "$cmd" >"$FIXTURE/brew/etc/bash_completion.d/$cmd"
  [[ ! -e $ROOT/shells/bash/comps/$cmd.bash && ! -e $ROOT/shells/zsh/comps/_$cmd ]]
done
for cmp in "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/bash_completion.d/git-completion.bash" \
  /usr/share/bash-completion/completions/git /usr/share/git/completion/git-completion.bash; do
  [[ -r $cmp ]] || continue
  ln -s "$cmp" "$FIXTURE/brew/etc/bash_completion.d/git-completion.bash"
  break
done
SHELL_CONFIG="$ROOT/shells" HOMEBREW_PREFIX="$FIXTURE/brew" source "$ROOT/shells/bash/completions.bash"
for cmd in atuin bat bob dust fd rg starship tldr uv; do
  [[ $(complete -p "$cmd") == *packaged* ]]
done
for fn in prepend_path append_path remove_path fix-tmux-remotes toggle-tmux-client uvi; do
  if complete -p "$fn" &>/dev/null; then
    printf 'unexpected completion for unavailable helper: %s\n' "$fn" >&2
    exit 1
  fi
done
source "$ROOT/shells/bash/funcs/update-tools"

assert_match() {
  local candidate
  for candidate in "${COMPREPLY[@]}"; do
    [[ $candidate != "$1" ]] || return 0
  done
  printf 'missing completion: %s\n' "$1" >&2
  exit 1
}

assert_absent() {
  local candidate
  for candidate in "${COMPREPLY[@]}"; do
    [[ $candidate != "$1" ]] || {
      printf 'unexpected completion: %s\n' "$1" >&2
      exit 1
    }
  done
}

complete_function() {
  COMP_WORDS=("$@")
  COMP_CWORD=$(($# - 1))
  _dotfiles_functions
}

for fn in "$ROOT"/shells/bash/funcs/*; do
  complete -p "${fn##*/}" >/dev/null
done

for fn in cheatsheet edit-all list-256 list-colors; do
  complete_function "$fn" ''
  [[ ${#COMPREPLY[@]} == 0 ]]
done

for fn in take update-icons; do
  complete_function "$fn" pro
  assert_match project
  assert_match 'project space'
  assert_absent plain-file
  complete_function "$fn" project ''
  [[ ${#COMPREPLY[@]} == 0 ]]
done

complete_function t -1
assert_match -1
assert_match -19
assert_absent -100
complete_function t project -
assert_match -99
assert_absent --help
complete_function t --
assert_match --help
complete_function t project -2 ''
[[ ${#COMPREPLY[@]} == 0 ]]

# Wrappers delegate instead of maintaining duplicate Eva/Git option lists.
_eva() { COMPREPLY=(eva-option); }
complete_function l --
assert_match eva-option
if declare -F __git_func_wrap >/dev/null; then
  # Packaged interactive completions are not nounset-safe.
  set +u
  # Real Git completion, including Readline's split around '=' and ':'.
  complete_function glg --one || true
  [[ ${COMPREPLY[*]} == *--oneline* ]]
  complete_function glg --date = rel || true
  assert_match 'relative '
  complete_function glg completion-t || true
  [[ ${COMPREPLY[*]} == *completion-test* ]]
  check_comp_words() {
    local cur prev words cword split=false
    COMP_WORDS=(command 'directory with spaces' value)
    COMP_CWORD=2
    _get_comp_words_by_ref cur prev words cword
    [[ $cur == value && $prev == 'directory with spaces' && $cword == 2 ]]
    [[ ${words[1]} == 'directory with spaces' ]]
    COMP_WORDS=(command --option '=' value : suffix)
    COMP_CWORD=5
    _get_comp_words_by_ref -n =: cur words cword prev
    [[ $cur == --option=value:suffix && $prev == command && $cword == 1 ]]
    _init_completion -s
    [[ $prev == --option && $cur == value:suffix && $split == true ]]
  }
  check_comp_words
  set -u
else
  printf 'skip: Git integration checks (packaged Git completion unavailable)\n'
fi
[[ $(complete -p glg) == *' -o nospace '* ]]

# Never replace a full framework's installed helpers with our small fallbacks.
(
  _init_completion() { printf installed; }
  source "$ROOT/shells/bash/comps/_cmp-compat.bash"
  [[ $(_init_completion) == installed ]]
)
completion_help() { printf '  -h, --help  Show help\n      --color <WHEN>  Select color\n'; }
help_opts=$(_parse_help completion_help)
[[ $help_opts == *--help* && $help_opts == *--color* ]]

COMP_WORDS=(update-tools --)
COMP_CWORD=1
_update_tools
help_text=$(update-tools --help)
for option in $help_text; do
  option=${option%,}
  [[ $option != --* ]] || assert_match "$option"
done
COMP_WORDS=(update-tools pro)
_update_tools
assert_match project
assert_match 'project space'
assert_absent plain-file
COMP_WORDS=(update-tools --icons-dir pro)
COMP_CWORD=2
_update_tools
assert_match project
[[ $(complete -p update-tools) != *' -o default '* ]]
[[ $(complete -p update-tools) != *' -o bashdefault '* ]]
printf 'ok: Bash custom completions, wrapper delegation, and help parity\n'

if command -v zsh >/dev/null; then
  ROOT="$ROOT" ZDOTDIR="$FIXTURE" zsh -f <<'ZSH'
set -eu
fpath=("$ROOT/shells/zsh/comps" $fpath)
autoload -Uz compinit
compinit -D
for fn in "$ROOT"/shells/zsh/funcs/*; do
  [[ -n ${_comps[${fn:t}]-} ]] || { print -ru2 "missing completion: ${fn:t}"; exit 1; }
done
[[ ${_services[l]} == eva && ${_services[glg]} == git-log ]]
for fn in prepend_path append_path remove_path fix-tmux-remotes toggle-tmux-client uvi; do
  [[ -z ${_comps[$fn]-} ]]
done

# Exercise dispatch without executing any maintenance or relying on a terminal.
_arguments() { specs=("$@"); }
_directories() { delegated=directories; }
_eva() { delegated=eva; }
_git() { delegated=git; }
_message() { message="$*"; }
compadd() { shift; added+=("$@"); }

for service in take update-icons; do
  _dotfiles-functions
  [[ ${specs[1]} == '1:directory:_directories' ]]
done
for service in eva git-log; do
  delegated=''
  _dotfiles-functions
  [[ $delegated == ${service%-log} ]]
done
for service in cheatsheet edit-all list-256 list-colors; do
  _dotfiles-functions
  [[ $message == 'no arguments' ]]
done
service=t CURRENT=2 PREFIX=-
added=()
_dotfiles-functions
[[ ${added[(Ie)-1]} -gt 0 && ${added[(Ie)-99]} -gt 0 && ${added[(Ie)--help]} -gt 0 ]]
[[ ${added[(Ie)-100]} == 0 ]]
CURRENT=3
added=()
_dotfiles-functions
[[ ${added[(Ie)--help]} == 0 && ${added[(Ie)-99]} -gt 0 ]]
CURRENT=2 PREFIX=pro
_dotfiles-functions
[[ $delegated == directories ]]

service=patch-zsh-autocomplete
_dotfiles-functions
[[ ${specs[1]} == *'apply --apply reverse --reverse -R -h --help'* ]]
_update-tools
[[ ${(j: :)specs} == *'--icons-dir['* && ${(j: :)specs} != *'--icons-dir='* ]]
[[ ${specs[1]} == : ]] # The parser does not accept stacked flags such as -ni.
[[ ${specs[-1]} == '1:icons directory:_directories' ]]
print 'ok: Zsh custom completion registration, dispatch, and argument specifications'
ZSH
else
  printf 'skip: Zsh completion checks (zsh unavailable)\n'
fi
