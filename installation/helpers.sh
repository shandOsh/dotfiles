function success() {
    printf "\r\033[2K  [  \033[00;32mOK\033[0m  ] $1\n"
}

function fail() {
    printf "\r\033[2K  [ \033[0;31mFAIL\033[0m ] $1\n"

    exit 1
}

function info() {
    printf "\r  [ \033[00;33mINFO\033[0m ] $1\n"
}

function skipped() {
    printf "\r  [ \033[00;34mSKIP\033[0m ] $1\n"
}

function backup_file() {
    local backup_file="$1"

    if [[ ! -e "${backup_file}" ]]; then
        info "no backup needed (${backup_file} doesn't exist)"
        return 0
    fi

    success "backing up ${backup_file}"
    mv "${backup_file}" "${backup_file}.backup"
}

function link_file() {
    local source="$1"
    local target="$2"

    if [[ "$(readlink "${target}")" == "${source}" ]]; then
        skipped "no need to link ${source}, it's already symlinked"
        return 0
    fi

    backup_file "${target}"

    success "linking ${source} to ${target}"
    ln -nfs "${source}" "${target}"
}

function os_detection() {
    export DOTFILES_OS="undefined"

    case "$(uname -s)" in
        Darwin) DOTFILES_OS="macos" ;;
         Linux) DOTFILES_OS="linux" ;;
           AIX) DOTFILES_OS="aix" ;;
    esac
}
