# https://junegunn.github.io/fzf/

# -------------------------------- Defaults ---------------------------------------

# https://github.com/junegunn/fzf?tab=readme-ov-file#environment-variables
export FZF_DEFAULT_COMMAND="$(command -v fd &>/dev/null && echo 'fd --type f' || echo 'find . -type f')"

export FZF_DEFAULT_OPTS="
  --color          bg+:-1
  --color          border:$BRIGHTBLACK_HEX
  --color          fg:$BRIGHTBLACK_HEX
  --color          fg+:$BLACK_HEX
  --color          gutter:-1
  --color          header:italic:$BLUE_HEX
  --color          hl:$GREEN_HEX
  --color          hl+:bold:$GREEN_HEX
  --color          info:$RED_HEX
  --color          marker:$CYAN_HEX
  --color          pointer:$YELLOW_HEX
  --color          prompt:$MAGENTA_HEX
  --color          spinner:$CYAN_HEX
  --header         'Preview File/Folder Content'
  --layout         reverse
  --marker         ' '
  --pointer        ''
  --prompt         ' '
  --tmux           center
  --walker-skip    .git,node_modules,target
"

# -------------------------------- Shell Integrations ---------------------------------------

showdir="$(command -v tree &>/dev/null && echo 'tree -aCI ".git|.github" {}' || echo 'ls -lAh {}')"
showfile="$(command -v bat &>/dev/null && echo 'bat -n --color=always {}' || echo 'cat {}')"

# https://junegunn.github.io/fzf/shell-integration/#ctrl-t
export FZF_CTRL_T_OPTS="--bind 'ctrl-/:change-preview-window(down|hidden|)' --preview '[[ -d {} ]] && $showdir || $showfile'"

# https://junegunn.github.io/fzf/shell-integration/#ctrl-r
export FZF_CTRL_R_OPTS=''

# https://junegunn.github.io/fzf/shell-integration/#alt-c
export FZF_ALT_C_OPTS="--header 'Change Directory to...' --preview '$showdir'"

# -------------------------------- 3rd Party Integrations ---------------------------------------

# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#environment-variables
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --header 'Jump to...' --preview 'echo {} | cut -f2- | xargs -I{} $showdir'"
