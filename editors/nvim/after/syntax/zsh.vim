" Classify zsh setup/config builtins separately from external commands.
syntax keyword zshConfigBuiltin
      \ add-zsh-hook
      \ autoload
      \ bindkey
      \ compdef
      \ compinit
      \ disable
      \ emulate
      \ enable
      \ eval
      \ export
      \ source
      \ unfunction
      \ unhash
      \ zcompile
      \ zformat
      \ zmodload
      \ zparseopts
      \ zstyle
      \ containedin=ALLBUT,zshComment,zshString,zshStringDelimiter

syntax match zshConfigBuiltin /\(^\|[;|&({]\)\s*\zs\.\ze\_s/ containedin=ALLBUT,zshComment,zshString,zshStringDelimiter
