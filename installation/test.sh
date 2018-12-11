#! /usr/bin/env bash

echo
echo "================"
echo "= RUNNING TEST ="
echo "================"
echo

export HOME="/tmp/dotfiles.test"
export DOTFILES_ROOT="${HOME}/.dotfiles"

# if [[ -d "${HOME}" ]]; then
#     echo "You have to manually remove fake \$HOME directory (pointing to ${HOME})."
#     exit 1
# fi

mkdir -p "${DOTFILES_ROOT}"

cp -r * "${DOTFILES_ROOT}/"

echo "All is set, running bootstrap script"

"${DOTFILES_ROOT}/installation/bootstrap.sh"
