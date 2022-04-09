#! /usr/bin/env bash

report_install "macos"

if [[ "${DOTFILES_OS}" != "${DOTFILES_OS_MACOS}" ]]; then
    skipped "this is not a macOS"
    return 0
fi

success "installation complete"
