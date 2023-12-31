" vim600: set foldmethod=marker:
"
" SVN extension for VCSCommand.
"
" Version:       VCS development
" Maintainer:    Bob Hiestand <bob.hiestand@gmail.com>
" License:
" Copyright (c) 2007 Bob Hiestand
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
" IN THE SOFTWARE.
"
" Section: Documentation {{{1
"
" Command documentation {{{2
"
" The following command only applies to files under SVN source control.
"
" SVNInfo          Performs "svn info" on the current file.
"
" Mapping documentation: {{{2
"
" By default, a mapping is defined for each command.  User-provided mappings
" can be used instead by mapping to <Plug>CommandName, for instance:
"
" nnoremap ,si <Plug>SVNInfo
"
" The default mappings are as follow:
"
"   <Leader>si SVNInfo
"
" Options documentation: {{{2
"
" VCSCommandSVNExec
"   This variable specifies the SVN executable.  If not set, it defaults to
"   'svn' executed from the user's executable path.
"
" VCSCommandSVNDiffExt
"   This variable, if set, sets the external diff program used by Subversion.
"
" VCSCommandSVNDiffOpt
"   This variable, if set, determines the options passed to the svn diff
"   command (such as 'u', 'w', or 'b').

if v:version < 700
  finish
endif

" Section: Variable initialization {{{1

let s:svnFunctions = {}

" Section: Utility functions {{{1

" Function: s:DoCommand(cmd, cmdName, statusText) {{{2
" Wrapper to VCSCommandDoCommand to add the name of the SVN executable to the
" command argument.
function! s:DoCommand(cmd, cmdName, statusText)
  try
    if VCSCommandGetVCSType(expand('%')) == 'SVN'
      let fullCmd = VCSCommandGetOption('VCSCommandSVNExec', 'svn') . ' ' . a:cmd
      return VCSCommandDoCommand(fullCmd, a:cmdName, a:statusText)
    else
      throw 'No suitable plugin'
    endif
  catch /No suitable plugin/
    echohl WarningMsg|echomsg 'Cannot apply SVN commands to this file.'|echohl None
  endtry
endfunction

" Section: VCS function implementations {{{1

" Function: s:svnFunctions.Identify(buffer) {{{2
function! s:svnFunctions.Identify(buffer)
  let fileName = resolve(bufname(a:buffer))
  if isdirectory(fileName)
    let directory = fileName
  else
    let directory = fnamemodify(fileName, ':h')
  endif
  if strlen(directory) > 0
    let svnDir = directory . '/.svn'
  else
    let svnDir = '.svn'
  endif
  if isdirectory(svnDir)
    return 1
  else
    return 0
  endif
endfunction

" Function: s:svnFunctions.Add() {{{2
function! s:svnFunctions.Add(argList)
  return s:DoCommand(join(['add'] + a:argList, ' '), 'add', join(a:argList, ' '))
endfunction

" Function: s:svnFunctions.Annotate(argList) {{{2
function! s:svnFunctions.Annotate(argList)
  if len(a:argList) == 0
    if &filetype == 'SVNAnnotate'
      " Perform annotation of the version indicated by the current line.
      let revision = matchstr(getline('.'),'\v^\s+\zs\d+')
    else
      let revision=VCSCommandGetRevision()
      if revision == ''
        throw 'Unable to obtain version information.'
      elseif revision == 'Unknown'
        throw 'File not under source control'
      elseif revision == 'New'
        throw 'No annotatation available for new file.'
      endif
    endif
  else
    let revision=a:argList[0]
  endif

  let resultBuffer=s:DoCommand('blame -r' . revision, 'annotate', revision) 
  if resultBuffer > 0
    set filetype=SVNAnnotate
  endif
  return resultBuffer
endfunction

" Function: s:svnFunctions.Commit(argList) {{{2
function! s:svnFunctions.Commit(argList)
  let resultBuffer = s:DoCommand('commit -F "' . a:argList[0] . '"', 'commit', '')
  if resultBuffer == 0
    echomsg 'No commit needed.'
  endif
endfunction

" Function: s:svnFunctions.Delete() {{{2
function! s:svnFunctions.Delete(argList)
  return s:DoCommand(join(['delete'] + a:argList, ' '), 'delete', join(a:argList, ' '))
endfunction

" Function: s:svnFunctions.Diff(argList) {{{2
function! s:svnFunctions.Diff(argList)
  if len(a:argList) == 1
    let revOptions = ' -r' . a:argList[0]
    let caption = '(' . a:argList[0] . ' : current)'
  elseif len(a:argList) == 2
    let revOptions = ' -r' . a:argList[0] . ':' . a:argList[1]
    let caption = '(' . a:argList[0] . ' : ' . a:argList[1] . ')'
  else
    let revOptions = ''
    let caption = ''
  endif

  let svndiffext = VCSCommandGetOption('VCSCommandSVNDiffExt', '')
  if svndiffext == ''
    let diffextstring = ''
  else
    let diffextstring = ' --diff-cmd ' . svndiffext . ' '
  endif

  let svndiffopt = VCSCommandGetOption('VCSCommandSVNDiffOpt', '')

  if svndiffopt == ''
    let diffoptionstring = ''
  else
    let diffoptionstring = ' -x -' . svndiffopt . ' '
  endif

  let resultBuffer = s:DoCommand('diff' . diffextstring . diffoptionstring . revOptions , 'diff', caption)
  if resultBuffer > 0
    set filetype=diff
  else
    if svndiffext == ''
      echomsg 'No differences found'
    endif
  endif
  return resultBuffer
