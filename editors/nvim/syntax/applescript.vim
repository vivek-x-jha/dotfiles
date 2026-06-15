" AppleScript syntax highlighting

if exists('b:current_syntax')
  finish
endif

syntax case ignore

syntax match applescriptVariable /\v<[_A-Za-z][_A-Za-z0-9]*>/

syntax region applescriptString start=/"/ skip=/\\"/ end=/"/
syntax match applescriptNumber /\v<\d+(\.\d+)?>/

syntax keyword applescriptConditional if then else considering ignoring
syntax keyword applescriptRepeat repeat while until times
syntax keyword applescriptStatement end error exit return tell try using with without
syntax keyword applescriptHandler on to
syntax keyword applescriptAssignment set property global local
syntax keyword applescriptBoolean true false
syntax keyword applescriptConstant missing value null me it result
syntax keyword applescriptType alias application boolean class constant date file integer list number real record reference script string text
syntax keyword applescriptCommand activate choose click close copy count delete display do duplicate exists get launch make move open print quit reveal run save select

syntax match applescriptOperator /\v[&=<>+\-*\/]/
syntax match applescriptOperator /\v<%(and|or|not|is|isnt|contains|starts with|ends with|comes before|comes after)>/

syntax region applescriptBlockComment start=/(\*/ end=/\*)/ contains=applescriptTodo
syntax match applescriptComment /--.*$/ contains=applescriptTodo
syntax keyword applescriptTodo TODO FIXME NOTE contained

syntax sync minlines=50

let b:current_syntax = 'applescript'
