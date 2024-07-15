#!/usr/bin/env zsh

alias list-aliases='alias | sort'
alias list-colors16='for c in {0..7}; do b=$((c+8)); print -P - "%F{$c}$c%f -> %F{$b}$b%f"; done'
alias list-colors256='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+"\n"}; done'
alias list-env-vars='env | sort'
alias list-fpath='print -l $fpath'
alias list-functions='print -l ${(ok)functions[(I)[^_]*]} | sort'
alias list-highlighter='print -raC2 - "${(@kvq+)ZSH_HIGHLIGHT_STYLES}" | sort'
alias list-path='print -l $path'
alias list-sourdiesel='cat "$ZDOTDIR/colorschemes/sourdiesel.zsh"'
alias list-users='dscl . list /Users | grep -v "^_"'
