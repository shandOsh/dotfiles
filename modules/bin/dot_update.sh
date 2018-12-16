#! /usr/bin/env bash

echo
echo "Running update script"

# setup envvar
echo "› setting up environmental variables"

export DOTFILES_ROOT="${HOME}/.dotfiles"
export DOTFILES_MODULES_ROOT="${DOTFILES_ROOT}/modules"
export DOTFILES_INSTALLATION_ROOT="${DOTFILES_ROOT}/installation"

cd "${DOTFILES_ROOT}" || ( >&2 echo "Cannot cd into ${DOTFILES_ROOT}."; exit 1 ) || exit 1

# fixes PATH (we could be running from the crontab)
PATH="$(command -p getconf PATH):/usr/local/bin"

# load custom config if any
if [[ -r ~/.localrc ]]; then
    echo "› loading custom config ~/.localrc"
    . ~/.localrc
fi

# ssh would not work under cron, add a https one
echo "› setting up update channel"
git remote add updates "https://github.com/Hologos/dotfiles.git" 2>/dev/null

# Update repo
echo "› git update"
git pull --rebase --stat updates "$(git rev-parse --abbrev-ref HEAD)"

# load helpers
echo "› loading helper functions"

. "${DOTFILES_INSTALLATION_ROOT}/helpers.sh"

os_detection

# run generic install script
. "${DOTFILES_INSTALLATION_ROOT}/install.sh"

echo "› registering last update"
git config --global dotfiles.lastupdate "$(date +'%d.%m.%Y %H:%M')"
