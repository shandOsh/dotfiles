#! /usr/bin/env bash

echo "› installing git module"

# if config is not managed by dotfiles, install the files
if [ "$(git config --global --get dotfiles.managed)" != "true" ]; then
    info "git is not managed, running managing sequence"

    # unlike in ssh module, where config is renamed to config.local,
    # here we just back it up, we don't want to load a config with
    # global user.name and user.email.
    backup_file "${HOME}/.gitconfig"
else
    info "git is managed"
fi

# save current commit-id and also save last commit-id
current_commit_id="$(git rev-parse --short HEAD)"
previous_commit_id="$(git config --global --get dotfiles.version)"

if [[ "${previous_commit_id}" != "${current_commit_id}" ]]; then
    info "recording new version commit-id"

    git config --global dotfiles.oldversion "${previous_commit_id}"
    git config --global dotfiles.version "${current_commit_id}"
fi

link_file "${DOTFILES_MODULES_ROOT}/git/.gitconfig.local" "${HOME}/.gitconfig.local"
link_file "${DOTFILES_MODULES_ROOT}/git/.gitignore.global" "${HOME}/.gitignore.global"

case "${DOTFILES_OS}" in
    macos|linux|aix)
        # unix
        git config --global core.autocrlf input
        git config --global core.safecrlf true
    ;;

    *)
        # windows
        git config --global core.autocrlf true
        git config --global core.safecrlf true
esac

# include the gitconfig.local file
git config --global include.path ~/.gitconfig.local

# finally make git know, this is a managed config (preventing later overrides by this script)
git config --global dotfiles.managed true

success "installation complete"
