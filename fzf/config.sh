#!/usr/bin/env zsh
# https://junegunn.github.io/fzf/

export FZF_DEFAULT_COMMAND="$(command -v fd &>/dev/null && echo 'fd --type f' || echo 'find . -type f')"

export FZF_DEFAULT_OPTS="
  --color          bg+:-1
  --color          border:$BRIGHTBLACK_HEX
  --color          fg:$BRIGHTBLACK_HEX
  --color          fg+:$BLACK_HEX
  --color          gutter:-1
  --color          header:$MAGENTA_HEX
  --color          header:italic
  --color          hl:$BRIGHTRED_HEX
  --color          hl+:$BRIGHTRED_HEX
  --color          info:$BRIGHTMAGENTA_HEX
  --color          marker:$BRIGHTYELLOW_HEX
  --color          pointer:$BRIGHTGREEN_HEX
  --color          prompt:$BRIGHTYELLOW_HEX
  --color          spinner:$BLUE_HEX
  --header         'Preview File Content'
  --layout         reverse
  --marker         '*'
  --pointer        '󰶻'
  --prompt         ' '
  --tmux           center
  --walker-skip    .git,node_modules,target
"

# Shell integration: project folders/files + preview files
export FZF_CTRL_T_OPTS="
  --bind           'ctrl-/:change-preview-window(down|hidden|)'
  --preview        'bat -n --color=always {}'
"

# Shell integration: command history
export FZF_CTRL_R_OPTS="
  --bind           'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header         'Press CTRL-Y to copy command into clipboard'
  --preview        'echo {2..} | bat --color=always -pl sh'
  --preview-window 'wrap:up:3'
"

# Shell integration: change directory
export FZF_ALT_C_OPTS="
  --header         'Change Directory to...'
  --preview        'tree -aCI \".git|.github\" {}'
"

# Zoxide interactive scored directory window
# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#environment-variables
export _ZO_FZF_OPTS="
  $FZF_DEFAULT_OPTS 
  --header 'Jump to...'
  --preview 'echo {} | cut -f2- | xargs -I{} tree -aCI \".git|.github\" {}'
"
