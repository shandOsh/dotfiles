#   -----------------------------
#   0.  SHELL CONFIGURATION
#   -----------------------------

    # setopt autocd                             # if a command is issued that can't be executed as a normal command, and the command is the name of a directory, perform the cd command to that directory
    setopt nomatch                              # if a pattern for filename generation has no matches, print an error, instead of leaving it unchanged in the argument list
    setopt notify                               # report the status of background jobs immediately, rather than waiting until just before printing a prompt
    setopt extendedglob                         # treat the '#', '~' and '^' characters as part of patterns for filename generation, etc (an initial unquoted '~' always produces named directory expansion)
    setopt correct                              # try to correct the spelling of commands
    setopt PROMPT_SUBST                         # do expansion on prompt
    setopt globdots                             # suggest files beginning with dot in completion

    bindkey -v                                  # vi mode

    zstyle :compinstall filename "${HOME}/.zshrc"

    autoload -Uz compinit
    compinit

#   -----------------------------
#   1.  UNDER THE HOOD STUFF
#   -----------------------------

    export DOTFILES_ROOT="${HOME}/.dotfiles"
    export DOTFILES_LIBS_ROOT="${DOTFILES_ROOT}/libs"
    export DOTFILES_MODULES_ROOT="${DOTFILES_ROOT}/modules"
    export DOTFILES_INSTALLATION_ROOT="${DOTFILES_ROOT}/installation"
    export DOTFILES_THEMES_ROOT="${DOTFILES_ROOT}/themes"

    . "${DOTFILES_LIBS_ROOT}/fidian/ansi/ansi"
    . "${DOTFILES_LIBS_ROOT}/formatting.sh"
    . "${DOTFILES_LIBS_ROOT}/helpers.sh"

    os_detection
    load_theme_colors
#   -----------------------------
#   2. PROXY SETTINGS
#   -----------------------------
#    export http_proxy=http://milakrom:363Z4mp0rt4l363@http-proxy.cezdata.corp:8080
#    export https_proxy=http://milakrom:363Z4mp0rt4l363@http-proxy.cezdata.corp:8080
#    export HTTP_PROXY=http://milakrom:363Z4mp0rt4l363@http-proxy.cezdata.corp:8080
#    export HTTPS_PROXY=http://milakrom:363Z4mp0rt4l363@http-proxy.cezdata.corp:8080
                  
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

#   ___ load history from all history.zsh files ___
    source "${DOTFILES_MODULES_ROOT}/zsh/history.zsh"

    for history_file in $(find "${DOTFILES_MODULES_ROOT}" -name "history.zsh" | egrep -v 'zsh\/history\.zsh$'); do
        source "${history_file}"
    done

#   ___ load prompts from all prompt.zsh files ___
    source "${DOTFILES_MODULES_ROOT}/zsh/prompt.zsh"

    for prompt_file in $(find "${DOTFILES_MODULES_ROOT}" -name "prompt.zsh" | egrep -v 'zsh\/prompt\.zsh$'); do
        source "${prompt_file}"
    done

#   -----------------------------
#   9.  LOAD LOCAL CONFIG
#   -----------------------------

#   ___ use .localrc for local configuration ___
    [[ -f "${HOME}/.localrc" ]] && . "${HOME}/.localrc"

#   -----------------------------
#   10.  RUN PROGRAMS / COMMANDS
#   -----------------------------

#   ___ display dotfiles version ___
    dotfiles_version

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
