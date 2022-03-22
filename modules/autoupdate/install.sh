#! /usr/bin/env bash

echo "› installing autoupdate module"

crontab_apply \
    "0 */2 * * * '${DOTFILES_ROOT}/bin/dot_update' &> '${DOTFILES_ROOT}/dot_update.log'" \
    "dot_update"

report_status "installation complete" "installation failed"
