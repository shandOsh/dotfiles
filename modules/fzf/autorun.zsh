#   -------------------------------
#   11.  MODULE AUTORUN FILES
#   -------------------------------

    if ! is_installed "fzf"; then
        return
    fi

    [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
