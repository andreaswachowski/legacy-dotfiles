" ========================================================================
" File:			c_set.vim
" Author:		Luc Hermitte <MAIL:hermitte {at} free {dot} fr>
" 			<URL:http://hermitte.free.fr/vim/>
"
" Last Update:		26th May 2004
"
" Purpose:		ftplugin for C (-like) programming
"
" Dependancies:		misc_map.vim
" 			common_brackets.vim
" 			a.vim			-- alternate files
" 			LoadHeaderFile.vim	
" 			flist & flistmaps.vim	-- Dr Chips
" 			VIM >= 6.00 only
" ========================================================================




" ========================================================================
" Buffer local definitions {{{
" ========================================================================
if exists("b:loaded_local_c_settings") && !exists('g:force_reload_c_ftp')
  finish 
endif
let b:loaded_local_c_settings = 1

  "" line continuation used here ??
  let s:cpo_save = &cpo
  set cpo&vim

" ------------------------------------------------------------------------
" Includes {{{
" ------------------------------------------------------------------------
source $VIMRUNTIME/ftplugin/c.vim
let b:did_ftplugin = 1
" }}}
" ------------------------------------------------------------------------
" Options to set {{{
" ------------------------------------------------------------------------
" Note: these options can be overrided into a ftplugin placed in an after/
" directory.
"
setlocal formatoptions=croql
setlocal cindent
setlocal define=^\(#\s*define\|[a-z]*\s*const\s*[a-z]*\)
setlocal comments=sr:/*,mb:*,exl:*/,://
setlocal cinoptions=g0,t0
setlocal isk+=#		" so #if is considered as a keyword, etc

setlocal ch=2
setlocal nosmd

" Dictionary from Dr.-Ing. Fritz Mehner 
let s:dictionary=expand("<sfile>:p:h").'/word.list'
if filereadable(s:dictionary)
  let &dictionary=s:dictionary
  setlocal complete+=k
endif

if !exists('maplocalleader')
  let maplocalleader = ','
endif

runtime syntax/doxygen.vim

" C Doc {{{
if !exists('*s:SearchCDocFolder')
  function! s:SearchCDocFolder(filename)
    let f = substitute(fnamemodify(a:filename, ':p:h'), 
	  \ '[\\/]doc[\\/]\=$', '','')
    if &runtimepath !~ escape(f, '\')
      " exe 'setlocal runtimepath+='.f
      let &runtimepath=f.','.&runtimepath
    endif
  endfunction
endif
command! -buffer -nargs=1 SearchCDocFolder	
      \ :call <SID>SearchCDocFolder("<args>")
if exists(':SearchInRuntime')
  SearchInRuntime! SearchCDocFolder ftplugin/c/doc/*.txt
else
  let f = glob(expand('<sfile>:p:h').'/doc/*.txt')
  if strlen(f)
    :SearchCDocFolder f
  endif
endif
" C Doc }}}
" }}}
" ------------------------------------------------------------------------
" File loading {{{
" ------------------------------------------------------------------------
"
" Things on :A and :AS
""so $VIM/macros/a.vim
"
""so <sfile>:p:h/LoadHeaderFile.vim
if exists("*LoadHeaderFile")
  nnoremap <buffer> <buffer> <C-F12> 
	\ :call LoadHeaderFile(getline('.'),0)<cr>
  inoremap <buffer> <buffer> <C-F12> 
	\ <esc>:call LoadHeaderFile(getline('.'),0)<cr>
endif

" flist (Dr Chips)
""so <sfile>:p:h/flistmaps.vim
if filereadable(expand("hints"))
  au BufNewFile,BufReadPost *.h,*.ti,*.inl,*.c,*.C,*.cpp,*.CPP,*.cxx
	\ so hints<CR>
endif

" }}}
" ------------------------------------------------------------------------
" C keywords {{{
" ------------------------------------------------------------------------
" Pre-processor
"
"-- insert "#define" at start of line
  iab  <buffer> <m-d>  <C-R>=MapNoContext("\<M-d> ",'\<esc\>0i#define')<CR>
  iab  <buffer> #d     <C-R>=MapNoContext("#d ",'\<esc\>0i#define')<CR>
"-- insert "#include" at start of line
  iab  <buffer> <m-i>  <C-R>=MapNoContext("\<M-i> ",'\<esc\>0i#include')<CR>
  iab  <buffer> #n    <C-R>=MapNoContext("#n ",'\<esc\>0i#include')<CR>

"-- insert "#ifdef/endif" at start of line
  iab  <buffer> #i    <C-R>=MapNoContext('#i ','\<esc\>0i#ifdef')<CR>
  iab  <buffer> #e    <C-R>=MapNoContext("#e ",'\<esc\>0i#endif')<CR>

"}}}
" ------------------------------------------------------------------------
" Control statements {{{
" ------------------------------------------------------------------------
"
command! PopSearch :call histdel('search', -1)| let @/=histget('search',-1)

" --- if -----------------------------------------------------------------
"--if    insert "if" statement                   {{{
  Inoreabbr <buffer> <silent> if <C-R>=Def_AbbrC('if ',
	\ '\<c-f\>if (!cursorhere!) {\n!mark!\n}!mark!')<cr>
"--,if    insert "if" statement
  vnoremap <buffer> <silent> <localleader>if 
	\ <c-\><c-n>@=Surround('if (!cursorhere!) {', '}!mark!',
	\ 1, 1, '', 1, 'if ')<cr>
  vnoremap <buffer> <silent> <LocalLeader><localleader>if 
	\ <c-\><c-n>@=Surround('if (', '!cursorhere!) {\n!mark!\n}!mark!',
	\ 0, 1, '', 1, 'if ')<cr>
  " vnoremap <buffer> <LocalLeader>if 
	" \ :call InsertAroundVisual('if () {','}', 1, 1)<cr>gV
      nmap <buffer> <LocalLeader>if V<LocalLeader>if
      nmap <buffer> <LocalLeader><LocalLeader>if V<LocalLeader><LocalLeader>if
" }}}

"--elif  insert «else if () { ... }»             {{{
  Inoreabbr <buffer> <silent> elif <C-R>=Def_AbbrC('elif ',
	\ '\<c-f\>else if (!cursorhere!) {\n!mark!\n}!mark!')<cr>
	" \ '\<c-f\>else if () {\<cr\>!mark!\<cr\>}!mark!\<esc\>?)\<cr\>:PopSearch\<cr\>i')<cr>
"--,elif  insert else clause of if statement with following if statement
  vnoremap <buffer> <silent> <localleader>elif 
	\ <c-\><c-n>@=Surround('else if (!cursorhere!) {', '}!mark!',
	\ 1, 1, '', 1, 'elif ')<cr>
  vnoremap <buffer> <silent> <localleader><localleader>elif 
	\ <c-\><c-n>@=Surround('else if (', '!cursorhere!) {\n!mark!\n}!mark!',
	\ 0, 1, '', 1, 'elif ')<cr>
  " vnoremap <buffer> <LocalLeader>elif 
	" \ :call InsertAroundVisual('else if () {','}', 1, 1)<cr>gV
      nmap <buffer> <localleader><LocalLeader>elif V<localleader><LocalLeader>elif
      nmap <buffer> <LocalLeader>elif V<LocalLeader>elif
" }}}

"--else  insert else clause of if statement      {{{
  Inoreabbr <buffer> <silent> else <C-R>=Def_AbbrC('else ',
	\ '\<c-f\>else {\n}!mark!\<esc\>O')<cr>
	" \ '\<c-f\>else {\n!cursorhere!\n}!mark!')<cr>
"--,else  insert else clause of if statement
  vnoremap <buffer> <silent> <localleader>else
	\ <c-\><c-n>@=Surround('else {', '}',
	\ 1, 1, '``l', 1, 'else ')<cr>
  " vnoremap <buffer> <LocalLeader>else 
	" \ :call InsertAroundVisual('else {','}', 1, 1)<cr>gV
      nmap <buffer> <LocalLeader>else V<LocalLeader>else
" }}}

"--- for ----------------------------------------------------------------
"--for   insert "for" statement                  {{{
" TODO: pb when c_nl_before_bracket = 1, cursor is not placed correctly
  Inoreabbr <buffer> <silent> for <C-R>=Def_AbbrC('for ',
      \ '\<c-f\>for (!cursorhere!;!mark!;!mark!) {\n!mark!\n}!mark!')<cr>
      " \ '\<c-f\>for (;!mark!;!mark!) {\<cr\>!mark!\<cr\>}!mark!\<esc\>?)\<CR\>:PopSearch\<cr\>%a')<cr>
"--,for   insert "for" statement
  vnoremap <buffer> <silent> <localleader>for 
	\ <c-\><c-n>@=Surround('for (!cursorhere!;!mark!;!mark!) {', '}!mark!',
	\ 1, 1, '', 1, 'for ')<cr>
  " vnoremap <buffer> <LocalLeader>for 
	" \ :call InsertAroundVisual('for (;;) {','}', 1, 1)<cr>gV
      nmap <buffer> <LocalLeader>for V<LocalLeader>for
" }}}

"--- while --------------------------------------------------------------
"--while insert "while" statement                {{{
  Inoreabbr <buffer> <silent> while <C-R>=Def_AbbrC('while ',
	\ '\<c-f\>while (!cursorhere!) {\n!mark!\n}!mark!')<cr>
	" \ '\<c-f\>while () {\<cr\>!mark!\<cr\>}!mark!\<esc\>?)\<CR\>:PopSearch\<cr\>i')<cr>
"--,while insert "while" statement
  vnoremap <buffer> <silent> <localleader>wh 
	\ <c-\><c-n>@=Surround('while (!cursorhere!) {', '}!mark!',
	\ 1, 1, '', 1, 'while ')<cr>

  vnoremap <buffer> <silent> <localleader><localleader>wh 
	\ <c-\><c-n>@=Surround('while (', 
	\ '!cursorhere!) {\n!mark!\n}!mark!',
	\ 0, 1, '', 1, 'while ')<cr>
  " Note: \<esc\>lcw is used to strip every spaces at the beginning of the
  " selected-area
  " vnoremap <buffer> <LocalLeader>while 
	" \ :call InsertAroundVisual('while () {','}', 1, 1)<cr>gV
      nmap <buffer> <LocalLeader>while V<LocalLeader>while
      nmap <buffer> <LocalLeader><LocalLeader>while V<LocalLeader><LocalLeader>while
" }}}

"--- switch -------------------------------------------------------------
"--switch insert "switch" statement              {{{
  Inoreabbr <buffer> <silent> switch <C-R>=Def_AbbrC('switch ',
	\ '\<c-f\>switch (!cursorhere!) {\n!mark!\n}!mark!')<cr>
	" \ '\<c-f\>switch () {\<cr\>!mark!\<cr\>}!mark!\<esc\>?)\<CR\>:PopSearch\<cr\>i')<cr>
"--,switch insert "switch" statement
  vnoremap <buffer> <silent> <localleader>switch 
	\ <c-\><c-n>@=Surround('switch (!cursorhere!) {\ncase !mark!:',
	\ '}!mark!', 1, 1, '', 1, 'switch ')<cr>
  " vnoremap <buffer> <LocalLeader>switch 
	" \ :call InsertAroundVisual("switch () {\ncase __:",'}', 1, 1)<cr>gV
      nmap <buffer> <LocalLeader>switch V<LocalLeader>switch
" }}}

"--- main ---------------------------------------------------------------
"--Ymain  insert "main" routine
  Iabbr  <buffer> Ymain  int main (int argc, char **argv!jump-and-del!<cr>{
"--,main  insert "main" routine
  map <buffer> <LocalLeader>main  iint main (int argc, char **argv)<cr>{


" --- return -------------------------------------------------------------
"-- <m-r> insert "return ;"
  inoremap <buffer> <m-r> <c-r>=BuildMapSeq('return ;!mark!\<esc\>F;i')<cr>

" --- ?: -------------------------------------------------------------
"-- ?: insert "? : ;"
  inoremap <buffer> ?: <c-r>=BuildMapSeq('() ?!mark!:!mark!\<esc\>F(a')<cr>

"--- Commentaires automatiques -------------------------------------------
"--/* insert /* <curseur>
"             */
  if &syntax !~ "^\(cpp\|java\)$"
    inoreab <buffer> /*  <c-r>=Def_AbbrC('/*',
	  \ '/*\<cr\>\<BS\>/!mark!\<up\>\<end\>')<cr>
  endif

"--/*- insert /*-----[  ]-------*/
  inoreab <buffer> /*- 0<c-d>/*<esc>75a-<esc>a*/<esc>45<left>R[

"--/*= insert /*=====[  ]=======*/
  inoreab <buffer> /*0 0<c-d>/*<esc>75a=<esc>a*/<esc>45<left>R[

"}}}
"}}}
" ========================================================================
" General definitions {{{
" ========================================================================
if exists("s:loaded_c_set_vim") && !exists('g:force_reload_c_ftp')
  let &cpo = s:cpo_save
  finish 
endif
let s:loaded_c_set_vim = 1

" exported function !
function! Def_MapC(key,expr1,expr2)
  if exists('b:usemarks') && b:usemarks
    return "\<c-r>=MapNoContext2('".a:key."',BuildMapSeq('".a:expr2."'))\<cr>"
    " return "\<c-r>=MapNoContext2('".a:key."',BuildMapSeq(\"".a:expr2."\"))\<cr>"
  else
    return "\<c-r>=MapNoContext2('".a:key."', '".a:expr1."')\<cr>"
    " return "\<c-r>=MapNoContext2('".a:key."', \"".a:expr1."\")\<cr>"
  endif
endfunction

function! Def_AbbrC(key,expr)
  let rhs = a:expr
  if exists('g:c_nl_before_bracket') && g:c_nl_before_bracket
    " let rhs = substitute(rhs, '\(BuildMapSeq\)\@<!(', '\\<cr\\>\0', 'g')
    let rhs = substitute(rhs, '\s*(', '\\n(', 'g')
  endif
  if exists('g:c_nl_before_curlyB') && g:c_nl_before_curlyB
    " let rhs = substitute(rhs, '{', '\\<cr\\>\0', 'g')
    let rhs = substitute(rhs, '\s*{', '\\n{', 'g')
  endif
  return InsertSeq(a:key, rhs)
endfunction


" }}}
  let &cpo = s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
