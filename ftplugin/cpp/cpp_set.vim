" ========================================================================
" File:			cpp_set.vim
" Author:		Luc Hermitte <MAIL:hermitte at free.fr>
" 			<URL:http://hermitte.free.fr/vim/>
"
" Last Update:		28th May 2004
"
" Purpose:		ftplugin for C++ programming
"
" Dependencies:		c_set.vim, misc_map.vim, 
" 			cpp_InsertAccessors.vim,
" 			cpp_BuildTemplates.vim
" 			VIM >= 6.00 only
"
" TODO:		
"  * Menus & Help pour se souvenir des commandes possibles
"  * Support pour l'héritage vis-à-vis des constructeurs
"  * Reconnaître si la classe courante est template vis-à-vis des
"    implementations & inlinings
" ========================================================================


" ========================================================================
" Buffer local definitions
" ========================================================================
if exists("b:loaded_local_cpp_settings") && !exists('g:force_reload_cpp_ftp')
  finish 
endif
let b:loaded_local_cpp_settings = 1

"" line continuation used here ??
let s:cpo_save = &cpo
set cpo&vim

" ------------------------------------------------------------------------
" Commands
" ------------------------------------------------------------------------
" Cf. cpp_BuildTemplates.vim
"
" ------------------------------------------------------------------------
" VIM Includes
" ------------------------------------------------------------------------
if exists("b:did_ftplugin")
  unlet b:did_ftplugin
endif
source $VIMRUNTIME/ftplugin/cpp.vim
let b:did_ftplugin = 1
" runtime! ftplugin/c/*.vim 
" --> need to be sure that some definitions are loaded first!
"     like maplocaleader.

""so $VIMRUNTIME/macros/misc_map.vim

"   
" ------------------------------------------------------------------------
" Options to set
" ------------------------------------------------------------------------
"  setlocal formatoptions=croql
"  setlocal cindent
"
setlocal cinoptions=g0,t0,h1s

" browse filter
if has("gui_win32") 
  let b:browsefilter = 
	\ "C++ Header Files (*.hpp *.h++)\t*.hpp;*.h++\n" .
	\ "C++ Source Files (*.cpp *.c++)\t*.cpp;*.c++\n" .
	\ "C Header Files (*.h)\t*.h\n" .
	\ "C Source Files (*.c)\t*.c\n" .
	\ "All Files (*.*)\t*.*\n"
endif
" ------------------------------------------------------------------------
" Some C++ abbreviated Keywords
" ------------------------------------------------------------------------
Inoreab <buffer> pub public:<CR>
Inoreab <buffer> pro protected:<CR>
Inoreab <buffer> pri private:<CR>

Iabbr <buffer> tpl template <><Left>

inoreab <buffer> vir virtual

inoremap <buffer> <m-s> std::
inoremap <buffer> <m-b> boost::
inoremap <buffer> <m-l> luc_lib::


"--- namespace ----------------------------------------------------------
"--,ns insert "namespace" statement              {{{
  vnoremap <buffer> <LocalLeader>ns 
	\ :call InsertAroundVisual('namespace {','}', 1, 1)<cr>gV
      nmap <buffer> <LocalLeader>ns V<LocalLeader>ns
" }}}

"--- try ----------------------------------------------------------------
"--try insert "try" statement                    {{{
	" \ .'?try\<cr\>o')<CR>
  Inoreabbr <buffer> <silent> try <C-R>=Def_AbbrC('try ',
	\ '\<c-f\>try {\n} catch (!mark!) {!mark!\n}!mark!\<esc\>'
	\ .'?try\<cr\>:PopSearch\<cr\>o')<CR>
	" \ '\<c-f\>try {\n!cursorhere!\n} catch (!mark!) {!mark!\n}!mark!')<cr>
"--,try insert "try - catch" statement
  vnoremap <buffer> <LocalLeader>try 
	\ <c-\><c-n>@=Surround('try {!cursorhere!', '!mark!\n} catch (!mark!) {!mark!\n}', 
	\ 1, 1, '', 1, 'try ')<cr>
	" \ :call InsertAroundVisual('try {',"} catch () {\n}", 1, 1)<cr>gV
      nmap <buffer> <LocalLeader>try V<LocalLeader>try
" }}}

"--- catch --------------------------------------------------------------
"--catch insert "catch" statement                {{{
  Inoreabbr <buffer> catch <C-R>=Def_AbbrC('catch ',
	\ '\<c-f\>catch (!cursorhere!) {!mark!\n}!mark!')<cr>
	" \ '\<c-f\>catch () {!mark!\<cr\>}!mark!\<esc\>?)\<cr\>:PopSearch\<cr\>i')<CR>
  vnoremap <buffer> <LocalLeader>catch 
	\ <c-\><c-n>@=Surround('catch (!cursorhere!) {', '!mark!\n}', 
	\ 1, 1, '', 1, 'catch ')<cr>
      nmap <buffer> <LocalLeader>catch V<LocalLeader>catch
  vnoremap <buffer> <LocalLeader><LocalLeader>catch 
	\ <c-\><c-n>@=Surround('catch (', '!cursorhere!) {!mark!\n}', 
	\ 0, 1, '', 1, 'catch ')<cr>
      nmap <buffer> <LocalLeader><LocalLeader>catch V<LocalLeader><LocalLeader>catch
" }}}

" ------------------------------------------------------------------------
" Comments ; Javadoc/DOC++/Doxygen style
" ------------------------------------------------------------------------
"
" /**       inserts /** <cursor>
"                    */
" but only outside the scope of C++ comments and strings
  inoremap <buffer> /**  <c-r>=Def_MapC('/**',
	\ '/**\<cr\>\<BS\>/\<up\>\<end\> ',
	\ '/**\<cr\>\<BS\>/!mark!\<up\>\<end\> ')<cr>
" /*<space> inserts /** <cursor>*/
  inoremap <buffer> /*<space>  <c-r>=Def_MapC('/* ',
	\ '/** */\<left\>\<left\>',
	\ '/** */!mark!\<esc\>F*i')<cr>

" ------------------------------------------------------------------------
" std oriented stuff
" ------------------------------------------------------------------------
" in std::foreach and std::find algorithms, expand
"   'algo(container§)' into 'algo(container.begin(),container.end()§)', 
" '§' representing the current position of the cursor.
inoremap <c-x>be .<esc>%v%<left>o<right>y%%ibegin(),<esc>paend()<esc>a

" ========================================================================
" General definitions -> none here
" ========================================================================
"if exists("g:loaded_cpp_set_vim") | finish | endif
"let g:loaded_cpp_set_vim = 1

  let &cpo = s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
