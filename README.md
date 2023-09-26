These are my legacy dotfiles pre-2008.

They actually only include vim configuration, which is all I versioned at the
time. The repository was initially CVS (apparently started to version in 2004),
then Subversion, initialized inside `~/.vim`. To get around the problem of how
to version `~/.vimrc` (which is outside of `~/.vim`), it only included one line,
`source ~/.vim/_vimrc`. So `_vimrc` is the starting point to understand the
contents of this repo.

The commits have been restored and converted with git-svn from an SVN-dumpfile
dated 2008-06-30.
