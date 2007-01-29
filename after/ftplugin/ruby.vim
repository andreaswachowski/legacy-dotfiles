set showmatch
set tabstop=2
set shiftwidth=2
set expandtab

function! Rspec()
  execute "!spec ".bufname("%")." -l ".search("^ *specify","bc")
endfunction

function! RspecFile()
  execute "!spec ".bufname("%")
endfunction

com! -nargs=0 Rspec call Rspec()
com! -nargs=0 RspecFile call RspecFile()

runtime after/ftplugin/ruby-block-conv.txt

let g:rubycomplete_rails = 1
