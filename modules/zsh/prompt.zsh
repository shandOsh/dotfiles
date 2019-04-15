#   -------------------------------
#   7.  PROMPT
#   -------------------------------

    DOTFILES_PROMPT_COMPONENTS=()
    DOTFILES_PROMPT_COMPONENT_LEFT="─["
    DOTFILES_PROMPT_COMPONENT_RIGHT="]"

#   ___ time ___
    dotfiles_prompt_time=""
    dotfiles_prompt_time+="${DOTFILES_PROMPT_COMPONENT_LEFT}"
    dotfiles_prompt_time+="$(format_message --prompt --bold "%*")"
    dotfiles_prompt_time+="${DOTFILES_PROMPT_COMPONENT_RIGHT}"

    prompt_component_append "${dotfiles_prompt_time}"

#   ___ username + hostname ___
    dotfiles_prompt_username_hostname=""
    dotfiles_prompt_username_hostname+="${DOTFILES_PROMPT_COMPONENT_LEFT}"

    # highlight the username when logged in as root
    if [[ "${UID}" -eq 0 ]]; then
        dotfiles_prompt_username_hostname+="$(format_message --prompt --bold --color red "%n")"
    else
        dotfiles_prompt_username_hostname+="$(format_message --prompt --bold "%n")"
    fi

    dotfiles_prompt_username_hostname+="$(format_message --prompt --bold "@")"
    dotfiles_prompt_username_hostname+="$(format_message --prompt --bold "%M")"
    dotfiles_prompt_username_hostname+="${DOTFILES_PROMPT_COMPONENT_RIGHT}"

    prompt_component_append "${dotfiles_prompt_username_hostname}"

#   ___ working directory full path ___
    dotfiles_prompt_pwd=""
    dotfiles_prompt_pwd+="${DOTFILES_PROMPT_COMPONENT_LEFT}"
    dotfiles_prompt_pwd+="$(format_message --prompt --bold "%~")"
    dotfiles_prompt_pwd+="${DOTFILES_PROMPT_COMPONENT_RIGHT}"

    prompt_component_append "${dotfiles_prompt_pwd}"

#   ___ prompt generation ___
    function prompt_generate() {
        PS1=""
        PS1+=$'\n' # first line
        PS1+="┌──"

        for component in ${DOTFILES_PROMPT_COMPONENTS[@]}; do
            PS1+="${component}"
        done

        PS1+=$'\n'
        PS1+="└─> "

        PS2="└─> "
    }

#   ___ generate the prompt ___
    prompt_generate
