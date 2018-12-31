# inspired by mathiasbynens
# https://github.com/mathiasbynens/dotfiles/blob/master/.bash_prompt

# format_message [-b|--bold] [-u|--underline] [-i|--italic] [-s|--strikethrough] [-c|--color=<color-name>] message
function format_message() {
    local bold=0
    local underline=0
    local italic=0
    local strikethrough=0
    local color=""
    local message=""
    local output=""

    # for debug purposes
    if [[ ${DOTFILES_FORMATTING_TPUT} -eq 3 ]]; then
        >&2 echo "> [DEBUG] mode: TPUT"
        DOTFILES_FORMATTING_TPUT=1
        DOTFILES_FORMATTING_DEBUG=1
    elif [[ ${DOTFILES_FORMATTING_TPUT} -eq 2 ]]; then
        >&2 echo "> [DEBUG] mode: non-TPUT"
        DOTFILES_FORMATTING_TPUT=0
        DOTFILES_FORMATTING_DEBUG=1
    else
        DOTFILES_FORMATTING_DEBUG=0

        if tput setaf 1 &> /dev/null; then
            DOTFILES_FORMATTING_TPUT=1
        else
            DOTFILES_FORMATTING_TPUT=0
        fi
    fi

    if [[ ${DOTFILES_FORMATTING_TPUT} -eq 1 ]]; then
        FORMAT_RESET="$(tput sgr0)"

        # general formating
        FORMAT_NORMAL="$(tput sgr0)"
        FORMAT_BOLD="$(tput bold)"
        FORMAT_ITALIC="$(tput sitm)"
        FORMAT_UNDERLINE="$(tput smul)"
        FORMAT_STRIKETHROUGH=""

        # foreground formatting
        # Solarized colors, taken from http://git.io/solarized-colors.
        FORMAT_FOREGROUND_BLACK="$(tput setaf 0)"
        FORMAT_FOREGROUND_RED="$(tput setaf 124)"
        FORMAT_FOREGROUND_GREEN="$(tput setaf 64)"
        FORMAT_FOREGROUND_YELLOW="$(tput setaf 136)"
        FORMAT_FOREGROUND_ORANGE="$(tput setaf 166)"
        FORMAT_FOREGROUND_BLUE="$(tput setaf 33)"
        FORMAT_FOREGROUND_PURPLE="$(tput setaf 125)"
        FORMAT_FOREGROUND_VIOLET="$(tput setaf 61)"
        FORMAT_FOREGROUND_CYAN="$(tput setaf 37)"
        FORMAT_FOREGROUND_WHITE="$(tput setaf 15)"
    else
        # reset formatting
        FORMAT_RESET="\e[0m"

        # general formatting
        FORMAT_NORMAL="0"
        FORMAT_BOLD="1"
        FORMAT_ITALIC="3"
        FORMAT_UNDERLINE="4"
        FORMAT_STRIKETHROUGH="9"

        # foreground formatting
        FORMAT_FOREGROUND_BLACK="30"
        FORMAT_FOREGROUND_RED="31"
        FORMAT_FOREGROUND_GREEN="32"
        FORMAT_FOREGROUND_YELLOW="33"
        FORMAT_FOREGROUND_ORANGE="33"
        FORMAT_FOREGROUND_BLUE="34"
        FORMAT_FOREGROUND_PURPLE="35"
        FORMAT_FOREGROUND_VIOLET="35"
        FORMAT_FOREGROUND_CYAN="36"
        FORMAT_FOREGROUND_WHITE="37"
    fi

    while [[ ${#} -ne 0 ]] && [[ "${1}" != "" ]]; do
        case ${1} in
            -b|--bold)
                if [[ ${DOTFILES_FORMATTING_DEBUG} -eq 1 ]]; then
                    >&2 gecho -E "> [DEBUG] bold: on"
                fi

                bold=1
            ;;

            -u|--underline)
                if [[ ${DOTFILES_FORMATTING_DEBUG} -eq 1 ]]; then
                    >&2 gecho -E "> [DEBUG] underline: on"
                fi

                underline=1
            ;;

            -i|--italic)
                if [[ ${DOTFILES_FORMATTING_DEBUG} -eq 1 ]]; then
                    >&2 gecho -E "> [DEBUG] italic: on"
                fi

                italic=1
            ;;

            -s|--strikethrough)
                if [[ ${DOTFILES_FORMATTING_DEBUG} -eq 1 ]]; then
                    >&2 gecho -E "> [DEBUG] strikethrough: on"
                fi

                strikethrough=1
            ;;

            -c|--color)
                shift

                if [[ ${DOTFILES_FORMATTING_DEBUG} -eq 1 ]]; then
                    >&2 gecho -E "> [DEBUG] color: ${1}"
                fi

                case ${1} in
                    black)
                        color="${FORMAT_FOREGROUND_BLACK}"
                    ;;

                    red)
                        color="${FORMAT_FOREGROUND_RED}"
                    ;;

                    green)
                        color="${FORMAT_FOREGROUND_GREEN}"
                    ;;

                    yellow)
                        color="${FORMAT_FOREGROUND_YELLOW}"
                    ;;

                    orange)
                        color="${FORMAT_FOREGROUND_ORANGE}"
                    ;;

                    blue)
                        color="${FORMAT_FOREGROUND_BLUE}"
                    ;;

                    purple)
                        color="${FORMAT_FOREGROUND_PURPLE}"
                    ;;

                    violet)
                        color="${FORMAT_FOREGROUND_VIOLET}"
                    ;;

                    cyan)
                        color="${FORMAT_FOREGROUND_CYAN}"
                    ;;

                    white)
                        color="${FORMAT_FOREGROUND_WHITE}"
                    ;;
                esac
            ;;

            *)
                message="${1}"
        esac

        shift
    done

    local format_applied=0

    if [[ ${DOTFILES_FORMATTING_TPUT} -eq 0 ]]; then
        output+="\e["
    fi

    if [[ ${bold} -eq 1 ]]; then
        if [[ ${DOTFILES_FORMATTING_TPUT} -eq 0 ]] && [[ ${format_applied} -eq 1 ]]; then
            output+=";"
        fi

        output+="${FORMAT_BOLD}"
        format_applied=1
    fi

    if [[ ${underline} -eq 1 ]]; then
        if [[ ${DOTFILES_FORMATTING_TPUT} -eq 0 ]] && [[ ${format_applied} -eq 1 ]]; then
            output+=";"
        fi

        output+="${FORMAT_UNDERLINE}"
        format_applied=1
    fi

    if [[ ${italic} -eq 1 ]]; then
        if [[ ${DOTFILES_FORMATTING_TPUT} -eq 0 ]] && [[ ${format_applied} -eq 1 ]]; then
            output+=";"
        fi

        output+="${FORMAT_ITALIC}"
        format_applied=1
    fi

    if [[ ${strikethrough} -eq 1 ]]; then
        if [[ ${DOTFILES_FORMATTING_TPUT} -eq 0 ]] && [[ ${format_applied} -eq 1 ]]; then
            output+=";"
        fi

        output+="${FORMAT_STRIKETHROUGH}"
        format_applied=1
    fi

    if [[ ${DOTFILES_FORMATTING_TPUT} -eq 0 ]] && [[ ${format_applied} -eq 1 ]]; then
        output+=";"
    fi

    if [[ "${color}" != "" ]]; then
        output+="${color}"
    elif [[ "${color}" == "" ]] && [[ ${DOTFILES_FORMATTING_TPUT} -eq 0 ]]; then
        output+="0"
    fi

    if [[ ${DOTFILES_FORMATTING_TPUT} -eq 0 ]]; then
        output+="m"
    fi

    output+="${message}"
    output+="${FORMAT_RESET}"

    if [[ ${DOTFILES_FORMATTING_DEBUG} -eq 1 ]]; then
        >&2 gecho -E "> [DEBUG] output: ${output}"
    fi

    printf "${output}"
}
