" JAVA
" I assume buffer 1 is err.log for "sb 1"
" Also, $MAINDIR is a variable which has to be set appropriately for every
" programming project. This is best done in the _vimrc file in the
" project's home directory
" In the same way, the $CLASSPATH should be set.
"map _j :w:!javac -deprecation -d $MAINDIR/Build % >&err.log:sb 1:e! %
"map _J :sb 2:!java %:r >&exe.log 
"map _t :sb 3:!java junit.ui.TestRunner AllTests
"map _d :!javadoc -classpath e:/junit2.1/junit.jar -sourcepath $MAINDIR/Src -d $MAINDIR/Doc/developer/javadoc % 

" Simpler input for accolades on a German keyboard
imap ö {
imap ä }

" Abbreviations and mappings for general commands
imap __pr System.out.println();hi
" Abbreviations and mappings for Junit:
" new test method
imap __tstm public void test() {}kf(i
imap __exc try {} catch ( RpmsMsgException e ) {System.out.println( "Exception: " + e );e.printStackTrace();}4ko

" Everything else
set shiftwidth=4
set tabstop=4
set cindent
"set shell=C:\Tools\tcsh\tcsh.exe
"set shellcmdflag=-c
"set shellxquote=\"
" set shellxquote is enabled by default
" because of the tcsh Shell
" Or perhaps not? -- 7/11/1999
"set shellslash
set showmatch
syntax on