endfunction

" Function: s:svnFunctions.GetBufferInfo() {{{2
" Provides version control details for the current file.  Current version
" number and current repository version number are required to be returned by
" the vcscommand plugin.
" Returns: List of results:  [revision, repository, branch]

function! s:svnFunctions.GetBufferInfo()
  let originalBuffer=VCSCommandGetOriginalBuffer(bufnr('%'))
  let fileName=bufname(originalBuffer)
  let realFileName = fnamemodify(resolve(fileName), ':t')
  if !filereadable(fileName)
    return ['Unknown']
  endif
  let oldCwd=VCSCommandChangeToCurrentFileDir(fileName)
  try
    let statusText=system(VCSCommandGetOption('VCSCommandSVNExec', 'svn') . ' status -vu "' . realFileName . '"')
    if(v:shell_error)
      return []
    endif

    " File not under SVN control.
    if statusText =~ '^?'
      return ['Unknown']
    endif

    let [flags, revision, repository] = matchlist(statusText, '^\(.\{8}\)\s\+\(\S\+\)\s\+\(\S\+\)\s\+\(\S\+\)\s')[1:3]
    if revision == ''
      " Error
      return ['Unknown']
    elseif flags =~ '^A'
      return ['New', 'New']
    else
      return [revision, repository]
    endif
  finally
    execute 'cd' escape(oldCwd, ' ')
  endtry
endfunction

" Function: s:svnFunctions.Lock(argList) {{{2
function! s:svnFunctions.Lock(argList)
  return s:DoCommand(join(['lock'] + a:argList, ' '), 'lock', join(a:argList, ' '))
endfunction

" Function: s:svnFunctions.Log() {{{2
function! s:svnFunctions.Log(argList)
  if len(a:argList) == 0
    let versionOption = ''
    let caption = ''
  elseif len(a:argList) == 1 && a:argList[0] !~ "^-"
    let versionOption=' -r' . a:argList[0]
    let caption = a:argList[0]
  else
    " Multiple options, or the option starts with '-'
    let caption = join(a:argList, ' ')
    let versionOption = ' ' . caption
  endif

  let resultBuffer=s:DoCommand('log -v' . versionOption, 'log', caption)
  return resultBuffer
endfunction

" Function: s:svnFunctions.Revert(argList) {{{2
function! s:svnFunctions.Revert(argList)
  return s:DoCommand('revert', 'revert', '')
endfunction

" Function: s:svnFunctions.Review(argList) {{{2
function! s:svnFunctions.Review(argList)
  if len(a:argList) == 0
    let versiontag = '(current)'
    let versionOption = ''
  else
    let versiontag = a:argList[0]
    let versionOption = ' -r ' . versiontag . ' '
  endif

  let resultBuffer = s:DoCommand('cat' . versionOption, 'review', versiontag)
  if resultBuffer > 0
    let &filetype=getbufvar(b:VCSCommandOriginalBuffer, '&filetype')
  endif
  return resultBuffer
endfunction

" Function: s:svnFunctions.Status(argList) {{{2
function! s:svnFunctions.Status(argList)
  if len(a:argList) == 0
    let a:argList = ['-u', '-v']
  endif
  return s:DoCommand(join(['status -u -v'] + a:argList, ' '), 'status', join(a:argList, ' '))
endfunction

" Function: s:svnFunctions.Unlock(argList) {{{2
function! s:svnFunctions.Unlock(argList)
  return s:DoCommand(join(['unlock'] + a:argList, ' '), 'unlock', join(a:argList, ' '))
endfunction
" Function: s:svnFunctions.Update(argList) {{{2
function! s:svnFunctions.Update(argList)
  return s:DoCommand('update', 'update', '')
endfunction

" Section: SVN-specific functions {{{1

" Function: s:SVNInfo() {{{2
function! s:SVNInfo(argList)
  return s:DoCommand(join(['info'] + a:argList, ' '), 'svninfo', join(a:argList, ' '))
endfunction

" Section: Command definitions {{{1
" Section: Primary commands {{{2
com! -nargs=* SVNInfo call s:SVNInfo([<f-args>])

" Section: Plugin command mappings {{{1

let s:svnExtensionMappings = {}
let mappingInfo = [['SVNInfo', 'SVNInfo', 'ci']]
for [pluginName, commandText, shortCut] in mappingInfo
  execute 'nnoremap <silent> <Plug>' . pluginName . ' :' . commandText . '<CR>'
  if !hasmapto('<Plug>' . pluginName)
    let s:svnExtensionMappings[shortCut] = commandText
  endif
endfor

" Section: Menu items {{{1
amenu <silent> &Plugin.VCS.SVN.&Info       <Plug>SVNInfo

" Section: Plugin Registration {{{1
" If the vcscommand.vim plugin hasn't loaded, delay registration until it
" loads.
if exists('g:loaded_VCSCommand')
  call VCSCommandRegisterModule('SVN', expand('<sfile>'), s:svnFunctions, s:svnExtensionMappings)
else
  augroup VCSCommand
    au User VCSLoadExtensions call VCSCommandRegisterModule('SVN', expand('<sfile>'), s:svnFunctions, s:svnExtensionMappings)
  augroup END
endif
