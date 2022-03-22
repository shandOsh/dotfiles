#! /usr/bin/env bash

echo "› installing karabiner-elements module"

if [[ "${DOTFILES_OS}" != "macos" ]]; then
    skipped "this is not a macOS"
    return 0
fi

if [[ ! -d "${HOME}/.config/karabiner" ]]; then
    mkdir -p "${HOME}/.config/karabiner"
    report_status "creating directory ${HOME}/.config/karabiner"
fi

link_file "${DOTFILES_MODULES_ROOT}/karabiner/karabiner.json" "${HOME}/.config/karabiner/karabiner.json"
link_file "${DOTFILES_MODULES_ROOT}/karabiner/assets/complex_modifications/win-cz.hp-elitebook-840-g3.json" "${HOME}/.config/karabiner/assets/complex_modifications/win-cz.hp-elitebook-840-g3.json"

success "installation complete"
