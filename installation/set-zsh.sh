echo
echo "Setting ZSH as default shell"
echo

echo "› setting path to zsh"

case "${DOTFILES_OS}" in
    macos)
        DOTFILES_SHELL="/opt/homebrew/bin/zsh"
    ;;

    linux)
        DOTFILES_SHELL="/bin/zsh"
    ;;

    aix)
        DOTFILES_SHELL="/usr/bin/zsh"
    ;;

    *)
        fail "this OS is not supported"
        return 1
esac

if ! is_installed "${DOTFILES_SHELL}"; then
    skipped "${DOTFILES_SHELL} is not installed"
    return 1
fi

echo "› setting ${DOTFILES_SHELL} as default shell"

case "${DOTFILES_OS}" in
    macos|linux)
        echo
        chsh -s "${DOTFILES_SHELL}" "${USER}" 1>/dev/null
    ;;

    aix)
        echo
        chsh "${USER}" "${DOTFILES_SHELL}" 1>/dev/null
    ;;

    *)
        fail "this OS is not supported"
        return 1
esac

report_status "default shell set to ${DOTFILES_SHELL}" \
              "default shell couldn't be set to ${DOTFILES_SHELL}"
