" Classify zsh setup/config builtins separately from external commands.
syntax match zshCommandName /\(^\|[;|&({]\)\s*\zs[A-Za-z_][A-Za-z0-9_.:-]*/ containedin=ALLBUT,zshComment,zshString,zshStringDelimiter,zshDeref,zshSubst,zshSubstDelim
syntax keyword zshCommandName
      \ git
      \ print
      \ printf
      \ containedin=ALLBUT,zshComment,zshString,zshStringDelimiter,zshDeref,zshSubst,zshSubstDelim

syntax keyword zshControlKeyword
      \ return
      \ containedin=ALLBUT,zshComment,zshString,zshStringDelimiter,zshDeref,zshSubst,zshSubstDelim

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

syntax match zshPathLike /\v%(\~|\.{1,2})?\/[A-Za-z0-9_@%+=:,./-]+/ containedin=ALLBUT,zshComment,zshDeref,zshSubst,zshSubstDelim,zshConfigBuiltin
syntax match zshPathLike /\v[A-Za-z0-9_.-]+\/[A-Za-z0-9_@%+=:,./-]+/ containedin=ALLBUT,zshComment,zshDeref,zshSubst,zshSubstDelim,zshConfigBuiltin
