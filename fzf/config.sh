# https://junegunn.github.io/fzf/

# -------------------------------- Defaults ---------------------------------------

# https://github.com/junegunn/fzf?tab=readme-ov-file#environment-variables
export FZF_DEFAULT_COMMAND='find . -type f'
command -v fd &>/dev/null && export FZF_DEFAULT_COMMAND='fd --type f'

export FZF_DEFAULT_OPTS="
  --style full
  --border --padding 1,2
  --border-label ' Fuzzy Search '
  --input-label ' Input '
  --header-label ' Operation '
  --preview-label ' Preview '
  --list-label ' Results '
  --color border:$BRIGHTBLACK_HEX
  --color label:$BRIGHTMAGENTA_HEX
  --color preview-border:$BLUE_HEX
  --color preview-label:$BLUE_HEX
  --color list-border:$GREEN_HEX
  --color list-label:$GREEN_HEX
  --color input-border:$YELLOW_HEX
  --color input-label:$YELLOW_HEX
  --color header-border:$RED_HEX
  --color header-label:$RED_HEX
  --header-first

  --color          bg+:-1
  --color          fg:$BRIGHTBLACK_HEX
  --color          fg+:$BLACK_HEX
  --color          gutter:-1
  --color          header:$WHITE_HEX
  --color          hl:$GREEN_HEX
  --color          hl+:bold:$GREEN_HEX
  --color          info:$BRIGHTYELLOW_HEX
  --color          marker:$CYAN_HEX
  --color          pointer:$YELLOW_HEX
  --color          prompt:$BRIGHTYELLOW_HEX
  --color          spinner:$CYAN_HEX
  --header         'Preview File/Folder Content'
  --layout         reverse
  --marker         ' '
  --pointer        ''
  --prompt         '  '
  --tmux           center
  --walker-skip    .git,node_modules,target
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
