echo "› installing gpg module"

if [[ -d ~/.gnupg ]]; then
    link_file "${DOTFILES_MODULES_ROOT}/gpg/gpg.conf" "${HOME}/.gnupg/gpg.conf"

    if [[ "${DOTFILES_OS}" == "macos" ]]; then
        if is_installed "/usr/local/bin/pinentry-mac"; then
            link_file "${DOTFILES_MODULES_ROOT}/gpg/gpg-agent.macos.conf" "${HOME}/.gnupg/gpg-agent.conf"
        else
            fail "/usr/local/bin/pinentry-mac is not installed yet"
        fi
    fi

    # TODO: restart gpg-agent
else
    info "no action required"
    return
fi

success "installation complete"
