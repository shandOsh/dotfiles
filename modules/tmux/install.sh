echo "› installing tmux module"

link_file "${DOTFILES_MODULES_ROOT}/tmux/.tmux.conf" "${HOME}/.tmux.conf"

if [[ ! -d "${HOME}/.tmux" ]]; then
    mkdir -p "${HOME}/.tmux"
    report_status "creating directory ${HOME}/.tmux"
fi

link_file "${DOTFILES_MODULES_ROOT}/tmux/conf" "${HOME}/.tmux/conf"

success "installation complete"

if ! is_installed "tmux"; then
    skipped "tmux is not installed, post-installation steps won't be run"
    return
fi

crontab_apply \
    "* * * * * { source '${DOTFILES_LIBS_ROOT}/helpers.sh' && os_detection && '${DOTFILES_ROOT}/bin/tmux_set_theme'; } >> /tmp/tmux_set_theme.log 2>&1" \
    "tmux_set_theme"

report_status "applying crontab job"

# reload config
tmux source-file ~/.tmux.conf
report_status "reloading configuration"

success "post-installation steps completed"
