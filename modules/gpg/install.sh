echo "› installing gpg module"

if is_installed "gpg"; then
    if [[ ! -d "${HOME}/.gnupg" ]]; then
        mkdir "${HOME}/.gnupg"
        report_status "creating directory ${HOME}/.gnupg"
    fi

    link_file "${DOTFILES_MODULES_ROOT}/gpg/gpg.conf" "${HOME}/.gnupg/gpg.conf"

    gpgagent_restart_needed=0

    if [[ "${DOTFILES_OS}" == "macos" ]]; then
        if is_installed "/usr/local/bin/pinentry-mac"; then
            link_file "${DOTFILES_MODULES_ROOT}/gpg/gpg-agent.macos.conf" "${HOME}/.gnupg/gpg-agent.conf"
            gpgagent_restart_needed=1
        else
            fail "/usr/local/bin/pinentry-mac is not installed yet"
        fi
    fi

    # restart gpg-agent
    if [[ ${gpgagent_restart_needed} -eq 1 ]]; then
        case "${DOTFILES_OS}" in
            macos|linux)
                killall gpg-agent
                report_status "restarting gpg-agent"
            ;;

            *)
                info "you have to manually restart gpg-agent"
            ;;
        esac
    fi
else
    skipped "gpg is not installed"
    return
fi

success "installation complete"
