echo "› installing tmux module"

if ! is_installed "tmux"; then
    skipped "tmux is not installed"
    return
fi

link_file "${DOTFILES_MODULES_ROOT}/tmux/.tmux.conf" "${HOME}/.tmux.conf"

if [[ ! -d "${HOME}/.tmux" ]]; then
    mkdir -p "${HOME}/.tmux"
    report_status "creating directory ${HOME}/.tmux"
fi

link_file "${DOTFILES_MODULES_ROOT}/tmux/conf" "${HOME}/.tmux/conf"

# reload config
tmux source-file ~/.tmux.conf
report_status "reloading configuration"

success "installation complete"
