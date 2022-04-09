#! /usr/bin/env bash

report_install "zsh"

link_file "${DOTFILES_MODULES_ROOT}/zsh/.zshrc" "${HOME}/.zshrc"

success "installation complete"
