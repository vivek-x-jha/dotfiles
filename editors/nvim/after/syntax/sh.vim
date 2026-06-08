" Classify shell path-like text separately from generic strings.
syntax match shPathLike /\v%(\~|\.{1,2})?\/[A-Za-z0-9_@%+=:,./-]+/ containedin=ALLBUT,shComment,shDeref,shDerefSimple,shDerefVar,shSetList
syntax match shPathLike /\v[A-Za-z0-9_.-]+\/[A-Za-z0-9_@%+=:,./-]+/ containedin=ALLBUT,shComment,shDeref,shDerefSimple,shDerefVar,shSetList
