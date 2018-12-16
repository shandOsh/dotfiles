echo "› installing gpg module"

if [[ -d ~/.gnupg ]]; then
    link_file "${DOTFILES_MODULES_ROOT}/gpg/gpg.conf" "${HOME}/.gnupg/gpg.conf"
    # TODO: first check, if pinentry-mac is installed
    link_file "${DOTFILES_MODULES_ROOT}/gpg/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"
    # TODO: restart gpg-agent
else
    info "no action required"
    return
fi

success "installation complete"
