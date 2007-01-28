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

" -- OS-specific settings -------------------------------------------------
let s:os = "unknown"
if has("unix")
  let s:os="unix"
elseif has("win32")
  let s:os="win32"
elseif has("macunix")
  let s:os="macunix"
" else nothing specific to be done.
endif
if s:os != "unknown"
  let s:os_specific_setup = expand("<sfile>").".os.".s:os
  echo s:os_specific_setup
  if findfile(s:os_specific_setup,"<sfile>:%h") != ""
    source `=expand(s:os_specific_setup)`
  endif
  unlet s:os_specific_setup
endif
unlet s:os

" -- host-specific settings -----------------------------------------------
let s:host_specific_setup = expand("<sfile>").".".hostname()
if findfile(s:host_specific_setup,"<sfile>:%h") != ""
  source `=expand("<sfile>").".host.".hostname()`
endif
unlet s:host_specific_setup
