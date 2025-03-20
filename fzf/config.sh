# https://junegunn.github.io/fzf/

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

  --border-label ' Fuzzy Search '
  --color border:$BRIGHTBLACK_HEX
  --color label:$RED_HEX

  --header 'Preview File/Folder Content'
  --header-label ' Description '
  --color header:$BRIGHTBLUE_HEX
  --color header-border:$BRIGHTBLACK_HEX
  --color header-label:$BLUE_HEX

  --preview-label ' Preview '
  --color preview-border:$BRIGHTBLACK_HEX
  --color preview-label:$MAGENTA_HEX

  --input-label ' Input '
  --color input:$BLACK_HEX
  --color input-border:$BRIGHTBLACK_HEX
  --color input-label:$YELLOW_HEX
  --color prompt:$BRIGHTYELLOW_HEX
  --color spinner:$CYAN_HEX
  --color info:$BRIGHTYELLOW_HEX
  --prompt '  '

  --list-label ' Results '
  --color list-border:$BRIGHTBLACK_HEX
  --color list-label:$GREEN_HEX
  --color marker:$CYAN_HEX
  --color pointer:$GREEN_HEX
  --color fg:$BRIGHTBLACK_HEX
  --color fg+:$BLACK_HEX
  --color bg+:-1
  --color gutter:-1
  --color hl:$RED_HEX
  --color hl+:bold:$GREEN_HEX
  --marker ' '
  --pointer '󰓒'
"

# -------------------------------- Shell Integrations ---------------------------------------

showdir="$(command -v tree &>/dev/null && echo 'tree -aCI ".git|.github" {}' || echo 'ls -lAh {}')"
showfile="$(command -v bat &>/dev/null && echo 'bat -n --color=always {}' || echo 'cat {}')"
showcmd="$(command -v bat &>/dev/null && echo 'bat --color=always -pl sh' || echo 'cat')"  

# https://junegunn.github.io/fzf/shell-integration/#ctrl-t
export FZF_CTRL_T_OPTS="--bind 'ctrl-/:change-preview-window(down|hidden|)' --preview '[[ -d {} ]] && $showdir || $showfile'"

# https://junegunn.github.io/fzf/shell-integration/#ctrl-r
export FZF_CTRL_R_OPTS="--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header         'Press CTRL-Y to copy command into clipboard'
  --preview        'echo {2..} | $showcmd'
  --preview-window 'wrap:up:3'
"

# https://junegunn.github.io/fzf/shell-integration/#alt-c
export FZF_ALT_C_OPTS="--header 'Change Directory to...' --preview '$showdir'"

# -------------------------------- 3rd Party Integrations ---------------------------------------

# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#environment-variables
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --header 'Jump to...' --preview 'echo {} | cut -f2- | xargs -I{} $showdir'"
