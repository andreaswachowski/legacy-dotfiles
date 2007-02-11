" -- General settings -----------------------------------------------------
let s:host_specific_pre_setup = expand("<sfile>").".host.pre.".hostname()
if findfile(s:host_specific_pre_setup,"<sfile>:%h") != ""
  source `=expand(s:host_specific_pre_setup)`
endif
unlet s:host_specific_pre_setup

set nohlsearch
set visualbell
set autoindent
set incsearch
set sidescroll=1
" FIXME:exrc is not necessary if I am in $HOME/.vim
" Then, the whole configuration will be sourced twice.
set exrc " enable reading of local .vimrc and .exrc files
set winminheight=0 " minimize a window to just its status bar
set textwidth=75
set statusline=%f%m%=%l

" Vim Tip 173: Quick movement between split windows
nmap <c-l> <c-w>l
nmap <c-h> <c-w>h
nmap <c-k> <c-w>k
nmap <c-j> <c-w>j

let g:netrw_alto = 1 " split below the file browser
filetype plugin indent on

au BufReadPost quickfix  set nowrap

if &t_Co > 2 || has("gui_running")
  syntax on
  highlight Statement ctermfg=1
endif
if &t_Co >= 256 || has("gui_running")
  colorscheme default256
endif
if has("gui_running")
  set guioptions-=m " remove menu bar
  set guioptions-=T " remove tool bar
endif

highlight Visual term=reverse ctermbg=White guibg=White

" filetype for Supermemo Databases:
au BufRead,BufNewFile *.smd		setfiletype smd

source <sfile>.handling_gzip
source <sfile>.tip343_large_files
source <sfile>.tip112_indentation_helper

" -- OS-specific settings -------------------------------------------------
let s:os = "unknown"
if has("mac")
  let s:os="mac"
elseif has("unix")
  let s:os="unix"
elseif has("win32")
  let s:os="win32"
" else nothing specific to be done.
endif
if s:os != "unknown"
  let s:os_specific_setup = expand("<sfile>").".os.".s:os
  if findfile(s:os_specific_setup,"<sfile>:%h") != ""
    source `=expand(s:os_specific_setup)`
  endif
  unlet s:os_specific_setup
endif
unlet s:os

" -- host-specific settings -----------------------------------------------
let s:host_specific_setup = expand("<sfile>").".host.".hostname()
if findfile(s:host_specific_setup,"<sfile>:%h") != ""
  source `=expand(s:host_specific_setup)`
endif
unlet s:host_specific_setup
