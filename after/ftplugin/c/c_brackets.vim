"=============================================================================
" File:		{rtp}/after/ftplugin/c/c_brackets.vim                   {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://hermitte.free.fr/vim/>
" Version:	0.1
" Created:	26th May 2004
" Last Update:	26th May 2004
"------------------------------------------------------------------------
" Description:	
" 	c-ftplugin that defines the default preferences regarding the
" 	bracketing mappings we want to use.
" 
"------------------------------------------------------------------------
" Installation:	
" 	This particular file is meant to be into {rtp}/after/ftplugin/c/
" 	In order to overidde these default definitions, copy this file into a
" 	directory that comes before the {rtp}/after/ftplugin/c/ you choosed --
" 	typically $HOME/.vim/ftplugin/c/ (:h 'rtp').
" 	Then, replace the assignements lines 43+
" History:	«history»
" TODO:		«missing features»
" }}}1
"=============================================================================


"=============================================================================
" Avoid buffer reinclusion {{{1
if exists('b:loaded_ftplug_c_brackets_vim')
  finish
endif
let b:loaded_ftplug_c_brackets_vim = 1
 
let s:cpo_save=&cpo
set cpo&vim
" }}}1
"------------------------------------------------------------------------
" Brackets & all {{{
" ------------------------------------------------------------------------
if !exists('*Brackets')
  runtime plugin/common_brackets.vim
endif
if exists('*Brackets')
  let b:cb_parent  = 1
  let b:cb_bracket = 1
  let b:cb_acco    = 1
  let b:cb_quotes  = 2
  let b:cb_Dquotes = 1
  let b:usemarks   = 1
  " Re-run brackets() in order to update the mappings regarding the different
  " options.
  call Brackets()
endif

" }}}
"=============================================================================
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
