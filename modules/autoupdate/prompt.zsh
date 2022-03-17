#   -------------------------------
#   7.  PROMPT
#   -------------------------------

    function dotfiles_prompt_autoupdate_status() {
        if [[ ! -e "${DOTFILES_ROOT}/.dot_update" ]]; then
            return
        fi

        echo -n "${DOTFILES_PROMPT_COMPONENT_LEFT}"
        ansi --no-newline --bold --color=${FMT_RED} "!!! update failed !!!"
        echo -n "${DOTFILES_PROMPT_COMPONENT_RIGHT}"
    }

    prompt_component_precmd_append '$(dotfiles_prompt_autoupdate_status)'
    prompt_generate
