#   -----------------------------
#   4.  ALIASES
#   -----------------------------

    alias cp='nocorrect cp -iv'                 # preferred 'cp' implementation
    alias mv='nocorrect mv -iv'                 # preferred 'mv' implementation
    alias rm='nocorrect rm -iv'                 # preferred 'rm' implementation
    alias mkdir='nocorrect mkdir -pv'           # preferred 'mkdir' implementation
    alias ll='ls -FlAhp'                        # preferred 'll' implementation
    alias less='less -FSRX'                     # preferred 'less' implementation

    alias hist='history'                        # shortcut for history
    alias path='echo -e ${PATH//:/\\n}'         # path: echo all executable paths

    alias sudo=$'sudo\t'                        # this tricks allows using other aliases with sudo
                                                # $'sudo\t' is to prevent "sudo: nocorrect: command not found" error

    case "${DOTFILES_OS}" in
        "${DOTFILES_OS_LINUX}"|"${DOTFILES_OS_AIX}")
            alias ls='ls --color'               # preferred 'ls' implementation
        ;;
    esac

    alias tree='tree -a -I .git'                # preferred 'tree' implementation

#   -----------------------------
#   5.  FUNCTIONS
#   -----------------------------

    cd () { builtin cd "${@}" && ll; }          # always list directory contents upon 'cd'
    ccd () { builtin cd "${@}" }                # cdd: buildin cd command (used for directories with huge number of files inside)
    mcd () { mkdir -p "${1}" && cd "${1}"; }    # mcd: makes new dir and jumps inside
    mvcd () { mv "${1}" "${2}" && cd "${2}" }   # mvcd moves directory to target and cd into it

    function genpwd() {
        local length="${1}"

        local max_length="256"
        local max_length_with_buffer="$(( max_length * 2 ))"

        if [[ ${length} -gt ${max_length} ]]; then
            >&2 echo "Error: length exceeds max length [${max_length}]."
            return 1
        fi

        openssl rand -base64 ${max_length} | tr "\n" '.' | tr -dc _A-Z-a-z-0-9 | cut -c 1-${1}
    }

    # please
    function pls() {
        local last_command answer

        last_command="$(fc -ln -1)"

        echo
        echo "sudo ${last_command}"
        echo
        ansi -n --bold "Want to run this command with sudo? ["
        ansi -n --bold --green "enter"
        ansi -n --bold "/"
        ansi -n --bold --red "ctrl+c"
        ansi -n --bold "] "
        read -r answer
        echo

        sudo "${SHELL}" -c "${last_command}"
    }
