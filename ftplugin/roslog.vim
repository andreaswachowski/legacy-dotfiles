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

syn region myFold start="ENTER" end="LEAVE" transparent fold
syn sync fromstart
set foldmethod=syntax
