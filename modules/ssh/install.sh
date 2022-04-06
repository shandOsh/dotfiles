#! /usr/bin/env bash

echo "› installing ssh module"

# if our version of openSSH is lower than 7.3, abort the installation,
# because the directive Include is not implemented
ssh_version="$(ssh -V 2>&1 | grep -E --only-matching '^OpenSSH_[0-9]+(\.[0-9]+){1,3}' | sed 's/OpenSSH_//g')"

if require_version "${ssh_version}" ">=" "7.3"; then
    info "your openSSH version ${ssh_version} is supported"
else
    fail "your openSSH version ${ssh_version} is not supported, version 7.3 or newer is required"
    return 1
fi

if [[ ! -d "${HOME}/.ssh" ]]; then
    mkdir "${HOME}/.ssh"
    chmod 700 "${HOME}/.ssh"
fi

if [[ ! -e "${HOME}/.ssh/config.local" ]]; then
    if [[ -f "${HOME}/.ssh/config" ]] && [[ ! -L "${HOME}/.ssh/config" ]]; then
        mv "${HOME}/.ssh/config" "${HOME}/.ssh/config.local"
        report_status "moving ${HOME}/.ssh/config to ${HOME}/.ssh/config.local"
    else
        touch "${HOME}/.ssh/config.local"
        success "creating empty ${HOME}/.ssh/config.local"
    fi
fi

link_file "${DOTFILES_MODULES_ROOT}/ssh/config" "${HOME}/.ssh/config"
link_file "${DOTFILES_MODULES_ROOT}/ssh/config.d" "${HOME}/.ssh/config.d"

success "installation complete"
