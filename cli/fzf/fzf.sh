# shellcheck shell=bash
# Fzf: https://junegunn.github.io/fzf/

showdir="$(
  command -v eza &>/dev/null &&
    echo 'eza \
      --all \
      --tree \
      --level=3 \
      --color=always \
      --icons=always \
      --group-directories-first \
      --ignore-glob=".git|.github|.venv|__pycache__" {}' ||
    echo 'ls -lAh {}'
)"

showfile="$(command -v bat &>/dev/null && echo 'bat --color=always --style=changes -- {}' || echo 'cat -- {}')"
if command -v fd &>/dev/null; then
  findfile='fd --type f'
  findfile_absolute='fd --type f --absolute-path'
  finddir_absolute='fd --type d --hidden --follow --exclude .git --exclude node_modules --exclude target --absolute-path'
  findpath_absolute='fd --type f --type d --hidden --follow --exclude .git --exclude node_modules --exclude target --absolute-path'
else
  findfile='find . -type f'
  # Expand PWD when fzf runs each fallback command, not while loading this file.
  # shellcheck disable=SC2016
  findfile_absolute='find "$PWD" -type f'
  # shellcheck disable=SC2016
  finddir_absolute='find "$PWD" -type d'
  # shellcheck disable=SC2016
  findpath_absolute='find "$PWD"'
fi

# Expand HOME and awk's field variables when fzf runs this command template.
# shellcheck disable=SC2016
home_path_fields='awk -v home="$HOME" '\''{ original=$0; display=$0; if (display == home) display="~"; else sub("^" home "/", "~/", display); print display "\034" original }'\'''
findfile_home_paths="$findfile_absolute | $home_path_fields"
finddir_home_paths="$finddir_absolute | $home_path_fields"
findpath_home_paths="$findpath_absolute | $home_path_fields"
showfile_field2="$(printf '%s\n' "$showfile" | sed 's/{}/{2}/g')"
showdir_field2="$(printf '%s\n' "$showdir" | sed 's/{}/{2}/g')"
showdir_field3="$(printf '%s\n' "$showdir" | sed 's/{}/{3}/g')"
preview_field2="if [[ -d {2} ]]; then $showdir_field2; elif [[ -f {2} ]]; then $showfile_field2; fi"

# https://github.com/junegunn/fzf?tab=readme-ov-file#environment-variables
export FZF_DEFAULT_COMMAND="$findfile"

export FZF_DEFAULT_OPTS="
  --style full
  --layout reverse
  --popup center,75%,75%
  --border
  --header-first
  --padding 1,2
  --walker-skip .git,node_modules,target
  --no-bold

  --border-label '  fuzzy search '
  --color border:$BRIGHTBLACK_HEX
  --color label:$MAGENTA_HEX

  --header-label ' command '
  --header '$FZF_DEFAULT_COMMAND'
  --color header:$GREEN_HEX
  --color header-border:$BRIGHTBLACK_HEX
  --color header-label:$RED_HEX

  --preview-label ' preview '
  --preview 'if [[ -d {} ]]; then $showdir; elif [[ -f {} ]]; then $showfile; fi'
  --bind 'ctrl-/:change-preview-window(hidden|)'
  --color preview-border:$BRIGHTBLACK_HEX
  --color preview-label:$CYAN_HEX

  --input-label ' query '
  --color query:$WHITE_HEX
  --color input-border:$BRIGHTBLACK_HEX
  --color input-label:$BLUE_HEX
  --color prompt:$BRIGHTYELLOW_HEX
  --color spinner:$CYAN_HEX
  --color info:$BRIGHTMAGENTA_HEX
  --prompt '  '

  --list-label ' results '
  --color list-border:$BRIGHTBLACK_HEX
  --color list-label:$YELLOW_HEX
  --color marker:$CYAN_HEX
  --color pointer:$MAGENTA_HEX
  --color fg:$BRIGHTBLACK_HEX
  --color fg+:$WHITE_HEX
  --color bg+:-1
  --color hl:$BLACK_HEX
  --color hl+:$BRIGHTCYAN_HEX:bold
  --gutter ' '
  --marker '* '
  --pointer '󰶻'
"

# A bare fzf invocation owns its input, so it can safely use separate display
# and accepted fields. Piped/custom invocations keep their input untouched.
fzf() {
  if [[ $# -eq 0 && -t 0 && ${FZF_DEFAULT_COMMAND-} == "$findfile" ]]; then
    FZF_DEFAULT_COMMAND="$findfile_home_paths" \
      FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --delimiter '\x1c' --with-nth 1 --accept-nth 2 --preview '$preview_field2'" \
      command fzf
  else
    command fzf "$@"
  fi
}

# https://junegunn.github.io/fzf/shell-integration/#ctrl-t
export FZF_CTRL_T_COMMAND="$findpath_home_paths"
export FZF_CTRL_T_OPTS="
  --delimiter '\x1c'
  --with-nth 1
  --accept-nth 2
  --preview '$preview_field2'
"

# https://junegunn.github.io/fzf/shell-integration/#alt-c
export FZF_ALT_C_COMMAND="$finddir_home_paths"
export FZF_ALT_C_OPTS="
  --header 'builtin cd --'
  --border-label ' 󰉖 jump subdir '
  --delimiter '\x1c'
  --with-nth 1
  --accept-nth 2
  --preview '$showdir_field2'
"

# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#environment-variables
# Keep the display path separate from zoxide's accepted absolute path. Zoxide
# removes a seven-character score field after fzf exits, so field 2 retains a
# dummy score prefix while field 3 gives the preview the unmodified path.
export _ZO_FZF_OPTS="
  $FZF_DEFAULT_OPTS
  --header 'zoxide query --interactive'
  --border-label ' 󰉖 jump list '
  --bind 'start:reload(command zoxide query --list | awk -v home=\"\$HOME\" '\''{ original=\$0; display=\$0; sub(\"^\" home \"/\", \"~/\", display); print display \"\\t0000000\" original \"\\t\" original }'\'' | tr \"\\n\" \"\\0\")+change-nth(1)'
  --delimiter '\t'
  --with-nth 1
  --accept-nth 2
  --preview '$showdir_field3'
"
