#! /usr/bin/env bash

report_install "fzf"

link_file "${DOTFILES_MODULES_ROOT}/fzf/.fzf.zsh" "${HOME}/.fzf.zsh"

success "installation complete"
