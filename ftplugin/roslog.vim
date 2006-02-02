" Vim settings file
" Language:	ROS log file
" Version:	0.1
" Last Change:	2006 February 2
" URL:		
" Maintainer:	Andreas Wachowski
" Usage:	Do :help roslog-plugin from Vim

" Only do these settings when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

" Don't do other file type settings for this buffer
let b:did_ftplugin = 1

:function RosLogFolds(num)
:  if a:num == 0
:     return 0
:  else
:     if getline(a:num)=~'.*ENTER.*'
:        return 'a1'
:     else
:        if getline(a:num)=~'.*LEAVE.*'
:           return 's1'
:        else
:           return '='
:endfunction

set foldexpr=RosLogFolds(v:lnum)
set foldmethod=expr
