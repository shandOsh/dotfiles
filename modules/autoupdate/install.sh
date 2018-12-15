echo "> installing autoupdate module"

(
    crontab -l | grep -v "dot_update.sh"
    echo "0 */2 * * * '${DOTFILES_ROOT}/bin/dot_update.sh' > '${DOTFILES_ROOT}/dot_update.log' 2>&1"
) | crontab -

success "installation complete"
