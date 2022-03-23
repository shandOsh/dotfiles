#! /usr/bin/env bash

prerequisites_error=0

if ! is_installed "git"; then
    prerequisites_error=1

    fail "git is not installed"
else
    success "git is installed"
fi

if ! is_installed "zsh"; then
    prerequisites_error=1

    fail "zsh is not installed"
else
    success "zsh is installed"
fi

if ! is_installed "ansi"; then
    prerequisites_error=1

    fail "ansi is not installed"
else
    success "ansi is installed"
fi

case "${DOTFILES_OS}" in
    "${DOTFILES_OS_MACOS}")
        current_macos_version="$(macos_version)"

        case "${current_macos_version}" in
            12.* )
                success "macOS ${current_macos_version} is supported"
            ;;

            * )
                fail "macOS 12 or higher is required (current version is macOS ${current_macos_version})"
        esac
    ;;
esac

if [[ ${prerequisites_error} -ne 0 ]]; then
    fail "prerequisites are not met, aborting"
    exit 1
fi
