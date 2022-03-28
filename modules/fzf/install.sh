#! /usr/bin/env bash

echo "› installing fzf module"

link_file "${DOTFILES_MODULES_ROOT}/fzf/.fzf.zsh" "${HOME}/.fzf.zsh"

success "installation complete"
