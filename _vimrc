" GENERAL SETTINGS
set nohlsearch
set visualbell
set autoindent
set incsearch
set sidescroll=1
set exrc
set textwidth=75
"set laststatus=2
set statusline=%f%m%=%l
runtime ftplugin/man.vim

" The CTRL-] does not work for some reason or another, but I still want
" to jump to topics using the keyboard:
" map <M-9> <C-]>
if &t_Co > 2 || has("gui_running")
  syntax on
  set guioptions-=m
  set guioptions-=T
  if &term != "cygwin"
    set lines=45
    set columns=80
  endif
  highlight Statement ctermfg=1
endif

" FILETYPE-SPECIFIC SETTINGS
if version< 600
	au BufEnter scratchpad.txt so ~/.vim/scratchpad_in.vim
	au BufEnter activitylog.txt so ~/.vim/activitylog_in.vim
	au BufRead activitylog.txt loadview
	au BufWrite activitylog.txt mkview

	au BufNewFile *.tex 0r ~/.vim/latex.skeleton
	au BufNewFile *.tex 3
	au BufEnter *.tex so ~/.vim/latex_in.vim
	au BufLeave *.tex so ~/.vim/latex_out.vim

	au BufNewFile *.cpp 0r ~/.vim/c.skeleton
	au BufNewFile *.cpp :15
	au BufNewFile *.cpp :r!date +"\%d/\%m/\%y \%H:\%M"
	au BufNewFile *.cpp :15:j
	au BufNewFile *.cpp :15
	au BufEnter *.cpp so ~/.vim/c_in.vim
	au BufLeave *.cpp so ~/.vim/c_out.vim

	au BufNewFile *.C 0r ~/.vim/c.skeleton
	au BufNewFile *.C :15
	au BufNewFile *.C :r!date +"\%d/\%m/\%y \%H:\%M"
	au BufNewFile *.C :15:j
	au BufNewFile *.C :15
	au BufEnter *.C so ~/.vim/c_in.vim
	au BufLeave *.C so ~/.vim/c_out.vim

	au BufNewFile *.H 0r ~/.vim/c.skeleton
	au BufNewFile *.H :15
	au BufNewFile *.H :r!date +"\%d/\%m/\%y \%H:\%M"
	au BufNewFile *.H :15:j
	au BufNewFile *.H :15
	au BufEnter *.H so ~/.vim/c_in.vim
	au BufLeave *.H so ~/.vim/c_out.vim

	au BufNewFile *.cc 0r ~/.vim/c.skeleton
	au BufNewFile *.cc :15
	au BufNewFile *.cc :r!date +"\%d/\%m/\%y \%H:\%M"
	au BufNewFile *.cc :15:j
	au BufNewFile *.cc :15
	au BufEnter *.cc so ~/.vim/c_in.vim
	au BufLeave *.cc so ~/.vim/c_out.vim

	au BufNewFile *.c 0r ~/.vim/c.skeleton
	au BufNewFile *.c :15
	au BufNewFile *.c :r!date +"\%d/\%m/\%y \%H:\%M"
	au BufNewFile *.c :15:j
	au BufNewFile *.c :15
	au BufEnter *.c so ~/.vim/c_in.vim
	au BufLeave *.c so ~/.vim/c_out.vim

	au BufNewFile *.ksh 0r ~/.vim/ksh.skeleton
	au BufNewFile *.ksh :2
	au BufNewFile *.ksh :r!date +"\%d/\%m/\%y \%H:\%M"
	au BufNewFile *.ksh :2:j
	au BufNewFile *.ksh :2
	au BufEnter *.ksh so ~/.vim/ksh_in.vim
	au BufLeave *.ksh so ~/.vim/ksh_out.vim

	au BufNewFile *Tester.java 0r ~/.vim/javatest.skeleton
	"|1,$s/<ClassName>/<ClassName>/ |?^package
	au BufNewFile *.java 0r ~/.vim/java.skeleton
	au BufEnter *.java so ~/.vim/java_in.vim
	au BufLeave *.java so ~/.vim/java_out.vim

	" perl new buffer commands. Do not change order!
	au BufNewFile *.pl 0r ~/.vim/perl.skeleton
	au BufNewFile *.pl :4
	au BufNewFile *.pl :r!date +"\%d/\%m/\%y \%H:\%M"
	au BufNewFile *.pl :4:j
	au BufNewFile *.pl :3
	au BufEnter *.pl so ~/.vim/perl_in.vim
	au BufLeave *.pl so ~/.vim/perl_out.vim

	au BufEnter *.gnuplot so ~/.vim/gnuplot_in.vim
	au BufLeave *.gnuplot so ~/.vim/gnuplot_out.vim
	au BufEnter *.h so ~/.vim/c_in.vim
	au BufLeave *.h so ~/.vim/c_out.vim
	au BufEnter *.txt so ~/.vim/txt_in.vim
	au BufLeave *.txt so ~/.vim/txt_out.vim
	au BufEnter *.cgi so ~/.vim/perl_in.vim
	au BufLeave *.cgi so ~/.vim/perl_out.vim

	" au BufWritePre *.C :6
	" au BufWritePre *.C :s/:.*$/: /
	" au BufWritePre *.C :r!date +"\%d/\%m/\%y \%H:\%M"
	" au BufWritePre *.C :6:j

	" au BufWritePre *.cc :6
	" au BufWritePre *.cc :s/:.*$/: /
	" au BufWritePre *.cc :r!date +"\%d/\%m/\%y \%H:\%M"
	" au BufWritePre *.cc :6:j
