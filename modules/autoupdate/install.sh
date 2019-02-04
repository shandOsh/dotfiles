echo "› installing autoupdate module"

(
    crontab -l | grep -v "dot_update"
    echo "0 */2 * * * '${DOTFILES_ROOT}/bin/dot_update' &> '${DOTFILES_ROOT}/dot_update.log'"
) | crontab -

report_status "installation complete" "installation failed"
