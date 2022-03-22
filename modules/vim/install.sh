#! /usr/bin/env bash

echo "› installing vim module"

link_file "${DOTFILES_MODULES_ROOT}/vim/.vimrc" "${HOME}/.vimrc"

success "installation complete"
