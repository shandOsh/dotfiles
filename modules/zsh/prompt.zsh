#   -------------------------------
#   2.  PROMPT
#   -------------------------------

    PS1=""
    PS1+="________________________________________________________________________________" # first line
    PS1+=$'\n'
    PS1+="| "
    PS1+="%n" # username
    PS1+="@"
    PS1+="%M" # hostname
    PS1+=" "
    PS1+="[%d]" # working directory full path
    PS1+=$'\n'
    PS1+="| => "

    export PS1
    export PS2="| => "
