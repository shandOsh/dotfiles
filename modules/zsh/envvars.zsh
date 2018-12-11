#   -------------------------------
#   2.  ENVIRONMENT CONFIGURATION
#   -------------------------------

#   ___ prompt ___
    export PS1="________________________________________________________________________________"$'\n'"| %n@%M [%d] "$'\n'"| => "
    export PS2="| => "

#   ___ default editor ___
    export EDITOR=vim

#   ___ default blocksize for ls, df, du ___
    export BLOCKSIZE=1k

#   ___ add color to terminal ___
    export CLICOLOR=1
    export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
