#   -----------------------------
#   4.  ALIASES
#   -----------------------------

    # ___ macOS specific aliases ___
    if [[ "${DOTFILES_OS}" == "${DOTFILES_OS_MACOS}" ]]; then
        # TODO: somehow get rid of running subshell to find out if dark mode is active
        alias bat="bat --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo default || echo GitHub)"
    fi

#   -----------------------------
#   5.  FUNCTIONS
#   -----------------------------
