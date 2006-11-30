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
filetype plugin indent on
" filetype for Supermemo Databases:
au BufRead,BufNewFile *.smd		setfiletype smd

source <sfile>.handling_gzip
source <sfile>.tip343_large_files
source <sfile>.tip112_indentation_helper
