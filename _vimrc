source `=expand("<sfile>").".".hostname()`

" GENERAL SETTINGS
set nohlsearch
set visualbell
set autoindent
set incsearch
set sidescroll=1
set exrc
set winminheight=0
set textwidth=75
"set laststatus=2
set statusline=%f%m%=%l
runtime ftplugin/man.vim

:nmap <F2> :wa<Bar>exe "mksession! " . v:this_session<CR>:1,$bd<CR>:so ~/.vim/sessions/

" The CTRL-] does not work for some reason or another, but I still want
" to jump to topics using the keyboard:
" map <M-9> <C-]>
if &t_Co > 2 || has("gui_running")
  syntax on
  highlight Statement ctermfg=1
endif
if &t_Co >= 256 || has("gui_running")
  colorscheme default256
endif
if has("gui_running")
  set guioptions-=m
  set guioptions-=T
"  set guifont=CMTT8:h12:cSYMBOL
"  set guifont="SUSE Sans Mono 10"
  set lines=45
  set columns=80
endif

" FILETYPE-SPECIFIC SETTINGS
if version< 600
  source <sfile>.less_than_v6
else
  source <sfile>.v6_and_up
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

