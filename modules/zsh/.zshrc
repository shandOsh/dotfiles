#   -----------------------------
#   0.  SHELL CONFIGURATION
#   -----------------------------

    # setopt autocd                             # if a command is issued that can't be executed as a normal command, and the command is the name of a directory, perform the cd command to that directory
    setopt nomatch                              # if a pattern for filename generation has no matches, print an error, instead of leaving it unchanged in the argument list
    setopt notify                               # report the status of background jobs immediately, rather than waiting until just before printing a prompt
    setopt extendedglob                         # treat the '#', '~' and '^' characters as part of patterns for filename generation, etc (an initial unquoted '~' always produces named directory expansion)
    setopt correct                              # try to correct the spelling of commands

    bindkey -v                                  # vi mode

    zstyle :compinstall filename "${HOME}/.zshrc"

    autoload -Uz compinit
    compinit

#   ___ history configuration ___
    export HISTFILE="${HOME}/.zhistory"
    export HISTSIZE=1000
    export SAVEHIST=1000

    setopt incappendhistory                     # append history to history files as soon as it is executed rather than waiting until shell exits
    setopt histignoredups                       # dont save command if it's a duplicate of last command

#   -----------------------------
#   1.  UNDER THE HOOD STUFF
#   -----------------------------

    export DOTFILES_ROOT="${HOME}/.dotfiles"
    export DOTFILES_MODULES_ROOT="${DOTFILES_ROOT}/modules"
    export DOTFILES_INSTALLATION_ROOT="${DOTFILES_ROOT}/installation"

    . "${DOTFILES_INSTALLATION_ROOT}/helpers.sh"

    os_detection

#   -----------------------------
#   8.  MODULE CONFIGS
#   -----------------------------

#   ___ load environmental variables from all envvars.zsh files ___
    for envvar_file in $(find "${DOTFILES_MODULES_ROOT}" -name "envvars.zsh"); do
        source "${envvar_file}"
    done

#   ___ load paths from all paths.zsh files ___
    for path_file in $(find "${DOTFILES_MODULES_ROOT}" -name "paths.zsh"); do
        source "${path_file}"
    done

#   ___ load aliases from all aliases.zsh files ___
    for alias_file in $(find "${DOTFILES_MODULES_ROOT}" -name "aliases.zsh"); do
        source "${alias_file}"
    done

#   ___ load prompt from prompt.zsh ___
    source "${DOTFILES_MODULES_ROOT}/zsh/prompt.zsh"

#   -----------------------------
#   9.  LOAD LOCAL CONFIG
#   -----------------------------

#   ___ use .localrc for local configuration ___
    [[ -f "${HOME}/.localrc" ]] && . "${HOME}/.localrc"
