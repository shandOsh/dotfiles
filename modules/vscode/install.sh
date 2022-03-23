#! /usr/bin/env bash

echo "› installing vscode module"

case "${DOTFILES_OS}" in
    "${DOTFILES_OS_MACOS}")
        VSCODE_HOME="${HOME}/Library/Application Support/Code"
        info "setting home of VS Code for macOS"
    ;;

    "${DOTFILES_OS_LINUX}")
        VSCODE_HOME="${HOME}/.config/Code"
        info "setting home of VS Code for linux"
    ;;

    *)
        fail "this OS (${DOTFILES_OS}) is not supported"
        return 1
esac

if [[ ! -d "${VSCODE_HOME}/User" ]]; then
    mkdir -p "${VSCODE_HOME}/User"
    report_status "creating home of VS Code ${VSCODE_HOME}"
fi

link_file "${DOTFILES_MODULES_ROOT}/vscode/settings.json" "${VSCODE_HOME}/User/settings.json"
link_file "${DOTFILES_MODULES_ROOT}/vscode/keybindings.json" "${VSCODE_HOME}/User/keybindings.json"

success "installation complete"

if ! is_installed "code"; then
    skipped "code is not installed, post-installation steps won't be run"
    return
fi

# from `code --list-extensions`
extensions="
ban.spellright
codezombiech.gitignore
DotJoshJohnson.xml
felixfbecker.php-intellisense
James-Yu.latex-workshop
Kasik96.latte
LaurentTreguier.uncrustify
mads-hartmann.bash-ide-vscode
mechatroner.rainbow-csv
ms-python.python
ms-toolsai.jupyter
naco-siren.gradle-language
nobuhito.printcode
odubuc.mysql-inline-decorator
redhat.vscode-yaml
rogalmic.bash-debug
timonwong.shellcheck
Tobiah.language-pde
ToniApps.gcode
VisualStudioExptTeam.vscodeintellicode
"

info "getting list of all installed extensions"
installed_extension="$(code --list-extensions)"

for extension in ${extensions}; do
    if [[ "$(echo "${installed_extension}" | grep "${extension}")" == "" ]]; then
        code --install-extension "${extension}" &> /dev/null
        report_status "installing extension ${extension}"
    else
        skipped "extension ${extension} is already installed"
    fi
done

success "post-installation steps completed"
