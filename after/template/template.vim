VimL: "Vim Template, Luc Hermitte, Last change: 11th May 2004
VimL: let s:value_start = '¡'
VimL: let s:value_end   = '¡'
"=============================================================================
" File:		¡expand("%:t")¡                                           {{{1
" Author:	¡Author()¡
" Version:	¡Marker_Txt("version")¡
" Created:	¡DateStamp()¡
" Last Update:	¡DateStamp()¡
"------------------------------------------------------------------------
" Description:	¡Marker_Txt("description")¡
" 
"------------------------------------------------------------------------
" Installation:	¡Marker_Txt("install details")¡
" History:	¡Marker_Txt("history")¡
" TODO:		¡Marker_Txt("missing features")¡
" }}}1
"=============================================================================


VimL: let s:ftplug = 2 - (expand('%:p') =~ 'ftplugin')
VimL: let s:ftplug = CONFIRM("Is this script an ftplugin ?", "&Yes\n&No", s:ftplug)==1
VimL: let s:fn = substitute(expand("%:t"),'\W', '_', 'g') 
"=============================================================================
" Avoid ¡IF(s:ftplug, "buffer", "global")¡ reinclusion {{{1
¡IF (s:ftplug, "if exists('b:loaded_ftplug_". s:fn."')", "")¡
¡IF (s:ftplug, "       \\\\ && !exists('g:force_reload_".s:fn."')", "")¡
¡IF (s:ftplug, "  finish", "")¡
¡IF (s:ftplug, "endif", "")¡
¡IF (s:ftplug, "let b:loaded_ftplug_".s:fn." = 1", "" )¡
¡IF (s:ftplug, ' ', "" )¡
¡IF (s:ftplug, 'let s:cpo_save=&cpo', "" )¡
¡IF (s:ftplug, 'set cpo&vim', "" )¡
¡IF (s:ftplug, '" }}}1', "" )¡
VimL: if s:ftplug | exe "normal O\"\<esc>73a-\<esc>D" | endif 
¡IF (s:ftplug, '" Commands and mappings {{{1', "" )¡
¡IF (s:ftplug, Marker_Txt("Buffer relative definitions"), "" )¡
¡IF (s:ftplug, " ", "" )¡
¡IF (s:ftplug, '" Commands and mappings }}}1', "" )¡
VimL: if s:ftplug | exe "normal O\"\<esc>78a=\<esc>D" | endif 
¡IF (s:ftplug, '" Avoid global reinclusion {{{1', "" )¡
if exists("s:loaded_¡s:fn¡") 
      \ && !exists('g:force_reload_¡s:fn¡')
¡IF (s:ftplug, "  let &cpo=s:cpo_save", "" )¡
  finish 
endif
let s:loaded_¡s:fn¡ = 1
¡IF (!s:ftplug, 'let s:cpo_save=&cpo', "" )¡
¡IF (!s:ftplug, 'set cpo&vim', "" )¡
" Avoid global reinclusion }}}1
"------------------------------------------------------------------------
" Functions {{{1
¡Marker_Txt("Global definitions -- like functions")¡

" Functions }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
