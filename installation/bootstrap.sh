#! /usr/bin/env bash

echo
echo "Running bootstrap"

# setup envvar
echo "> setting up environmental variables"

export DOTFILES_ROOT="${HOME}/.dotfiles"
export DOTFILES_MODULES_ROOT="${DOTFILES_ROOT}/modules"
export DOTFILES_INSTALLATION_ROOT="${DOTFILES_ROOT}/installation"

# load helpers
echo "> loading helper functions"

. "${DOTFILES_INSTALLATION_ROOT}/helpers.sh"

os_detection

# run generic install script
. "${DOTFILES_INSTALLATION_ROOT}/install.sh"

# set zsh as default shell
. "${DOTFILES_INSTALLATION_ROOT}/set-zsh.sh"
