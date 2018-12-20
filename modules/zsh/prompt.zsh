#   -------------------------------
#   2.  PROMPT
#   -------------------------------

    # inspired by mathiasbynens (https://github.com/mathiasbynens/dotfiles/blob/master/.bash_prompt)
    PS1=""
    PS1+="________________________________________________________________________________" # first line
    PS1+=$'\n'
    PS1+="| "

    # highlight the user name when logged in as root
    if [[ "${UID}" -eq 0 ]]; then
        PS1+="$(format_message --bold --color red "%n")" # username
    else
        PS1+="%n" # username
    fi

    PS1+="@"
    PS1+="%M" # hostname
    PS1+=" "
    PS1+="[%d]" # working directory full path
    PS1+=$'\n'
    PS1+="| => "

    export PS1
    export PS2="| => "
