#! /usr/bin/env bash

function success() {
    local message="$(echo "${1}" | string_replace --global "${HOME}" "~")"

    printf "\r\033[2K  [  \033[00;32mOK\033[0m  ] %s\n" "${message}"
}

function fail() {
    local message="$(echo "${1}" | string_replace --global "${HOME}" "~")"

    printf "\r\033[2K  [ \033[0;31mFAIL\033[0m ] %s\n" "${message}"
}

function info() {
    local message="$(echo "${1}" | string_replace --global "${HOME}" "~")"

    printf "\r  [ \033[00;33mINFO\033[0m ] %s\n" "${message}"
}

function skipped() {
    local message="$(echo "${1}" | string_replace --global "${HOME}" "~")"

    printf "\r  [ \033[00;34mSKIP\033[0m ] %s\n" "${message}"
}

function report_status() {
    local rc_of_last_command="${?}" # ! has to be on the 1st line

    local message_success="${1}"
    local message_failure="${1}"

    if [[ ${#} -eq 2 ]]; then
        message_failure="${2}"
    fi

    if [[ ${rc_of_last_command} -eq 0 ]]; then
        success "${message_success}"
    else
        fail "${message_failure}"
    fi
}

function string_replace() {
    local search=""
    local replace=""
    local subject=""
    local global=""

    local search_found=0
    local replace_found=0

    while [[ ${#} -ne 0 ]] && [[ "${1}" != "" ]]; do
        case ${1} in
            --global)
                global="g"
            ;;

            *)
                if [[ ${search_found} -eq 0 ]]; then
                    search="${1}"
                    search_found=1
                elif [[ ${replace_found} -eq 0 ]]; then
                    replace="${1}"
                    replace_found=1
                else
                    >&2 echo "Unknown input argument."
                    return 1
                fi
            ;;
        esac

        shift
    done

    read subject < /dev/stdin

    local search_quoted="$(printf '%s' "${search}" | sed 's/[#\]/\\\0/g')"
    local replace_quoted="$(printf '%s' "${replace}" | sed 's/[#\]/\\\0/g')"
    local subject_quoted="$(printf '%s' "${subject}" | sed 's/[#\]/\\\0/g')"

    if [[ "${search_quoted}" == "" ]]; then
        >&2 echo "Search cannot be empty."
        return 1
    elif [[ "${replace_quoted}" == "" ]]; then
        >&2 echo "Replace cannot be empty."
        return 1
    elif [[ "${subject_quoted}" == "" ]]; then
        >&2 echo "Subject cannot be empty."
        return 1
    fi

    echo "${subject_quoted}" | sed "s#${search_quoted}#${replace_quoted}#${global}"
}

function backup_file() {
    local backup_file="${1}"

    if [[ ! -e "${backup_file}" ]]; then
        info "no backup needed (${backup_file} doesn't exist)"
        return 0
    fi

    mv "${backup_file}" "${backup_file}.backup"
    report_status "backing up ${backup_file}"
}

function link_file() {
    local source="${1}"
    local target="${2}"

    if [[ "$(readlink "${target}")" == "${source}" ]]; then
        skipped "no need to link ${source}, it's already symlinked"
        return 0
    fi

    backup_file "${target}"

    local dirpath="$(dirname "${target}")"

    if [[ ! -d "${dirpath}" ]]; then
        mkdir -p "${dirpath}"
        report_status "creating directory ${dirpath} for target ${target}"
    fi

    ln -nfs "${source}" "${target}"
    report_status "linking ${source} to ${target}"
}

function os_detection() {
    export DOTFILES_OS="undefined"

    export readonly DOTFILES_OS_MACOS="macos"
    export readonly DOTFILES_OS_LINUX="linux"
    export readonly DOTFILES_OS_AIX="aix"
    export readonly DOTFILES_OS_WINDOWS="windows"

    case "$(uname -s)" in
        Darwin) DOTFILES_OS="${DOTFILES_OS_MACOS}" ;;
         Linux) DOTFILES_OS="${DOTFILES_OS_LINUX}" ;;
           AIX) DOTFILES_OS="${DOTFILES_OS_AIX}" ;;
    esac
}

function macos_version() {
    sw_vers -productVersion
}

function is_installed() {
    command which "${1}" &> /dev/null && return 0

    # consider using -s flag
    # command which -s "${1}" && return 0

    return 1
}

function prompt_component_precmd_append() {
    local component="${1}"

    DOTFILES_PROMPT_PRECMD_COMPONENTS+=("${component}")
}

function prompt_postexec_component_append() {
    local component="${1}"

    DOTFILES_PROMPT_POSTEXEC_COMPONENTS+=("${component}")
}

function crontab_apply() {
    local crontab_command="${1}"
    local grep_match="${2}"

    (
        crontab -l | grep -v "${grep_match}"
        echo "${crontab_command}"
    ) | crontab -
}

function is_dark_mode_on() {
    case "${DOTFILES_OS}" in
        "${DOTFILES_OS_MACOS}")
            defaults read -g AppleInterfaceStyle &> /dev/null
        ;;

        *)
            return 1
    esac
}

function load_theme_colors() {
    # in case color palette is not found, set a horrible one to notice
    local theme_fg="#ffffff"
    local theme_bg="#ff0000"
    local theme_primary_fg="#000000"
    local theme_primary_bg="#00ff00"
    local theme_secondary_fg="#ffffff"
    local theme_secondary_bg="#000000"
    local theme_tertiary_fg="#ffffff"
    local theme_tertiary_bg="#0000ff"

    local has_loading_failed=0

    # TODO: use constants
    local theme="light"

    if is_dark_mode_on; then
        theme="dark";
    fi

    local theme_filepath="${DOTFILES_THEMES_ROOT}/palette.${theme}.conf"

    if [[ -r "${theme_filepath}" ]]; then
        source "${theme_filepath}" || has_loading_failed=1
    fi

    export DOTFILES_THEME_FG="${theme_fg}"
    export DOTFILES_THEME_BG="${theme_bg}"
    export DOTFILES_THEME_PRIMARY_FG="${theme_primary_fg}"
    export DOTFILES_THEME_PRIMARY_BG="${theme_primary_bg}"
    export DOTFILES_THEME_SECONDARY_FG="${theme_secondary_fg}"
    export DOTFILES_THEME_SECONDARY_BG="${theme_secondary_bg}"
    export DOTFILES_THEME_TERTIARY_FG="${theme_tertiary_fg}"
    export DOTFILES_THEME_TERTIARY_BG="${theme_tertiary_bg}"

    return ${has_loading_failed}
}
