#!/usr/bin/env zsh
# https://junegunn.github.io/fzf/

export FZF_DEFAULT_COMMAND="fd --type f"

export FZF_DEFAULT_OPTS="
  --color          bg+:-1
  --color          border:#5c617d
  --color          fg:#5c617d
  --color          fg+:#cccccc
  --color          gutter:-1
  --color          header:#eccef0
  --color          header:italic
  --color          hl:#f096b7
  --color          hl+:#f096b7
  --color          info:#c9ccfb
  --color          marker:#f3b175
  --color          pointer:#d2fd9d
  --color          prompt:#f3b175
  --color          spinner:#c4effa
  --header         'Preview File Content'
  --layout         reverse
  --marker         '*'
  --pointer        ''
  --prompt         '  '
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
