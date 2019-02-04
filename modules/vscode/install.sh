echo "› installing vscode module"

case "${DOTFILES_OS}" in
    macos)
        VSCODE_HOME="${HOME}/Library/Application Support/Code"
        info "setting home of VS Code for macOS"
    ;;

    linux)
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
Kasik96.latte
codezombiech.gitignore
felixfbecker.php-intellisense
georgewfraser.vscode-javac
James-Yu.latex-workshop
ms-python.python
odubuc.mysql-inline-decorator
redhat.java
vscjava.vscode-java-debug
vscjava.vscode-java-pack
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
