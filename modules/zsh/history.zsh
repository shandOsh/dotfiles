#   -----------------------------
#   6.  HISTORY
#   -----------------------------

    export HISTFILE="${HOME}/.zhistory"
    export HISTSIZE=1000
    export SAVEHIST=1000

    setopt incappendhistory                     # append history to history files as soon as it is executed rather than waiting until shell exits
    setopt histignoredups                       # dont save command if it's a duplicate of last command
