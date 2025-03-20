# https://junegunn.github.io/fzf/

showdir="$(command -v tree &>/dev/null && echo 'tree -aCI ".git|.github" {}' || echo 'ls -lAh {}')"
showfile="$(command -v bat &>/dev/null && echo 'bat -n --color=always {}' || echo 'cat {}')"

# -------------------------------- Defaults ---------------------------------------

# https://github.com/junegunn/fzf?tab=readme-ov-file#environment-variables
export FZF_DEFAULT_COMMAND='find . -type f'
command -v fd &>/dev/null && export FZF_DEFAULT_COMMAND='fd --type f'

export FZF_DEFAULT_OPTS="
  --style full
  --layout reverse
  --tmux center
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
  --color header:$YELLOW_HEX
  --color header-border:$BRIGHTBLACK_HEX
  --color header-label:$BLUE_HEX

  --preview-label ' preview: C-/ '
  --preview '[[ -d {} ]] && $showdir || $showfile'
  --bind 'ctrl-/:change-preview-window(hidden|)'
  --color preview-border:$BRIGHTBLACK_HEX
  --color preview-label:$BRIGHTMAGENTA_HEX

  --input-label ' query '
  --color query:$WHITE_HEX
  --color input-border:$BRIGHTBLACK_HEX
  --color input-label:$RED_HEX
  --color prompt:$RED_HEX
  --color spinner:$CYAN_HEX
  --color info:$RED_HEX
  --prompt '  '

  --list-label ' results '
  --color list-border:$BRIGHTBLACK_HEX
  --color list-label:$GREEN_HEX
  --color marker:$CYAN_HEX
  --color pointer:$GREEN_HEX
  --color fg:$BRIGHTBLACK_HEX
  --color fg+:$WHITE_HEX
  --color bg+:-1
  --color gutter:-1
  --color hl:$BLACK_HEX
  --color hl+:$GREEN_HEX
  --marker ' '
  --pointer '󰓒'
"

# https://junegunn.github.io/fzf/shell-integration/#alt-c
export FZF_ALT_C_OPTS="--header 'builtin cd --' --border-label ' 󰉖 jump subdirs '"

# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#environment-variables
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --header 'zoxide query --interactive' --border-label ' 󰉖 jump list ' --preview 'echo {} | cut -f2- | xargs -I{} $showdir'"
