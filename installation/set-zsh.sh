echo
echo "Setting ZSH as default shell"
echo

if ! is_installed "zsh"; then
    skipped "zsh is not installed"
fi

DOTFILES_SHELL="$(which zsh)"

case "${DOTFILES_OS}" in
    macos)
        DOTFILES_SHELL="/bin/zsh"

        chsh -s "${DOTFILES_SHELL}" "${USER}" 1>/dev/null
    ;;

    aix)
        DOTFILES_SHELL="/usr/bin/zsh"

        chsh "${USER}" "${DOTFILES_SHELL}" 1>/dev/null
    ;;

    linux)
        DOTFILES_SHELL="/bin/zsh"

        chsh -s "${DOTFILES_SHELL}" "${USER}" 1>/dev/null
    ;;

    *)
        fail "this OS is not supported"
        return 1
esac

report_status "default shell set to ${DOTFILES_SHELL}" \
              "default shell couldn't be set to ${DOTFILES_SHELL}"
