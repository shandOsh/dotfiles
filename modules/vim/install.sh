#! /usr/bin/env bash

report_install "vim"

link_file "${DOTFILES_MODULES_ROOT}/vim/.vimrc" "${HOME}/.vimrc"

success "installation complete"
