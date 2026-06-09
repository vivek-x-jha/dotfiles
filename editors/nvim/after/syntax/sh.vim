" Classify shell path-like text separately from generic strings.
syntax match shCommandName /\(^\|[;|&({]\)\s*\zs[A-Za-z_][A-Za-z0-9_.:-]*/ containedin=ALLBUT,shComment,shDeref,shDerefSimple,shDerefVar,shDoubleQuote,shSetList,shSingleQuote
syntax keyword shCommandName
      \ git
      \ print
      \ printf
      \ containedin=ALLBUT,shComment,shDeref,shDerefSimple,shDerefVar,shDoubleQuote,shSetList,shSingleQuote

syntax keyword shControlKeyword
      \ case
      \ coproc
      \ do
      \ done
      \ elif
      \ else
      \ esac
      \ fi
      \ for
      \ function
      \ if
      \ in
      \ return
      \ select
      \ then
      \ time
      \ until
      \ while
      \ containedin=ALLBUT,shComment,shDeref,shDerefSimple,shDerefVar,shDoubleQuote,shSetList,shSingleQuote

syntax match shPathLike /\v%(\~|\.{1,2})?\/[A-Za-z0-9_@%+=:,./-]+/ containedin=ALLBUT,shComment,shDeref,shDerefSimple,shDerefVar,shSetList
syntax match shPathLike /\v[A-Za-z0-9_.-]+\/[A-Za-z0-9_@%+=:,./-]+/ containedin=ALLBUT,shComment,shDeref,shDerefSimple,shDerefVar,shSetList
