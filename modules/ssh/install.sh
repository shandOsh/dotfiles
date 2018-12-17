echo "› installing ssh module"

# if our version is > 7.3, abort the installation,
# because at least openssl 7.3 is required for Include directive to work

ssh_version="$(ssh -V 2>&1 | egrep --only-matching '^OpenSSH_\d+\.\d+' | egrep --only-matching '\d+\.\d+')"
ssh_version_major="$(echo "${ssh_version}" | cut -d. -f 1)"
ssh_version_minor="$(echo "${ssh_version}" | cut -d. -f 2)"
ssh_version_is_valid=1

if [[ "${ssh_version}" == "" ]]; then
    fail "Cannot parse openSSH version."
    return 1
fi

if [[ "${ssh_version_major}" -lt 7 ]]; then
    ssh_version_is_valid=0
elif [[ "${ssh_version_major}" -eq 7 ]] && [[ "${ssh_version_minor}" -lt 3 ]]; then
    ssh_version_is_valid=0
fi

if [[ "${ssh_version_is_valid}" -eq 0 ]]; then
    fail "Your openSSH version (${ssh_version}) is not supported. Version 7.3 and newer is required."
    return 1
else
    info "Your openSSH version (${ssh_version}) is supported."
fi

if [[ ! -e "${HOME}/.ssh/config.local" ]]; then
    if [[ -f "${HOME}/.ssh/config" ]] && [[ ! -L "${HOME}/.ssh/config" ]]; then
        mv "${HOME}/.ssh/config" "${HOME}/.ssh/config.local"
        success "~/.ssh/config moved to ~/.ssh/config.local"
    else
        touch "${HOME}/.ssh/config.local"
        success "creating empty ~/.ssh/config.local"
    fi
fi

link_file "${DOTFILES_MODULES_ROOT}/ssh/config" "${HOME}/.ssh/config"
link_file "${DOTFILES_MODULES_ROOT}/ssh/config.d" "${HOME}/.ssh/config.d"

success "installation complete"