else
	" au BufEnter activitylog.txt so ~/.vim/activitylog_in.vim
	au BufRead activitylog.txt loadview
	au BufWrite activitylog.txt mkview

	filetype plugin indent on
endif

augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  "	  read:	set binary mode before reading the file
  "		uncompress text in buffer after reading
  "	 write:	compress file after writing
  "	append:	uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre	*.gz set bin
  autocmd BufReadPost,FileReadPost	*.gz let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost	*.gz set nobin
  autocmd BufReadPost,FileReadPost	*.gz let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r

  autocmd FileAppendPre			*.gz !gunzip <afile>
  autocmd FileAppendPre			*.gz !mv <afile>:r <afile>
  autocmd FileAppendPost		*.gz !mv <afile> <afile>:r
  autocmd FileAppendPost		*.gz !gzip <afile>:r
augroup END

set tags=/export/home/anwa/ctags_dbs/libdss_401.ctags.out

" -----
" The indentation mappings below are taken from VimTip 112.
"
" NextIndent()
"
" Jump to the next or previous line that has the same level or a lower
" level of indentation than the current line.
"
" exclusive (bool):   true:  Motion is exclusive
"                     false: Motion is inclusive
" fwd (bool):         true:  Go to next line
"                     false: Go to previous line
" lowerlevel (bool):  true:  Go to line with lower indentation level
"                     false: Go to line with the same indentation level
" skipblanks (bool):  true:  Skip blank lines
"                     false: Don't skip blank lines

function! NextIndent(exclusive, fwd, lowerlevel, skipblanks)
	let line = line('.')
	let column = col('.')
	let lastline = line('$')
	let indent = indent(line)
	let stepvalue = a:fwd ? 1 : -1

	while (line > 0 && line <= lastline)
		let line = line + stepvalue
		if (	! a:lowerlevel && indent(line) == indent ||
				\ a:lowerlevel && indent(line) < indent)
			if (! a:skipblanks || strlen(getline(line)) > 0)
				if (a:exclusive)
					let line = line - stepvalue
				endif
				exe line
				exe "normal " column . "|"
				return
			endif
		endif
	endwhile
endfunc


" Moving back and forth between lines of same or lower indentation.
nnoremap <silent> [l :call NextIndent(0, 0, 0, 1)<cr>
nnoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<cr>
nnoremap <silent> [L :call NextIndent(0, 0, 1, 1)<cr>
nnoremap <silent> ]L :call NextIndent(0, 1, 1, 1)<cr>
vnoremap <silent> [l <esc>:call NextIndent(0, 0, 0, 1)<cr>m'gv''
vnoremap <silent> ]l <esc>:call NextIndent(0, 1, 0, 1)<cr>m'gv''
vnoremap <silent> [L <esc>:call NextIndent(0, 0, 1, 1)<cr>m'gv''
vnoremap <silent> ]L <esc>:call NextIndent(0, 1, 1, 1)<cr>m'gv''
onoremap <silent> [l :call NextIndent(0, 0, 0, 1)<cr>
onoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<cr>
onoremap <silent> [L :call NextIndent(1, 0, 1, 1)<cr>
onoremap <silent> ]L :call NextIndent(1, 1, 1, 1)<cr>

