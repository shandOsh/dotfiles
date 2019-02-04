echo "› installing autoupdate module"

(
    crontab -l | grep -v "dot_update"
    echo "0 */2 * * * '${DOTFILES_MODULES_ROOT}/bin/dot_update' > '${DOTFILES_ROOT}/dot_update.log' 2>&1"
) | crontab -

report_status "installation complete" "installation failed"
