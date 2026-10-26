" Basic highlighting while the Jac Tree-sitter parser is unavailable.
" Tree-sitter and the Jac LSP supply the richer syntax and semantic layers.
if exists('b:current_syntax')
  finish
endif

syntax keyword jacStatement import from as include global let has can def impl
syntax keyword jacStatement obj class enum node edge walker with entry exit
syntax keyword jacStatement visit revisit disengage spawn report ignore connect delete
syntax keyword jacStatement return yield raise assert del pass break continue
syntax keyword jacStatement async await static abstract override by sem test
syntax keyword jacConditional if elif else match case
syntax keyword jacRepeat for to by while
syntax keyword jacException try except finally
syntax keyword jacOperator and or not in is
syntax keyword jacConstant True False None
syntax keyword jacType str int float bool list dict set tuple bytes any type
syntax keyword jacBuiltin self super root here init postinit
syntax keyword jacTodo TODO FIXME XXX NOTE contained
syntax match jacComment /#.*$/ contains=jacTodo,@Spell
syntax region jacBlockComment start=/#\*/ end=/\*#/ contains=jacTodo,@Spell
syntax match jacEscape /\\./ contained
syntax region jacString start=/"/ skip=/\\./ end=/"/ contains=jacEscape,@Spell
syntax region jacString start=/'/ skip=/\\./ end=/'/ contains=jacEscape,@Spell
syntax region jacString start=/"""/ end=/"""/ contains=jacEscape,@Spell
syntax region jacString start=/'''/ end=/'''/ contains=jacEscape,@Spell
syntax match jacNumber /\<\d\+\(\.\d\+\)\?\([eE][+-]\?\d\+\)\?\>/
syntax sync minlines=50

highlight default link jacStatement Statement
highlight default link jacConditional Conditional
highlight default link jacRepeat Repeat
highlight default link jacException Exception
highlight default link jacOperator Operator
highlight default link jacConstant Constant
highlight default link jacType Type
highlight default link jacBuiltin Special
highlight default link jacTodo Todo
highlight default link jacComment Comment
highlight default link jacBlockComment Comment
highlight default link jacEscape SpecialChar
highlight default link jacString String
highlight default link jacNumber Number

let b:current_syntax = 'jac'
