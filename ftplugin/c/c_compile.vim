"=============================================================================
" File:		c_compile.vim                                           {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://hermitte.free.fr/vim/>
" Version:	«version»
" Created:	09th Mar 2004
" Last Update:	15th Jun 2004
"------------------------------------------------------------------------
" Description:	Helpers mappings to build and execute C & C++ programs
" 
"------------------------------------------------------------------------
" Installation:	Drop this file into your {rtp}/ftplugin/c/ directory
"	Works better if menu-maps.vim is installed
"	Requires ui-functions.vim
" History:	«history»
" TODO:		«missing features»
" }}}1
"=============================================================================


"=============================================================================
" Avoid buffer reinclusion {{{1
if exists('b:loaded_ftplug_c_compile_vim')
       \ && !exists('g:force_reload_c_compile_vim')
  finish
endif
let b:loaded_ftplug_c_compile_vim = 1
 
" Only C & C++ ; Not Java and other children of C I haven't checked yet
if &ft !~ '^c\%(pp\)\=$'
  finish
endif

let s:cpo_save=&cpo
set cpo&vim
" }}}1
"------------------------------------------------------------------------
" Options {{{1
 
" Options }}}1
"------------------------------------------------------------------------
" Commands and mappings {{{1

if !exists('*MenuMake')
  runtime macros/menu-map.vim plugin/menu-map.vim
endif
if !exists('*MenuMake')
  nnoremap <buffer> <F7> :call <sid>Compile()<cr>
  inoremap <buffer> <F7> <c-o>:call <sid>Compile()<cr>

  nnoremap <buffer> <C-F5> :call <sid>Execute()<cr>
  inoremap <buffer> <C-F5> <c-o>:call <sid>Execute()<cr>

  nnoremap <buffer> <M-F7> : call <sid>AddLetModeline()<cr>
else
  command! -b -nargs=0 Make           :call <sid>Compile()
  command! -b -nargs=0 Execute        :call <sid>Execute()
  command! -b -nargs=0 AddLetModeline :call <sid>AddLetModeline()
  let b:want_buffermenu_or_global_disable = 0
  " 0->no ; 1->yes ; 2->global disable
  call MenuMake('n', '50.10', '&Cpp.&Config', '<M-F7>',
	\ '<buffer>', ':AddLetModeline<cr>')
  amenu 50.10 &Cpp.--<sep>-- Nop
  call MenuMake('ni', '50.30', '&Cpp.&Make project', '<F7>',
	\ '<buffer>', ':Make<cr>')
  call MenuMake('ni', '50.50', '&Cpp.&Execute', '<C-F5>',
	\ '<buffer>', ':Execute<cr>')
endif

" Commands and mappings }}}1
"=============================================================================
" Avoid global reinclusion {{{1
if exists("s:loaded_c_compile_vim") 
      \ && !exists('g:force_reload_c_compile_vim')
  let &cpo=s:cpo_save
  finish 
endif
let s:loaded_c_compile_vim = 1
" Avoid global reinclusion }}}1
"------------------------------------------------------------------------
" Functions {{{1

" Function: s:ProjectName()          {{{2
" How to define this option:
" - with a _vimrc_local file
" - with a let modeline
function! s:ProjectName()
  if     exists('b:c_project') | return b:c_project
  elseif exists('g:c_project') | return g:c_project
  else 
    if &ft == 'qf' | return '#<'
    else           | return '%<'
    endif
  endif
endfunction


" Load mappings for quickfix windows {{{2
augroup compile
  au!
  au FileType qf :call <sid>DefQuickFixMappings()
augroup END

function! s:DefQuickFixMappings()
  nnoremap <buffer> <F7> :call <sid>CompileQF()<cr>
  inoremap <buffer> <F7> <c-o>:call <sid>CompileQF()<cr>

  nnoremap <buffer> <C-F5> :call <sid>Execute()<cr>
  inoremap <buffer> <C-F5> <c-o>:call <sid>Execute()<cr>
endfunction


" Function: s:Compile()              {{{2
function! s:Compile()
    update
    exe 'make '. s:ProjectName()
    cwin
endfunction

" Function: s:CompileQF()            {{{2
function! s:CompileQF()
  bw
  call s:Compile()
endfunction

" Function: s:Execute()              {{{2
let s:ext = has('windows') ? '.exe' : ''
function! s:Execute()
  exe ':!./' . s:ProjectName() . s:ext
endfunction

" Function: s:ExecuteQF()            {{{2
function! s:ExecuteQF()
  :!./#<.exe
endfunction
" }}}2

" Function: s:AddLetModeline()       {{{2
" Meant to be used with let-modeline.vim
function! s:AddLetModeline()
  let which = WHICH('COMBO', 'Which option must be set ?', 
	\ "Abort\nEdit &Makefile"
	\ . "\n$&CFLAGS\n$C&PPFLAGS\n$C&XXFLAGS"
	\ . "\n$L&DFLAGS\n$LD&LIBS"
	\ . "\n&g:project\n&b:project"
	\ )
  if which =~ 'Abort\|^$' 
    " Nothing to do
  elseif which == 'Edit Makefile'
    sp Makefile
  else
    below split
    let s = search('Vim:\s*let\s\+.*'.which.'\s*=\zs')
    if s <= 0
      let l = '// Vim: let '.which."='".Marker_Txt(which)."'"
      silent $put=l
    endif
  endif
endfunction

" Functions }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
