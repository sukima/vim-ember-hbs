" Vim syntax file
" Language:     Glimmer
" Maintainer:   Devin Weaver
" Last Change:  2026 Feb 20
" Origin:       https://github.com/joukevandermaas/vim-ember-hbs
" Credits:      Jouke van der Maas

" Vim detects GJS/GTS files as {java,type}script.glimmer
" Vim will read the javascript/typescript syntax files first and set
" b:current_syntax accordingly then it will read the glimmer syntax file.
" This is why we use b:current_syntax to make sure we are in the correct state
" to continue.

if exists('b:current_syntax') && b:current_syntax !~# "\\v%(type|java)script"
  finish
endif

let base_syntax = b:current_syntax
unlet! b:current_syntax

let s:cpo_save = &cpo
set cpo&vim

if base_syntax == "javascript"
  " handlebars reads html which is weirdly dependednt on not having
  " a main_syntax
  syntax include @hbs syntax/handlebars.vim

  syntax region glimmerTemplateBlock
    \ start="<template>" end="</template>"
    \ contains=@hbs
    \ keepend fold

  let b:current_syntax = "javascript.glimmer"
else
  " syntax/typescript.vim adds typescriptTypeCast which is in conflict with
  " <template> typescriptreact doesn't define it but we want to not include
  " the JSX syntax. clear the previous loaded typescript and start fresh with
  " typescriptcommon
  syntax clear

  " syntax/shared/typescriptcommon.vim requires this to be set
  let main_syntax = base_syntax
  runtime! syntax/shared/typescriptcommon.vim
  unlet main_syntax

  " handlebars reads html which is weirdly dependednt on not having
  " a main_syntax
  syntax include @hbs syntax/handlebars.vim

  syntax region glimmerTemplateBlock
    \ start="<template>" end="</template>"
    \ contains=@hbs
    \ containedin=typescriptClassBlock,typescriptFuncCallArg
    \ keepend fold

  let b:current_syntax = "typescript.glimmer"
endif

let &cpo = s:cpo_save
unlet s:cpo_save
unlet! base_syntax
