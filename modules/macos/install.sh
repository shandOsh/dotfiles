#! /usr/bin/env bash

echo "› installing macos module"

if [[ "${DOTFILES_OS}" != "macos" ]]; then
    skipped "this is not a macOS"
    return 0
fi

success "installation complete"
