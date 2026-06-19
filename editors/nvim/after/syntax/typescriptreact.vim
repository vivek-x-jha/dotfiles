" Classify callables separately from ordinary TSX identifiers.
syntax match typescriptCallable /\v<[$A-Za-z_][$A-Za-z0-9_]*\ze\s*\(/ containedin=ALLBUT,typescriptComment,typescriptDocComment,typescriptLineComment,typescriptString,typescriptTemplate,typescriptRegexpString,tsxString
syntax match typescriptCallable /\v<[$A-Za-z_][$A-Za-z0-9_]*\ze\s*[<]/ containedin=ALLBUT,typescriptComment,typescriptDocComment,typescriptLineComment,typescriptString,typescriptTemplate,typescriptRegexpString,tsxString
